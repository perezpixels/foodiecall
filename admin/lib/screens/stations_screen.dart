import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class StationsScreen extends StatelessWidget {
  StationsScreen({super.key, required this.session});
  final KitchenSession session;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Kitchen Operations, Stations & Staff Roster', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text('Downtown Kitchen Hub #01 · Peak Dinner Brigade (16:30 – 23:00)', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
          ])),
          GhostButton(label: 'Clock In Staff Member', icon: Icons.badge, onPressed: () => _clockIn(context)),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _Mini('14', 'Active tickets · ↑ 8% vs lunch'),
          _Mini('8.4 min', 'Avg ticket time'),
          _Mini('\$348.50', 'Shift pooled tips'),
          _Mini('5 / 6', 'On-duty brigade'),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _Station('PASS #01', 'Expediter & Expo Pass', 'Chef Marco V.', '78%', '4 orders · 2 printers online'),
          _Station('GRILL #01', 'Grill & Searing Hot-Bar', 'Elena R.', '88%', '5 orders · griddle 450°F'),
          _Station('OVEN #01', 'Stone Oven & Pizza Deck', 'Matteo G.', '42%', '2 orders · deck 600°F'),
          _Station('PREP #01', 'Fryer, Prep & Salad Bar', 'Carlos M.', '54%', '3 orders · fryer 350°F'),
        ]),
        SizedBox(height: 16),
        KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(icon: Icons.groups, title: 'Active Staff Brigade & Station Assignments'),
          SizedBox(height: 8),
          _staff('Chef Marco Vance', 'Head Chef & Expo', 'Expo Pass #01', '6h 12m'),
          _staff('Elena Rostova', 'Grill Master Lead', 'Grill Station #01', '5h 45m'),
          _staff('Carlos Mendoza', 'Fryer & Prep Lead', 'Fryer & Salad', '4h 30m'),
          _staff('Maya Patel', 'Packaging & Dispatch', 'Courier Bay #02', '3h 15m'),
          _staff('Lucas Chen', 'Dish & Sanitation', 'Scullery & Sinks', '2h 45m'),
          SizedBox(height: 8),
          Text('Labor compliance 100% · Shift labor cost 14.2% of gross', style: TextStyle(color: KitchenColors.secondary, fontWeight: FontWeight.w600)),
        ])),
      ],
    );
  }

  void _clockIn(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Staff PIN Clock In'),
        content: Text('Enter 4-digit staff passcode and assign Expo, Grill, Stone Deck, Fryer, or Dispatch.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          FilledButton(onPressed: () { Navigator.pop(context); session.showToast('Action processed successfully'); }, child: Text('Confirm Clock In')),
        ],
      ),
    );
  }

  Widget _staff(String name, String role, String station, String hours) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$role · $station'),
      trailing: TextButton(onPressed: () => session.showToast('$name has clocked out. Tip disbursement logged.'), child: Text(hours)),
    );
  }
}

class _Mini extends StatelessWidget {
  _Mini(this.value, this.label);
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 220, child: KCard(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
    ])));
  }
}

class _Station extends StatelessWidget {
  _Station(this.code, this.name, String lead, this.load, this.detail) : leadName = lead;
  final String code;
  final String name;
  final String leadName;
  final String load;
  final String detail;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 260, child: KCard(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(code, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: KitchenColors.primary)),
      Text(name, style: TextStyle(fontWeight: FontWeight.w700)),
      Text('Lead: $leadName', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
      SizedBox(height: 8),
      Text(load, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      Text(detail, style: TextStyle(fontSize: 12)),
    ])));
  }
}
