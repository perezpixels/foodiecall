import 'package:flutter/material.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class NotificationsSheet extends StatelessWidget {
  NotificationsSheet({super.key, required this.onClose, required this.onOpenTicket});

  final VoidCallback onClose;
  final VoidCallback onOpenTicket;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x661E1B19),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 460,
          height: double.infinity,
          color: KitchenColors.surface,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(child: Text('Live Alerts & Dispatch Stream', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                  IconButton(onPressed: onClose, icon: Icon(Icons.close)),
                ],
              ),
              Text('5 New · Audio relay on · Victoria Island'),
              SizedBox(height: 8),
              Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: onClose, child: Text('Mark All Read'))),
              Wrap(spacing: 8, children: [
                KPill(label: 'All (12)', fg: KitchenColors.onPrimary, bg: KitchenColors.primary),
                KPill(label: 'Severe Alerts (2)'),
                KPill(label: 'Courier En Route (6)'),
                KPill(label: 'System Sync (3)'),
              ]),
              SizedBox(height: 16),
              _note('Allergy Hazard', 'Ticket #FK-8945 · Adaeze O.', 'Groundnut allergy: sanitize the suya board and use the groundnut-free yaji only. Expo sign-off required.', 'Just now', 'Acknowledge & Sign-Off', onOpenTicket),
              _note("Auto 86'd Trigger", 'Yaji mix stock reached 0', 'Beef Suya Platter automatically paused on Chowdeck, Glovo, and the Foodiecall store.', '3m ago', 'Restock Supply', onClose),
              _note('Rider Approaching', 'Tunde Balogun (Bike #04) · 2 min away', 'Order #FK-8942 (jollof, suya, zobo). Expo bag check is ready. Shelf B.', '5m ago', 'Verify Bag', onOpenTicket),
              _note('Line Congestion', 'Suya grill at 88% capacity', 'Five tickets are queued. Send incoming small chops to the second prep line.', '8m ago', 'Auto-Divert Tickets', onClose),
              _note('Daily Safety Log', 'Mid-shift temperature audit passed', 'Walk-in 3°C, fryer 175°C. Submitted by Chef Chioma Nwosu.', '14m ago', 'View HACCP Sheet', onClose),
              SizedBox(height: 8),
              GhostButton(label: 'Dismiss Panel', icon: Icons.close, onPressed: onClose),
            ],
          ),
        ),
      ),
    );
  }

  Widget _note(String title, String subtitle, String body, String time, String action, VoidCallback onAction) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: KCard(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w700))), Text(time, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant))]),
            Text(subtitle, style: TextStyle(fontSize: 12, color: KitchenColors.primary, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text(body, style: TextStyle(fontSize: 13, color: KitchenColors.onSurfaceVariant)),
            Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: onAction, child: Text(action))),
          ],
        ),
      ),
    );
  }
}
