import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key, required this.session, required this.onNavigate});

  final KitchenSession session;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back, Chef Amaka!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                  SizedBox(height: 4),
                  Text('Shift: Dinner Rush (17:00 – 22:30) · Peak Volume Window', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
                ],
              ),
            ),
            GhostButton(label: "Manage 86'd (1)", icon: Icons.block, onPressed: () => onNavigate('/menu')),
          ],
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _kpi('Today\'s Gross Sales', '₦2,486,500', '+18.4%', 'Delivery: ₦1,890,000 · Takeout: ₦596,500'),
            _kpi('Active Orders & KDS Load', '14 Tickets', 'Live Flow', 'New 4 · In Fire 6 · Ready Expo 4'),
            _kpi('Kitchen Fulfillment Rate', '98.2%', '0 Cancelled', '218 Complete Today · Avg cook 12m 15s'),
            _kpi('Active Courier Fleet', '7 En Route', '2m 10s', '3 riders within 400m perimeter'),
          ],
        ),
        SizedBox(height: 20),
        KCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(icon: Icons.campaign, title: 'Urgent Kitchen Alerts & Expo Flags', trailing: KPill(label: '3 Priority Flags', fg: KitchenColors.primary, bg: KitchenColors.primaryFixed)),
              SizedBox(height: 12),
              _alert(Icons.warning_amber, "ITEM 86'd: Party Jollof", '4:30 PM Log', 'Ofada rice delivery from the Mile 12 supplier is late. Stock depletion is already enforced on Chowdeck and the web store.', 'Manage', () => onNavigate('/menu')),
              _alert(Icons.emergency, 'SEVERE ALLERGY: Ticket #FK-8945', 'Groundnut flag', 'Suya bay: sanitize the board. Use the groundnut-free yaji only. Expo sign-off required.', 'Acknowledge', () => session.showToast('Allergy flag acknowledged')),
              _alert(Icons.sports_motorsports, 'Courier Approaching: Tunde Balogun', 'ETA 3 Mins', 'Pick up for Order #FK-8942 (jollof and suya, insulated hot bag ready).', 'Seal Bag', () => session.showToast('Bag sealed for #FK-8942')),
            ],
          ),
        ),
        SizedBox(height: 20),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 980;
          final chart = KCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(icon: Icons.show_chart, title: 'Hourly Velocity & Peak Volume'),
                SizedBox(height: 6),
                Text('Live revenue curve tracking real-time delivery and pickup surges (11:00 AM – 21:00 PM)', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
                SizedBox(height: 16),
                SizedBox(height: 140, child: _Bars()),
                SizedBox(height: 8),
                Text('Peak Rush: ₦486,000 @ 7:30 PM · Shift average ₦248,000 / hr', style: TextStyle(fontWeight: FontWeight.w600, color: KitchenColors.primary)),
              ],
            ),
          );
          final dishes = KCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: SectionTitle(icon: Icons.restaurant, title: 'Top Performing Gourmet Dishes')),
                    TextButton(onPressed: () => onNavigate('/menu'), child: Text('Full Menu Inventory')),
                  ],
                ),
                _dish('Party Jollof Rice', '42 sold', '₦189,000', '98%', 'Fire Bay'),
                _dish('Beef Suya Platter', '38 sold', '₦247,000', '100%', 'Grill'),
                _dish('Egusi & Pounded Yam', '24 sold', '₦172,800', '95%', 'Soup Pot'),
                _dish('Ofada Rice & Ayamase', '21 sold', '₦121,800', '97%', 'Fire Bay'),
              ],
            ),
          );
          if (!wide) return Column(children: [chart, SizedBox(height: 16), dishes]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: chart), SizedBox(width: 16), Expanded(child: dishes)]);
        }),
        SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _Load('Suya grill', 0.85, 'Heavy · 85%', '5 tickets · 8 min turn'),
            _Load('Jollof fire bay', 0.45, 'Steady · 45%', '2 pots · party rice holding'),
            _Load('Soup pot', 0.6, 'Steady · 60%', 'Egusi and pepper soup'),
            _Load('Expo & bags', 0.9, 'High · 90%', '4 bags sealing · 45 sec'),
          ],
        ),
        SizedBox(height: 20),
        KCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(icon: Icons.groups, title: 'Kitchen Brigade', trailing: Text('4 on duty', style: TextStyle(fontWeight: FontWeight.w600))),
              SizedBox(height: 8),
              _person('Chef Amaka A.', 'Executive Chef', 'Active 6.0h'),
              _person('Chef Zainab B.', 'Suya & Grill Lead', 'Active 5.0h'),
              _person('Chef Chioma N.', 'Soups & Swallow', 'Active 4.5h'),
              _person('Chef Funke A.', 'Small Chops & Pastry', 'Active 3.0h'),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  GhostButton(label: 'Export Daily Shift Audit Log', icon: Icons.download, onPressed: () => session.showToast('Shift audit exported')),
                  GhostButton(label: 'Reprint Last KDS Batch #FK-8945', icon: Icons.print, onPressed: () => session.showToast('Action successful')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kpi(String label, String value, String delta, String detail) {
    return SizedBox(
      width: 260,
      child: KCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: KitchenColors.onSurfaceVariant)),
            SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
            SizedBox(height: 4),
            Text(delta, style: TextStyle(color: KitchenColors.secondary, fontWeight: FontWeight.w700, fontSize: 12)),
            SizedBox(height: 4),
            Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _alert(IconData icon, String title, String tag, String body, String action, VoidCallback onAction) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(14), border: Border.all(color: KitchenColors.outlineVariant)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: KitchenColors.primary),
        SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w700)), KPill(label: tag)]),
          Text(body, style: TextStyle(fontSize: 13, color: KitchenColors.onSurfaceVariant)),
        ])),
        TextButton(onPressed: onAction, child: Text(action)),
      ]),
    );
  }

  Widget _dish(String name, String volume, String revenue, String sat, String station) {
    final score = (double.tryParse(sat.replaceAll('%', '')) ?? 0) / 100;
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w700))),
          Text(revenue, style: TextStyle(fontWeight: FontWeight.w800, color: KitchenColors.primary)),
        ]),
        SizedBox(height: 2),
        Text('$volume · $station · $sat repeat', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(value: score, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: KitchenColors.primary),
        ),
      ]),
    );
  }

  Widget _person(String name, String role, String hours) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(14), border: Border.all(color: KitchenColors.outlineVariant)),
        child: Row(children: [
          CircleAvatar(backgroundColor: KitchenColors.primaryFixed, child: Text(name.split(' ').map((p) => p[0]).take(2).join(), style: TextStyle(color: KitchenColors.primary, fontSize: 12, fontWeight: FontWeight.w700))),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.w700)),
            Text(role, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          ])),
          Text(hours, style: TextStyle(fontSize: 12, color: KitchenColors.secondary, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class _Load extends StatelessWidget {
  _Load(this.title, this.value, this.status, this.detail);
  final String title;
  final double value;
  final String status;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: KCard(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w800)),
          SizedBox(height: 4),
          Text(status, style: TextStyle(color: KitchenColors.primary, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: value, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: value > 0.8 ? KitchenColors.error : KitchenColors.secondary)),
          SizedBox(height: 6),
          Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

class _Bars extends StatelessWidget {
  _Bars();

  @override
  Widget build(BuildContext context) {
    final heights = [0.35, 0.5, 0.42, 0.62, 0.95, 0.7];
    final labels = ['11:00', '1:00', '3:00', '5:00', '7:30', '9:00'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < heights.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: heights[i],
                        child: Container(
                          decoration: BoxDecoration(
                            color: i == 4 ? KitchenColors.primary : KitchenColors.primaryFixed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(labels[i], style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
