import { useEffect, useState } from "react";
import { motion, AnimatePresence, useScroll, useTransform } from "framer-motion";
import "./Landing.css";

const PLAY_STORE =
  "https://play.google.com/store/apps/details?id=com.foodiecall.kitchen";
const APP_STORE = "https://apps.apple.com/app/foodiecall-kitchen/id0000000000";

// Kitchen webapp lives under /app/ (Flutter onboarding → portal).
const ROOT = (import.meta.env.BASE_URL || "/").endsWith("/")
  ? import.meta.env.BASE_URL || "/"
  : `${import.meta.env.BASE_URL}/`;
const APP_BASE = `${ROOT}app/`;
const ONBOARDING_ENTRY = APP_BASE;

const meals = [
  "Party jollof",
  "Beef suya",
  "Egusi & pounded yam",
  "Ofada & ayamase",
  "Catfish pepper soup",
  "Asun",
  "Zobo",
];

const steps = [
  { title: "Browse", body: "Categories, search, and chef specials." },
  { title: "Build", body: "Portions, extras, and naira totals." },
  { title: "Track", body: "Fire → pack → rider → door." },
  { title: "Run", body: "Kitchen portal for every ticket." },
];

const fadeUp = {
  hidden: { opacity: 0, y: 36 },
  show: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.7, ease: [0.22, 1, 0.36, 1] as const },
  },
};

function PhoneIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden>
      <rect x="7" y="2" width="10" height="20" rx="2" />
      <path d="M11 18h2" />
    </svg>
  );
}

function PotIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden>
      <path d="M4 10h16v6a4 4 0 0 1-4 4H8a4 4 0 0 1-4-4v-6Z" />
      <path d="M8 10V8a4 4 0 0 1 8 0v2" />
      <path d="M2 12h20" />
    </svg>
  );
}

