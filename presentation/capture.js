const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer-core');
const { PDFDocument } = require('pdf-lib');

const OUT = __dirname;
const SHOTS = path.join(OUT, 'shots');
const VIEW_W = 1600;
const VIEW_H = 1000;
const SCALE = 2;
const CHROME = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

fs.mkdirSync(SHOTS, { recursive: true });

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function semantics(page) {
  return page.evaluate(() => {
    const nodes = [...document.querySelectorAll('flt-semantics, [aria-label]')];
    return nodes
      .map((n) => {
        const r = n.getBoundingClientRect();
        const label = (n.getAttribute('aria-label') || n.textContent || '').replace(/\s+/g, ' ').trim();
        return { label, x: r.x, y: r.y, w: r.width, h: r.height };
      })
      .filter((b) => b.label && b.w > 8 && b.h > 8 && b.y >= 0 && b.y < 1000);
  });
}

async function enableSemantics(page) {
  await page.evaluate(() => {
    const node = document.querySelector('flt-semantics-placeholder');
    if (node) node.click();
  });
  await sleep(600);
}

async function clickLabel(page, match) {
  const boxes = await semantics(page);
  const hits = boxes.filter((b) => match.test(b.label)).sort((a, b) => a.w * a.h - b.w * b.h);
  const hit = hits[0];
  if (!hit) {
    const sample = boxes.slice(0, 40).map((b) => b.label).join(' | ');
    throw new Error(`No control matching ${match}. Seen: ${sample}`);
  }
  await page.mouse.click(hit.x + hit.w / 2, hit.y + hit.h / 2);
  await sleep(700);
  return hit;
}

async function shot(page, name) {
  const file = path.join(SHOTS, `${name}.png`);
  await page.screenshot({ path: file, type: 'png' });
  const boxes = await semantics(page);
  fs.writeFileSync(path.join(SHOTS, `${name}.json`), JSON.stringify(boxes, null, 2));
  return { name, file, boxes };
}

function link(page, box, target, pageW, pageH) {
  const x1 = (box.x / VIEW_W) * pageW;
  const yTop = (box.y / VIEW_H) * pageH;
  const x2 = ((box.x + box.w) / VIEW_W) * pageW;
  const y2 = pageH - yTop;
  const y1 = pageH - (((box.y + box.h) / VIEW_H) * pageH);
  const annot = page.doc.context.register(
    page.doc.context.obj({
      Type: 'Annot',
      Subtype: 'Link',
      Rect: [x1, y1, x2, y2],
      Border: [0, 0, 0],
      Dest: [target.ref, 'Fit'],
    }),
  );
  page.node.addAnnot(annot);
}

