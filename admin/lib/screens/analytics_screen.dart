import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  AnalyticsScreen({super.key, required this.session});
  final KitchenSession session;

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String range = '30D';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('EXECUTIVE INTELLIGENCE UNIT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: KitchenColors.primary)),
            SizedBox(height: 4),
            Text('Operational Analytics & Revenue Intelligence', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            Text('Victoria Island Kitchen · rush, prime cost, and what actually sells', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
          ])),
          Wrap(spacing: 8, children: [
            for (final item in ['7D', '30D', '90D'])
              ChoiceChip(
                label: Text(item),
                selected: range == item,
                selectedColor: KitchenColors.primary,
                labelStyle: TextStyle(color: range == item ? KitchenColors.onPrimary : KitchenColors.onSurface, fontWeight: FontWeight.w700),
                onSelected: (_) => setState(() => range = item),
              ),
            PrimaryButton(label: 'Export report', icon: Icons.download, onPressed: () => widget.session.showToast('$range PDF digest queued for Chef Amaka')),
          ]),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _Kpi('Gross merchandise value', '₦48,620,000', '+14.2% vs last month', 'Delivery 76% · Takeout 24%', Icons.payments_outlined),
          _Kpi('Ticket fire-to-pass', '11m 42s', '−1m 18s · inside the 14m line', 'Friday peak 13m 15s', Icons.timer_outlined),
          _Kpi('Fulfillment accuracy', '99.4%', '4,120 tickets · 6 remakes', 'Top of Lagos island kitchens', Icons.verified_outlined),
          _Kpi('Prime cost margin', '72.8%', 'Food ₦14.2m · Labor ₦11.4m', 'Benchmark 65% for this hub', Icons.pie_chart_outline),
        ]),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, constraints) {
          final heatmap = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.grid_on, title: 'Hourly ticket volume & rush clustering'),
            SizedBox(height: 4),
            Text('Fri and Sat 18:00–21:00 still need two extra prep hands.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
            SizedBox(height: 12),
            _Heatmap(),
          ]));
          final channels = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.donut_large, title: 'Channel profitability'),
            SizedBox(height: 12),
            Row(children: [
              SizedBox(width: 120, height: 120, child: CustomPaint(painter: _DonutPainter())),
              SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('₦48.6m', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text('Net GMV this $range', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
              ])),
            ]),
            SizedBox(height: 12),
            _channel('Chowdeck', 0.42, '18% take · 82% net', KitchenColors.primary),
            _channel('Glovo', 0.35, '22.5% take · 77.5% net', KitchenColors.tertiary),
            _channel('Foodiecall Direct', 0.23, '2.4% processing · 97.6% net', KitchenColors.secondary),
            SizedBox(height: 8),
            Text('Direct orders kept an extra ₦4.8m versus aggregator commission.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          ]));
          if (constraints.maxWidth < 980) {
            return Column(children: [heatmap, SizedBox(height: 16), channels]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 3, child: heatmap),
            SizedBox(width: 16),
            Expanded(flex: 2, child: channels),
          ]);
        }),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, constraints) {
          final stations = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.outdoor_grill, title: 'Station bottleneck timers'),
            SizedBox(height: 4),
            Text('Target is 10 minutes before the expo handoff.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
            SizedBox(height: 12),
            _bar('Suya & char grill', 0.9, '14m avg · +4m bottleneck', 'Suya, asun, croaker', KitchenColors.error),
            _bar('Fire bay · jollof', 0.62, '9m avg · optimal', 'Party jollof, ofada, ayamase', KitchenColors.secondary),
            _bar('Soup pot', 0.45, '6m avg · fast', 'Egusi, pepper soup, efo riro', KitchenColors.secondary),
            _bar('Expo & packaging', 0.25, '2m avg · on target', 'Seals, bike handover, Chowdeck bags', KitchenColors.primary),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: KitchenColors.primaryFixed, borderRadius: BorderRadius.circular(12)),
              child: Text('Friday 19:00 queue crosses 10 minutes on the grill. Move one prep cook from the soup pot.', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ]));
          final matrix = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.restaurant_menu, title: 'Profit drivers vs loss leaders'),
            SizedBox(height: 8),
            _matrix('Beef Suya Platter', '892', '18.4%', '81.6%', 'Star · keep it on the hero'),
            _matrix('Party Jollof Rice', '1,140', '22.8%', '77.2%', 'Workhorse · protect the rice'),
            _matrix('Egusi & Pounded Yam', '420', '31.2%', '68.8%', 'Puzzle · push on Chowdeck'),
            _matrix('Catfish Pepper Soup', '318', '44.6%', '55.4%', 'Re-portion or add ₦500'),
            _matrix('Asun', '194', '48.2%', '51.8%', 'Loss risk until goat lands'),
            SizedBox(height: 8),
            Text('Food cost across the live menu: 29.3%', style: TextStyle(fontWeight: FontWeight.w700)),
          ]));
          if (constraints.maxWidth < 980) {
            return Column(children: [stations, SizedBox(height: 16), matrix]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: stations),
            SizedBox(width: 16),
            Expanded(child: matrix),
          ]);
        }),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _highlight(Icons.emoji_events_outlined, 'Top margin', 'Beef Suya Platter', '₦6.4m gross margin this cycle'),
          _highlight(Icons.local_fire_department, 'Velocity champion', 'Party Jollof Rice', '1,140 plates · 27.6% of tickets'),
          _highlight(Icons.fact_check_outlined, 'Hub audit', 'Victoria Island line', '98.2 / 100 · no critical flags'),
        ]),
      ],
    );
  }

  Widget _channel(String name, double share, String take, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: 6),
          Text(name, style: TextStyle(fontWeight: FontWeight.w700)),
          Spacer(),
          Text('${(share * 100).round()}%', style: TextStyle(fontWeight: FontWeight.w700)),
        ]),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(value: share, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: color),
        ),
        Text(take, style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant)),
      ]),
    );
  }

  Widget _bar(String name, double value, String timing, String dishes, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w700))),
          Text(timing, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ]),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(value: value, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: color),
        ),
        Text(dishes, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
      ]),
    );
  }

  Widget _matrix(String dish, String volume, String cost, String margin, String note) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(flex: 3, child: Text(dish, style: TextStyle(fontWeight: FontWeight.w700))),
        Expanded(child: Text(volume, style: TextStyle(fontSize: 12))),
        Expanded(child: Text(margin, style: TextStyle(fontWeight: FontWeight.w800, color: KitchenColors.primary))),
        Expanded(flex: 3, child: Text(note, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant))),
      ]),
    );
  }

  Widget _highlight(IconData icon, String kicker, String title, String body) {
    return SizedBox(
      width: 260,
      child: KCard(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: KitchenColors.primary),
          SizedBox(height: 8),
          Text(kicker.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6, color: KitchenColors.onSurfaceVariant)),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          SizedBox(height: 4),
          Text(body, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  _Kpi(this.label, this.value, this.delta, this.detail, this.icon);
  final String label;
  final String value;
  final String delta;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: KCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.4, color: KitchenColors.onSurfaceVariant))),
            Icon(icon, size: 18, color: KitchenColors.primary),
          ]),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          SizedBox(height: 4),
          Text(delta, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: KitchenColors.secondary)),
          SizedBox(height: 4),
          Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const hours = ['11', '13', '15', '17', '18', '19', '20', '21'];
    const cells = [
      [0.2, 0.45, 0.25, 0.35, 0.55, 0.6, 0.4, 0.2],
      [0.25, 0.5, 0.3, 0.4, 0.6, 0.65, 0.45, 0.25],
      [0.2, 0.4, 0.22, 0.38, 0.58, 0.62, 0.42, 0.2],
      [0.3, 0.55, 0.28, 0.5, 0.7, 0.75, 0.5, 0.3],
      [0.35, 0.6, 0.3, 0.72, 0.95, 1, 0.85, 0.4],
      [0.4, 0.7, 0.35, 0.8, 0.98, 0.96, 0.88, 0.5],
      [0.5, 0.75, 0.4, 0.55, 0.7, 0.66, 0.48, 0.3],
    ];
    return Column(children: [
      Row(children: [
        SizedBox(width: 36),
        for (final hour in hours) Expanded(child: Text(hour, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant))),
      ]),
      for (var d = 0; d < days.length; d++)
        Padding(
          padding: EdgeInsets.only(top: 6),
          child: Row(children: [
            SizedBox(width: 36, child: Text(days[d], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            for (var h = 0; h < cells[d].length; h++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Tooltip(
                    message: '${days[d]} ${hours[h]}:00 · ${(cells[d][h] * 180).round()} tickets',
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color.lerp(KitchenColors.surfaceContainer, KitchenColors.primary, cells[d][h].toDouble()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
          ]),
        ),
    ]);
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.butt;
    const sweeps = [0.42, 0.35, 0.23];
    final colors = [KitchenColors.primary, KitchenColors.tertiary, KitchenColors.secondary];
    var start = -1.5708;
    for (var i = 0; i < sweeps.length; i++) {
      paint.color = colors[i];
      final sweep = sweeps[i] * 6.28318;
      canvas.drawArc(rect.deflate(10), start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