export default function Landing() {
  const [downloadOpen, setDownloadOpen] = useState(false);
  const [mealIndex, setMealIndex] = useState(0);
  const { scrollYProgress } = useScroll();
  const heroShift = useTransform(scrollYProgress, [0, 0.25], [0, 80]);
  const heroFade = useTransform(scrollYProgress, [0, 0.2], [1, 0.35]);

  useEffect(() => {
    const id = window.setInterval(() => {
      setMealIndex((value) => (value + 1) % meals.length);
    }, 2400);
    return () => window.clearInterval(id);
  }, []);

  const openOnboarding = () => window.location.assign(ONBOARDING_ENTRY);

  return (
    <div className="landing">
      <section className="hero">
        <motion.div className="hero-media" style={{ y: heroShift }} aria-hidden />
        <motion.div className="hero-shade" style={{ opacity: heroFade }} />
        <div className="hero-orb hero-orb-a" aria-hidden />
        <div className="hero-orb hero-orb-b" aria-hidden />
        <div className="hero-grain" aria-hidden />

        <div className="hero-inner">
          <motion.header
            className="topbar"
            initial={{ opacity: 0, y: -14 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <div className="brand-lockup">
              <span className="brand-mark" aria-hidden />
              <span className="brand-name">Foodiecall</span>
            </div>
          </motion.header>

          <div className="hero-stage">
            <motion.div
              className="hero-copy"
              initial="hidden"
              animate="show"
              variants={{ show: { transition: { staggerChildren: 0.08 } } }}
            >
              <motion.p className="hero-kicker" variants={fadeUp}>
                Victoria Island · Lagos
              </motion.p>
              <motion.h1 variants={fadeUp}>Foodiecall</motion.h1>
              <motion.p className="hero-lead" variants={fadeUp}>
                Chef-crafted Lagos meals, ordered on call and run from one kitchen
                pass.
              </motion.p>
              <motion.div className="meal-ticker" variants={fadeUp}>
                <span>Tonight on the line</span>
                <AnimatePresence mode="wait">
                  <motion.strong
                    key={meals[mealIndex]}
                    initial={{ opacity: 0, y: 12 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -12 }}
                    transition={{ duration: 0.35 }}
                  >
                    {meals[mealIndex]}
                  </motion.strong>
                </AnimatePresence>
              </motion.div>
              <motion.div className="cta-row" variants={fadeUp}>
                <motion.button
                  type="button"
                  className="btn-primary"
                  onClick={openOnboarding}
                  whileHover={{ y: -3, scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                >
                  Get started
                </motion.button>
                <motion.button
                  type="button"
                  className="btn-ghost"
                  onClick={() => setDownloadOpen(true)}
                  whileHover={{ y: -3, scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                >
                  Download app
                </motion.button>
              </motion.div>
            </motion.div>

            <motion.aside
              className="hero-panel"
              initial={{ opacity: 0, x: 40 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.85, delay: 0.25, ease: [0.22, 1, 0.36, 1] }}
            >
              <div className="hero-panel-glow" aria-hidden />
              <p className="panel-label">Live on the pass</p>
              <h2>₦2.48m</h2>
              <p className="panel-meta">Dinner rush · 14 tickets · fire-to-pack 11m</p>
              <div className="panel-bars" aria-hidden>
                {[0.45, 0.62, 0.5, 0.78, 0.95, 0.7].map((value, index) => (
                  <motion.span
                    key={index}
                    style={{ height: `${value * 100}%` }}
                    initial={{ scaleY: 0 }}
                    animate={{ scaleY: 1 }}
                    transition={{ delay: 0.45 + index * 0.06, duration: 0.55 }}
                  />
                ))}
              </div>
            </motion.aside>
          </div>
        </div>
      </section>

      <section className="marquee" aria-hidden>
        <div className="marquee-track">
          {[...meals, ...meals].map((meal, index) => (
            <span key={`${meal}-${index}`}>{meal}</span>
          ))}
        </div>
      </section>

      <section className="promise">
        <motion.div
          initial={{ opacity: 0, y: 24 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.55 }}
          transition={{ duration: 0.65 }}
        >
          <h2>One kitchen. Two surfaces.</h2>
          <p>
            Guests browse, build a plate, pay, and track. Chefs run orders, menu,
            and dispatch from the Victoria Island portal.
          </p>
        </motion.div>
      </section>

      <section className="roles">
        <motion.article
          whileHover={{ y: -6 }}
          initial={{ opacity: 0, y: 28 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.35 }}
          transition={{ duration: 0.55 }}
        >
          <div className="role-icon" aria-hidden>
            <PhoneIcon />
          </div>
          <h3>For guests</h3>
          <p>
            Party jollof, suya, egusi, and pepper soup with portions, extras, and
            live tracking across Lagos.
          </p>
          <button
            type="button"
            className="text-link"
            onClick={() => setDownloadOpen(true)}
          >
            Download on Play / App Store
          </button>
        </motion.article>
        <motion.article
          whileHover={{ y: -6 }}
          initial={{ opacity: 0, y: 28 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.35 }}
          transition={{ duration: 0.55, delay: 0.08 }}
        >
          <div className="role-icon" aria-hidden>
            <PotIcon />
          </div>
          <h3>For the kitchen</h3>
          <p>
            Dashboard, tickets, 86 inventory, customers, promotions, and reports
            on one pass for Chef Amaka’s brigade.
          </p>
          <button type="button" className="text-link" onClick={openOnboarding}>
            Open kitchen portal
          </button>
        </motion.article>
      </section>

      <section className="flow">
        <div className="flow-inner">
          <motion.h2
            initial={{ opacity: 0, y: 18 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
          >
            From the pot to Lekki
          </motion.h2>
          <p className="flow-lead">
            The customer app and kitchen portal share one order timeline.
          </p>
          <div className="steps">
            {steps.map((step, index) => (
              <motion.div
                key={step.title}
                className="step"
                initial={{ opacity: 0, y: 22 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, amount: 0.4 }}
                transition={{ delay: index * 0.08, duration: 0.5 }}
                whileHover={{ y: -4 }}
              >
                <span className="step-index">0{index + 1}</span>
                <h4>{step.title}</h4>
                <p>{step.body}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <footer className="footer">
        <motion.div
          initial={{ opacity: 0, scale: 0.97 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.55 }}
        >
          <h2>Ready for dinner rush?</h2>
          <p>
            Start in the kitchen portal, or put Foodiecall on your guests’ phones.
          </p>
          <div className="cta-row center">
            <button type="button" className="btn-primary" onClick={openOnboarding}>
              Get started
            </button>
            <button
              type="button"
              className="btn-outline"
              onClick={() => setDownloadOpen(true)}
            >
              Download app
            </button>
          </div>
          <p className="fineprint">
            Foodiecall Kitchen · Victoria Island, Lagos · WAT
          </p>
        </motion.div>
      </footer>

      <AnimatePresence>
        {downloadOpen && (
          <motion.div
            className="sheet-backdrop"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setDownloadOpen(false)}
          >
            <motion.div
              className="sheet"
              role="dialog"
              aria-modal="true"
              aria-labelledby="download-title"
              initial={{ y: 56, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              exit={{ y: 32, opacity: 0 }}
              transition={{ type: "spring", stiffness: 360, damping: 30 }}
              onClick={(event) => event.stopPropagation()}
            >
              <div className="sheet-handle" aria-hidden />
              <h3 id="download-title">Get the Foodiecall app</h3>
              <p>Order party jollof, suya, and egusi on your phone.</p>
              <a className="btn-dark store" href={PLAY_STORE} target="_blank" rel="noreferrer">
                Download on Google Play
              </a>
              <a className="btn-outline store" href={APP_STORE} target="_blank" rel="noreferrer">
                Download on the App Store
              </a>
              <button
                type="button"
                className="text-link sheet-close"
                onClick={() => setDownloadOpen(false)}
              >
                Close
              </button>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