(async () => {
  const browser = await puppeteer.launch({
    executablePath: CHROME,
    headless: true,
    args: ['--force-device-scale-factor=' + SCALE, '--hide-scrollbars'],
    defaultViewport: { width: VIEW_W, height: VIEW_H, deviceScaleFactor: SCALE },
  });
  const page = await browser.newPage();
  await page.goto('http://localhost:7357', { waitUntil: 'networkidle0', timeout: 120000 });
  await page.waitForSelector('flutter-view, flt-glass-pane', { timeout: 60000 });
  await sleep(1500);
  await enableSemantics(page);

  const frames = [];
  frames.push(await shot(page, '01-welcome-1'));
  await clickLabel(page, /^Continue$/);
  frames.push(await shot(page, '02-welcome-2'));
  await clickLabel(page, /^Continue$/);
  frames.push(await shot(page, '03-welcome-3'));
  await clickLabel(page, /^Get Started$/);
  await sleep(500);
  frames.push(await shot(page, '04-sign-in'));
  await clickLabel(page, /Open Line Display/);
  await sleep(800);

  const portal = [
    ['05-dashboard', null],
    ['06-orders', /^Orders$/],
    ['07-phone-order', /New phone order/],
    ['08-menu', /^Menu Management$/],
    ['09-new-dish', /Add new dish/],
    ['10-customers', /^Customers$/],
    ['11-promotions', /^Promotions$/],
    ['12-new-promotion', /New promotion/],
    ['13-reports', /^Reports$/],
    ['14-settings', /^Settings$/],
    ['15-profile', /Chef Amaka/],
    ['16-notifications', null],
  ];

  for (const [name, matcher] of portal) {
    if (matcher) await clickLabel(page, matcher);
    if (name === '16-notifications') {
      await clickLabel(page, /^Dashboard$/);
      const boxes = await semantics(page);
      const theme = boxes.filter((b) => b.label === 'Dark mode').sort((a, b) => a.w * a.h - b.w * b.h)[0];
      if (!theme) throw new Error('Dark mode button missing');
      await page.mouse.click(theme.x + theme.w + 28, theme.y + theme.h / 2);
      await sleep(700);
    }
    frames.push(await shot(page, name));
  }

  await browser.close();

  const titles = {
    '01-welcome-1': 'Welcome · Party jollof, suya, and egusi',
    '02-welcome-2': 'Welcome · Hot from the fire in 25 minutes',
    '03-welcome-3': 'Welcome · From the pass to Lekki',
    '04-sign-in': 'Sign in',
    '05-dashboard': 'Dashboard',
    '06-orders': 'Orders',
    '07-phone-order': 'New phone order',
    '08-menu': 'Menu management',
    '09-new-dish': 'Add new dish',
    '10-customers': 'Customers',
    '11-promotions': 'Promotions',
    '12-new-promotion': 'New promotion',
    '13-reports': 'Reports',
    '14-settings': 'Settings',
    '15-profile': 'Profile',
    '16-notifications': 'Notifications',
  };

  const pdf = await PDFDocument.create();
  pdf.setTitle('Foodiecall Kitchen Portal');
  pdf.setAuthor('Foodiecall');
  const pages = [];
  for (const frame of frames) {
    const png = await pdf.embedPng(fs.readFileSync(frame.file));
    const pdfPage = pdf.addPage([VIEW_W, VIEW_H]);
    pdfPage.drawImage(png, { x: 0, y: 0, width: VIEW_W, height: VIEW_H });
    pages.push(pdfPage);
  }

  for (const frame of frames) {
    const theme = frame.boxes.filter((b) => b.label === 'Dark mode').sort((a, b) => a.w * a.h - b.w * b.h)[0];
    if (theme) frame.boxes.push({ label: 'notifications', x: theme.x + theme.w + 4, y: theme.y, w: 48, h: theme.h });
  }

  const byName = Object.fromEntries(frames.map((frame, i) => [frame.name, pages[i]]));
  const jumps = [
    [/^Continue$/, 'next'],
    [/^Get Started$/, '04-sign-in'],
    [/^Skip$/, '04-sign-in'],
    [/Open Line Display/, '05-dashboard'],
    [/Get Started \/ Sign In/, '05-dashboard'],
    [/^Dashboard$/, '05-dashboard'],
    [/^Orders$/, '06-orders'],
    [/New phone order/, '07-phone-order'],
    [/^Menu Management$/, '08-menu'],
    [/Add new dish/, '09-new-dish'],
    [/^Customers$/, '10-customers'],
    [/^Promotions$/, '11-promotions'],
    [/New promotion/, '12-new-promotion'],
    [/^Reports$/, '13-reports'],
    [/^Settings$/, '14-settings'],
    [/Chef Amaka/, '15-profile'],
    [/notifications/i, '16-notifications'],
    [/^Kitchen Display$/, '06-orders'],
  ];

  frames.forEach((frame, index) => {
    const pdfPage = pages[index];
    for (const box of frame.boxes) {
      for (const [pattern, target] of jumps) {
        if (!pattern.test(box.label)) continue;
        const destName = target === 'next' ? frames[Math.min(index + 1, frames.length - 1)].name : target;
        if (destName === frame.name) continue;
        link(pdfPage, box, byName[destName], VIEW_W, VIEW_H);
        break;
      }
    }
  });

  const outFile = path.join(OUT, 'Foodiecall-Kitchen-Portal.pdf');
  fs.writeFileSync(outFile, await pdf.save());
  console.log(outFile);
  console.log(frames.map((f) => f.name).join('\n'));
})().catch((error) => {
  console.error(error);
  process.exit(1);
});
