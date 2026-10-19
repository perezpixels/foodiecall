import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key, required this.session, required this.onFinished});

  final KitchenSession session;
  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 1;
  int buffer = 1;
  final pauseThreshold = TextEditingController(text: '22');
  final hubName = TextEditingController(text: 'Downtown Kitchen Hub #01');
  final license = TextEditingController(text: 'FK-HUB-8802');

  static final steps = [
    ('01. License', 'Hub Profile'),
    ('02. Hardware', 'Stations & KDS'),
    ('03. Catalog', 'Menu Sync'),
    ('04. Team', 'Brigade Invites'),
  ];

  static final stepTitles = [
    'Hub Profile & License',
    'Hardware & Station Routing',
    'Catalog Menu Sync',
    'Brigade Invites',
  ];

  @override
  void dispose() {
    pauseThreshold.dispose();
    hubName.dispose();
    license.dispose();
    super.dispose();
  }

  void _toast(String message) => widget.session.showToast(message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KitchenColors.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1152),
                child: Column(
                  children: [
                    _header(),
                    SizedBox(height: 24),
                    _stepper(),
                    SizedBox(height: 24),
                    if (step == 0) _hubProfile(),
                    if (step == 1) _hardware(),
                    if (step == 2) _menuSync(),
                    if (step == 3) _brigade(),
                    SizedBox(height: 24),
                    _footer(),
                    SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
          if (widget.session.toast != null)
            Positioned(
              right: 24,
              bottom: 24,
              child: Material(
                color: KitchenColors.inverseSurface,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: KitchenColors.secondaryContainer),
                      SizedBox(width: 10),
                      Text(widget.session.toast!, style: TextStyle(color: KitchenColors.inverseOnSurface)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _header() {
    return KCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: KitchenColors.primary, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.soup_kitchen, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text('Foodiecall Kitchen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    KPill(label: 'Portal Provisioning v2.4'),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Automated high-throughput hardware sync & multi-courier dispatcher',
                  style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0x26006E2D),
                  child: Icon(Icons.wifi_tethering, color: KitchenColors.secondary, size: 18),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CLOUD MESH STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: KitchenColors.onSurfaceVariant)),
                    Text('Operational (US-East)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: KitchenColors.secondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepper() {
    return KCard(
      child: Column(
        children: [
          Row(
            children: [
              Text('Step ${step + 1} of 4', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: KitchenColors.primary)),
              Spacer(),
              Text(stepTitles[step], style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: (step + 1) / 4,
              minHeight: 6,
              backgroundColor: KitchenColors.surfaceContainer,
              color: KitchenColors.primary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < steps.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == steps.length - 1 ? 0 : 8),
                    child: _stepChip(i),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepChip(int i) {
    final done = i < step;
    final active = i == step;
    return InkWell(
      onTap: () => setState(() => step = i),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? Color(0x80FFDBCE) : (done ? Color(0x99FAF2EE) : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Opacity(
          opacity: active || done ? 1 : 0.6,
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: done
                    ? KitchenColors.secondary
                    : active
                        ? KitchenColors.primary
                        : KitchenColors.surfaceHighest,
                child: done
                    ? Icon(Icons.check, size: 14, color: Colors.white)
                    : Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? Colors.white : KitchenColors.onSurfaceVariant)),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(steps[i].$1, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? KitchenColors.primary : KitchenColors.onSurfaceVariant)),
                    Text(steps[i].$2, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hubProfile() {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(icon: Icons.storefront, title: 'Downtown Kitchen Hub'),
          SizedBox(height: 6),
          Text('Confirm the licensed hub before hardware routing.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 16),
          Text('Hub name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          TextField(controller: hubName, decoration: _fieldDecoration()),
          SizedBox(height: 16),
          Text('License ID', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          TextField(controller: license, decoration: _fieldDecoration()),
          SizedBox(height: 12),
          Text('PST (UTC-8) · Dinner 17:00 – 22:30 · Terminal firmware v4.8.2', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: KitchenColors.surfaceLow,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _hardware() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 900;
        final left = Column(
          children: [
            KCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: SectionTitle(icon: Icons.precision_manufacturing, title: 'Kitchen Stations & Ticket Printers')),
                      GhostButton(label: 'Add Station', icon: Icons.add, onPressed: () => _toast('Station modal dialog initialized')),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Route order items directly to display screens and physical ticket slips.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
                  SizedBox(height: 16),
                  _station(Icons.receipt_long, KitchenColors.primary, 'Expediter Pass (Expo Master)', 'Primary', true, 'Full ticket aggregation & bag sticker terminal', ['Epson TM-T88VI (Thermal USB)', 'Star Micronics TSP143III (Ethernet)', 'KDS Touch Display #1 (Android)', 'IP Direct (192.168.1.140:9100)'], 0),
                  _station(Icons.local_fire_department, KitchenColors.tertiary, 'Searing Grill Station', 'Cookline A', false, 'Hot mains, steaks, burgers & skewers', ['Epson TM-T88VI (Thermal USB)', 'Star Micronics TSP143III (Ethernet)', 'KDS Touch Display #2 (Kitchen Hub)', 'IP Direct (192.168.1.141:9100)'], 1),
                  _station(Icons.bakery_dining, KitchenColors.primaryContainer, 'Stone Oven Deck', 'Cookline B', false, 'Artisan flatbreads, calzones & gratins', ['Epson TM-T88VI (Thermal USB)', 'Star Micronics TSP143III (Ethernet)', 'Network IP (192.168.1.144)', 'KDS Touch Display #3'], 2),
                  _station(Icons.ramen_dining, KitchenColors.tertiary, 'Fryer & Crisp Station', 'Sides', false, 'Truffle wedges, tempura & finger food', ['Epson TM-T88VI (Thermal USB)', 'Star Micronics TSP143III (Ethernet)', 'Network IP (192.168.1.145)', 'KDS Touch Display #4'], 1),
                ],
              ),
            ),
            SizedBox(height: 24),
            KCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(icon: Icons.volume_up, title: 'Audio Chimes & Kitchen Alerts'),
                  SizedBox(height: 6),
                  Text('Select distinctive frequency profiles so line cooks recognize courier platforms by ear across kitchen noise.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _chime('DoorDash Chime', 'Ascending bell triad (880Hz - Fast sync)', KitchenColors.primary, 'DoorDash Tone'),
                      _chime('UberEats Alert', 'Dual harmonic synth ping (High clarity)', KitchenColors.secondary, 'UberEats Ping'),
                      _chime('Direct VIP Web', 'Double tactile marimba strike (Priority queue)', KitchenColors.tertiary, 'Direct Web Marimba'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
        final right = Column(
          children: [
            KCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(icon: Icons.timer, title: 'Rush Protocol Safeguards'),
                  SizedBox(height: 6),
                  Text('Protect kitchen flow during peak meal rush hours with automated pacing.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
                  SizedBox(height: 16),
                  Text('Auto-Pause Aggregators Threshold', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  TextField(
                    controller: pauseThreshold,
                    decoration: _fieldDecoration().copyWith(suffixText: 'Active Tickets'),
                  ),
                  SizedBox(height: 6),
                  Text('Temporarily pauses delivery incoming queues when active board exceeds this count.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
                  SizedBox(height: 16),
                  Text('Dynamic Prep Time Buffer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: i == 2 ? 0 : 8),
                            child: _bufferButton(['Standard (+0m)', 'Medium (+10m)', 'Peak (+15m)'][i], i),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 8,
                          children: [
                            Text('PREDICTED BRIGADE HEATLOAD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: KitchenColors.onSurfaceVariant)),
                            Text('Optimal 74%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: KitchenColors.secondary)),
                          ],
                        ),
                        SizedBox(height: 8),
                        _Sparkline(),
                        SizedBox(height: 6),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 8,
                          children: [
                            Text('11:30 AM', style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant)),
                            Text('1:15 PM (Lunch Rush)', style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant)),
                            Text('3:00 PM', style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            KCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: SectionTitle(icon: Icons.cloud_sync, title: 'Courier API Sync')),
                      KPill(label: '3/3 Live', fg: KitchenColors.secondary, bg: Color(0x26006E2D)),
                    ],
                  ),
                  SizedBox(height: 12),
                  _courier('DD', 'DoorDash Drive', 'Store ID: #88204-FD', KitchenColors.primary),
                  _courier('UE', 'Uber Eats Direct', 'Active POS Hook: Star Cloud', KitchenColors.secondary),
                  _courier('FC', 'Foodiecall Direct', 'Zero Commission Fleet', KitchenColors.primaryContainer),
                ],
              ),
            ),
          ],
        );
        return Column(
          children: [
            if (wide)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 8, child: left), SizedBox(width: 24), Expanded(flex: 4, child: right)])
            else ...[left, SizedBox(height: 24), right],
            SizedBox(height: 24),
            KCard(
              child: Row(
                children: [
                  Container(
                    width: 220,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [Color(0xFFCC4900), Color(0xFF5A4138)]),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.kitchen, color: Colors.white, size: 48),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KPill(label: 'Automated Ticket Dispersion', fg: KitchenColors.primary, bg: Color(0x1AA33900)),
                        SizedBox(height: 8),
                        Text('Dual-Band Bluetooth & Thermal Ethernet Fallback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 6),
                        Text(
                          'If kitchen Wi-Fi encounters drops during severe rainstorms or peak load, local Ethernet print queues seamlessly cache up to 300 orders offline, re-syncing timestamps automatically.',
                          style: TextStyle(fontSize: 14, height: 1.4, color: KitchenColors.onSurfaceVariant),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          children: [
                            _CheckLine('99.99% Offline Tolerance'),
                            _CheckLine('Encrypted Cloud Webhook'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _station(IconData icon, Color color, String name, String tag, bool primaryTag, String subtitle, List<String> printers, int selected) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: KitchenColors.surfaceLowest, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 12),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 360),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        KPill(
                          label: tag,
                          fg: primaryTag ? KitchenColors.secondary : KitchenColors.onSurfaceVariant,
                          bg: primaryTag ? Color(0x1A006E2D) : KitchenColors.surfaceHighest,
                        ),
                      ],
                    ),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 260,
            child: DropdownButtonFormField<String>(
              initialValue: printers[selected],
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: KitchenColors.surfaceLowest,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              items: [for (final p in printers) DropdownMenuItem(value: p, child: Text(p, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)))],
              onChanged: (_) => _toast('Printer route updated'),
            ),
          ),
          IconButton(
            tooltip: 'Print Diagnostic Slip',
            onPressed: () => _toast('Sending test thermal slip to $name'),
            style: IconButton.styleFrom(backgroundColor: KitchenColors.surfaceLowest),
            icon: Icon(Icons.print, color: KitchenColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _chime(String title, String body, Color dot, String tone) {
    return Container(
      width: 240,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600))), Container(width: 10, height: 10, decoration: BoxDecoration(color: dot, shape: BoxShape.circle))]),
          SizedBox(height: 8),
          Text(body, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: GhostButton(label: 'Test $tone'.replaceFirst(' Tone', ' Tone').replaceFirst('Test DoorDash Tone', 'Test DoorDash Tone'), icon: Icons.play_arrow, onPressed: () => _toast('Playing tone preview: $tone')),
          ),
        ],
      ),
    );
  }

  Widget _bufferButton(String label, int index) {
    final selected = buffer == index;
    return InkWell(
      onTap: () {
        setState(() => buffer = index);
        _toast('Prep time buffer adjusted to $label');
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? KitchenColors.primary : KitchenColors.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : KitchenColors.onSurface)),
      ),
    );
  }

  Widget _courier(String code, String name, String detail, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: KitchenColors.surfaceLowest, borderRadius: BorderRadius.circular(10)),
            child: Text(code, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: true, activeThumbColor: Colors.white, activeTrackColor: KitchenColors.secondary, onChanged: (_) => _toast('$name sync toggled')),
        ],
      ),
    );
  }

  Widget _menuSync() {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(icon: Icons.restaurant_menu, title: 'Menu & 86 Inventory Hub', trailing: KPill(label: 'POS Sync Live', fg: KitchenColors.secondary, bg: Color(0x26006E2D))),
          SizedBox(height: 8),
          Text('Manage 41 active recipes, stock availability, daily portion caps, and global modifier rules.', style: TextStyle(fontSize: 14, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Stat('38 / 41', 'Live Active Online'),
              _Stat('3', "Currently 86'd"),
              _Stat('71.4%', 'Avg Food Cost Margin'),
            ],
          ),
          SizedBox(height: 16),
          Text("Spicy Crispy Chicken Burger is 86'd — brioche delivery delayed until 4:30 PM.", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _brigade() {
    final people = [
      ('Chef Marco Vance', 'Head Chef & Expo', 'marco.v@foodiecall.com'),
      ('Elena Rostova', 'Grill Master Lead', 'elena.r@foodiecall.com'),
      ('Carlos Mendoza', 'Fryer & Prep Lead', 'carlos.m@foodiecall.com'),
      ('Maya Patel', 'Packaging & Courier Dispatch', 'maya.p@foodiecall.com'),
    ];
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(icon: Icons.badge, title: 'Brigade Invites'),
          SizedBox(height: 8),
          Text('Peak dinner brigade for Downtown Kitchen Hub #01.', style: TextStyle(fontSize: 14, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 12),
          for (final person in people)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(backgroundColor: KitchenColors.primaryFixed, child: Text(person.$1.split(' ').map((w) => w[0]).take(2).join(), style: TextStyle(color: KitchenColors.primary, fontWeight: FontWeight.w700))),
              title: Text(person.$1, style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${person.$2} · ${person.$3}'),
              trailing: KPill(label: 'Invited', fg: KitchenColors.secondary, bg: Color(0x26006E2D)),
            ),
        ],
      ),
    );
  }

  Widget _footer() {
    final continueLabel = switch (step) {
      0 => 'Continue to Hardware',
      1 => 'Continue to Menu Sync',
      2 => 'Continue to Brigade',
      _ => 'Open Kitchen Portal',
    };
    final backLabel = switch (step) {
      0 => null,
      1 => 'Back to Hub Profile',
      2 => 'Back to Hardware',
      _ => 'Back to Menu Sync',
    };
    return KCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (backLabel != null)
            GhostButton(label: backLabel, icon: Icons.arrow_back, onPressed: () => setState(() => step -= 1)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (step == 1)
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: () => _toast('Sending test thermal slip to Expo Master printer...'),
                    style: TextButton.styleFrom(
                      foregroundColor: KitchenColors.primary,
                      backgroundColor: KitchenColors.surfaceLow,
                      minimumSize: Size(0, 48),
                      shape: StadiumBorder(),
                    ),
                    child: Text('Save & Test Station Slip'),
                  ),
                ),
              PrimaryButton(
                label: continueLabel,
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (step < 3) {
                    if (step == 1) _toast('Hardware route locked. Redirecting to Step 3: Menu Sync...');
                    setState(() => step += 1);
                  } else {
                    widget.session.completeProvisioning();
                    widget.onFinished();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  _Stat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        Text(label, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
      ]),
    );
  }
}

class _CheckLine extends StatelessWidget {
  _CheckLine(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.check_circle, color: KitchenColors.secondary, size: 18),
      SizedBox(width: 6),
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: KitchenColors.onSurfaceVariant)),
    ]);
  }
}

class _Sparkline extends StatelessWidget {
  _Sparkline();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: CustomPaint(painter: _SparkPainter()),
    );
  }
}

class _SparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = KitchenColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.9, size.width * 0.3, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.35, size.width * 0.62, size.height * 0.66)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width * 0.75, size.height * 0.28)
      ..quadraticBezierTo(size.width * 0.88, size.height * 0.15, size.width, size.height * 0.5);
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.28), 4, Paint()..color = KitchenColors.primary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
