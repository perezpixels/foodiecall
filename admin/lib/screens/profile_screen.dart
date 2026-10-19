import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.session, required this.onSignOut});

  final KitchenSession session;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Text('WORKFORCE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: KitchenColors.primary)),
        SizedBox(height: 4),
        Text('Staff, roles, and executive profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        Text('Peak dinner · 6 of 6 on the Victoria Island line', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _stat('On the clock', '6', 'Target brigade 6'),
          _stat('Labor run rate', '₦36,700/hr', '14.2% of gross'),
          _stat('Shift tips', '₦86,400', 'Pooled at expo'),
          _stat('Compliance', '100%', 'Breaks logged'),
        ]),
        SizedBox(height: 16),
        KCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(radius: 32, backgroundColor: KitchenColors.primaryFixed, child: Text('AA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: KitchenColors.primary))),
          SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Chef Amaka Adeyemi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            Text('Executive chef · Victoria Island'),
            SizedBox(height: 6),
            Text('amaka.a@foodiecall.kitchen · +234 803 555 0142 · ID #FK-8802'),
            SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              KPill(label: 'ServSafe · Nov 2026', fg: KitchenColors.secondary, bg: KitchenColors.secondaryContainer),
              KPill(label: 'Super admin', fg: KitchenColors.primary, bg: KitchenColors.primaryFixed),
              KPill(label: 'Pass & quality'),
            ]),
            SizedBox(height: 8),
            Text('Today: clock-in 14:45 · yaji sign-off 16:10 · walk-in audit 17:30, 3°C.'),
          ])),
        ])),
        SizedBox(height: 16),
        Text('Clearance', style: TextStyle(fontWeight: FontWeight.w800)),
        SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _role('86 & stock override', 'Station leads', 1),
          _role('Comp over ₦15,000', 'Supervisor', 0.7),
          _role('Rush reorder on KDS', 'Expediter', 0.85),
          _role('Financial export', 'Hub admin only', 0.4),
        ]),
        SizedBox(height: 16),
        Text('Brigade on the floor', style: TextStyle(fontWeight: FontWeight.w800)),
        SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _member('Chef Amaka Adeyemi', 'Expo', '₦8,500/hr', 0.75, '6h 12m'),
          _member('Chef Zainab Bello', 'Suya grill', '₦6,200/hr', 0.68, '5h 45m'),
          _member('Chef Chioma Nwosu', 'Soups', '₦5,400/hr', 0.6, '4h 30m'),
          _member('Chef Funke Adewale', 'Small chops', '₦5,000/hr', 0.42, '3h 15m'),
          _member('Chef Halima Yusuf', 'Dispatch', '₦4,800/hr', 0.4, '3h 15m'),
          _member('Chef Ngozi Eze', 'QA', '₦6,800/hr', 0.7, '5h 30m'),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 8, children: [
          GhostButton(label: 'End of shift sign-off', icon: Icons.alarm, onPressed: () => session.showToast('Shift sign-off recorded')),
          GhostButton(label: 'Export labor CSV', icon: Icons.download, onPressed: () => session.showToast('Labor CSV queued')),
        ]),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: KitchenColors.errorContainer, foregroundColor: KitchenColors.error, minimumSize: Size(220, 52), shape: StadiumBorder()),
            onPressed: onSignOut,
            icon: Icon(Icons.logout),
            label: Text('Log out'),
          ),
        ),
      ],
    );
  }

  Widget _stat(String label, String value, String detail) {
    return SizedBox(
      width: 200,
      child: KCard(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: KitchenColors.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _role(String title, String who, double level) {
    return SizedBox(
      width: 220,
      child: KCard(
        padding: EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
          Text(who, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: level, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: KitchenColors.primary)),
        ]),
      ),
    );
  }

  Widget _member(String name, String station, String rate, double shift, String hours) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(color: KitchenColors.surfaceLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: KitchenColors.outlineVariant)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.w800)),
          Text(station, style: TextStyle(color: KitchenColors.primary, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: shift, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: KitchenColors.secondary)),
          SizedBox(height: 6),
          Text('$hours · $rate', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
