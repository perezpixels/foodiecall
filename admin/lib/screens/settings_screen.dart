import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key, required this.session});
  final KitchenSession session;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool snooze = false;
  bool allergen = true;
  bool autoFire = true;
  bool halal = true;
  int cap = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Text('KITCHEN CONFIGURATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: KitchenColors.primary)),
        SizedBox(height: 4),
        Text('Operational settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        Text('Victoria Island · firmware v4.8.2 · last published by Chef Amaka', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _stat(Icons.wifi_tethering, 'POS sync', '99.98%', '42ms latency'),
          _stat(Icons.print, 'Printers', '2 online', 'Expo + suya line'),
          _stat(Icons.hub, 'Aggregators', '3 live', 'Chowdeck · Glovo · Direct'),
          _stat(Icons.schedule, 'Service window', snooze ? 'Paused' : 'Open', 'Dinner 17:00–22:30'),
        ]),
        SizedBox(height: 16),
        KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(icon: Icons.emergency, title: 'Emergency snooze'),
          SizedBox(height: 8),
          Text('Pauses Chowdeck, Glovo, and the Foodiecall store without unbinding the listings.'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(snooze ? 'Kitchen is paused' : 'Active and cooking'),
            value: snooze,
            activeThumbColor: Colors.white,
            activeTrackColor: KitchenColors.error,
            onChanged: (value) => setState(() => snooze = value),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: snooze ? 0 : 0.72, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: snooze ? KitchenColors.error : KitchenColors.secondary),
          ),
          SizedBox(height: 6),
          Text(snooze ? 'Inflow stopped' : 'Load 72% of the dinner cap', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ])),
        SizedBox(height: 16),
        Text('Hours · WAT', style: TextStyle(fontWeight: FontWeight.w800)),
        SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _hours('Mon–Thu', 'Lunch 11:30–14:30', 'Dinner 17:00–22:30'),
          _hours('Friday', 'Lunch 11:30–15:00', 'Late dinner 17:00–23:30'),
          _hours('Saturday', 'All-day service', '10:00–23:30'),
          _hours('Sunday', 'Brunch 10:30–16:00', 'Dinner 17:00–21:30'),
        ]),
        SizedBox(height: 16),
        KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(icon: Icons.speed, title: 'Capacity throttle'),
          SizedBox(height: 8),
          Text('Tickets allowed in each 15-minute slot'),
          SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (var i = 0; i < 4; i++)
              ChoiceChip(
                label: Text(['6 Leisure', '16 Optimal', '24 Rush', '32 Banquet'][i]),
                selected: cap == i,
                selectedColor: KitchenColors.primary,
                labelStyle: TextStyle(color: cap == i ? KitchenColors.onPrimary : KitchenColors.onSurface, fontWeight: FontWeight.w700),
                onSelected: (_) => setState(() => cap = i),
              ),
          ]),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: [0.2, 0.5, 0.75, 1.0][cap], minHeight: 10, backgroundColor: KitchenColors.surfaceContainer, color: KitchenColors.primary),
          ),
          SizedBox(height: 8),
          Text('Surge adds 8 minutes when more than 12 tickets are waiting. A dish 86s itself under 3 portions.'),
        ])),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final printers = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.print, title: 'Thermal hardware'),
            SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Auto-fire on arrival'),
              subtitle: Text('Expo Epson TM-T88VI · 192.168.1.101'),
              value: autoFire,
              activeThumbColor: KitchenColors.onPrimary,
              activeTrackColor: KitchenColors.secondary,
              onChanged: (value) => setState(() => autoFire = value),
            ),
            _device('Suya line · Star SP700', 0.92, '192.168.1.104 · roll 92%'),
            _device('Expo window', 0.85, '192.168.1.101 · roll 85%'),
          ]));
          final safety = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.health_and_safety, title: 'Allergen guard'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Chef must confirm before fire'),
              subtitle: Text('Groundnut-free yaji and dedicated soup pot'),
              value: allergen,
              activeThumbColor: KitchenColors.onPrimary,
              activeTrackColor: KitchenColors.secondary,
              onChanged: (value) => setState(() => allergen = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Halal dedicated line'),
              value: halal,
              activeThumbColor: KitchenColors.onPrimary,
              activeTrackColor: KitchenColors.secondary,
              onChanged: (value) => setState(() => halal = value),
            ),
            Text('Heartbeat', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            _device('Chowdeck', 0.9, '18ms'),
            _device('Glovo', 0.78, '24ms'),
            _device('Foodiecall Direct', 0.96, '12ms'),
          ]));
          if (c.maxWidth < 900) return Column(children: [printers, SizedBox(height: 16), safety]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: printers), SizedBox(width: 16), Expanded(child: safety)]);
        }),
        SizedBox(height: 16),
        Row(children: [
          Expanded(child: Text('Unsaved changes sit on this terminal until you publish.', style: TextStyle(color: KitchenColors.onSurfaceVariant))),
          TextButton(onPressed: () => widget.session.showToast('Changes discarded'), child: Text('Discard')),
          SizedBox(width: 8),
          PrimaryButton(label: 'Publish configuration', onPressed: () => widget.session.showToast('Victoria Island configuration published')),
        ]),
      ],
    );
  }

  Widget _stat(IconData icon, String label, String value, String detail) {
    return SizedBox(
      width: 220,
      child: KCard(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: KitchenColors.primary, size: 20),
          SizedBox(height: 8),
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: KitchenColors.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _hours(String day, String a, String b) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: KitchenColors.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: KitchenColors.outlineVariant),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(day, style: TextStyle(fontWeight: FontWeight.w800, color: KitchenColors.primary)),
          SizedBox(height: 6),
          Text(a),
          Text(b, style: TextStyle(color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _device(String name, double value, String detail) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w700))), Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant))]),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(value: value, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: KitchenColors.secondary),
        ),
      ]),
    );
  }
}
