import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({super.key, required this.session, required this.onNewOrder});
  final KitchenSession session;
  final VoidCallback onNewOrder;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int tab = 0;
  String? selected = '#FK-8942';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Live Orders & Dispatch', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                Text('Kitchen operations · 4 stations syncing · Avg fire-to-pack 11m 42s', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
              ]),
            ),
            GhostButton(label: 'Auto-Print Slips (Active)', icon: Icons.print, onPressed: () => widget.session.showToast('Auto-print confirmed')),
            SizedBox(width: 8),
            PrimaryButton(label: 'New phone order', icon: Icons.phone_in_talk, onPressed: widget.onNewOrder),
          ],
        ),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _flow('New', '2', 'Waiting on the pass'),
          _flow('On the fire', '6', 'Suya and soup lines'),
          _flow('Staged', '4', 'Bags on shelf B'),
          _flow('Fire-to-pack', '11m 42s', 'Target under 14 min'),
        ]),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            for (var i = 0; i < 5; i++)
              ChoiceChip(
                label: Text(['All Orders (14)', 'Action Needed (2)', 'In Prep (6)', 'Staged / Handoff (4)', 'Dispatched Today (38)'][i]),
                selected: tab == i,
                onSelected: (_) => setState(() => tab = i),
                selectedColor: KitchenColors.primary,
                labelStyle: TextStyle(color: tab == i ? Colors.white : KitchenColors.onSurface, fontWeight: FontWeight.w600),
              ),
          ],
        ),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final cards = Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (tab == 0 || tab == 1) ...[
                _ticket('#FK-8945', 'Chowdeck', 'Adaeze O.', '2m ago', 'Groundnut allergy', ['Beef suya', 'Party jollof'], '₦11,000', 'Accept', () => widget.session.showToast('Ticket #FK-8945 fired')),
                _ticket('#FK-8946', 'Pickup', 'Tobi A.', 'Just now', 'New', ['Egusi & pounded yam'], '₦7,200', 'Accept', () => widget.session.showToast('Ticket #FK-8946 accepted')),
              ],
              if (tab == 0 || tab == 2)
                _ticket('#FK-8942', 'Direct', 'Chioma O.', '04:15', 'Rider 3m', ['Jollof', 'Suya', 'Zobo'], '₦14,500', 'Mark ready', () {
                  setState(() => selected = '#FK-8942');
                  widget.session.showToast('Ticket status updated');
                }),
              if (tab == 0 || tab == 3)
                _ticket('#FK-8938', 'Bin #3', 'Funke A.', 'At counter', 'Code 8938', ['Bagged & sealed'], '₦18,400', 'Hand off', () => widget.session.showToast('Dispatch cleared')),
              if (tab == 0 || tab == 4)
                _ticket('#FK-8931', 'Chowdeck', 'Halima S.', '12m ago', 'Delivered', ['Ofada & ayamase'], '₦5,800', 'View', () => setState(() => selected = '#FK-8931')),
            ],
          );
          final detail = KCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(selected ?? 'Ticket', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              Text('Chioma Obi · 14 Admiralty Way, Lekki Phase 1', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
              SizedBox(height: 8),
              Text('Live route · Tunde Balogun, bike #04', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('0.8 km · 3 min · Lekki traffic'),
              Divider(),
              Text('1× Party Jollof Rice · ₦4,500'),
              Text('1× Beef Suya Platter · ₦6,500'),
              Text('1× Zobo · ₦1,200'),
              SizedBox(height: 8),
              KPill(label: 'No groundnut · verified', fg: KitchenColors.secondary, bg: Color(0x26006E2D)),
              SizedBox(height: 12),
              Text('Total paid ₦14,500', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: KitchenColors.primary)),
              SizedBox(height: 12),
              PrimaryButton(label: 'Advance to staged handoff', onPressed: () => widget.session.showToast('Ticket status updated')),
            ]),
          );
          if (c.maxWidth < 1100) return Column(children: [cards, SizedBox(height: 16), detail]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: cards), SizedBox(width: 16), SizedBox(width: 300, child: detail)]);
        }),
      ],
    );
  }

  Widget _flow(String label, String value, String detail) {
    return SizedBox(
      width: 200,
      child: KCard(
        padding: EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: KitchenColors.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _ticket(String id, String channel, String guest, String time, String flag, List<String> lines, String total, String action, VoidCallback onAction) {
    final active = selected == id;
    return SizedBox(
      width: 220,
      child: Material(
        color: KitchenColors.surfaceLowest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => setState(() => selected = id),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 220),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: active ? KitchenColors.primary : KitchenColors.outlineVariant, width: active ? 2 : 1),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(id, style: TextStyle(fontWeight: FontWeight.w800))),
                Text(time, style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant)),
              ]),
              SizedBox(height: 6),
              Text(guest, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(channel, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
              SizedBox(height: 8),
              KPill(label: flag, fg: KitchenColors.primary, bg: KitchenColors.primaryFixed),
              SizedBox(height: 8),
              for (final line in lines) Text('· $line', style: TextStyle(fontSize: 13)),
              SizedBox(height: 10),
              Text(total, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: KitchenColors.primary)),
              SizedBox(height: 8),
              SizedBox(width: double.infinity, child: TextButton(onPressed: onAction, child: Text(action))),
            ]),
          ),
        ),
      ),
    );
  }
}

class KdsScreen extends StatelessWidget {
  KdsScreen({super.key, required this.session, required this.onBack});
  final KitchenSession session;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(children: [
          IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back)),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Kitchen Display Station', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text('Main Line · Expo 01 · Rush +5m · Avg cook 11m 40s', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
          ])),
        ]),
        SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _chit('#FK-8945', 'Chowdeck · Adaeze O. · 2 items · 2m ago', 'Beef suya + party jollof', 'ALLERGY: Groundnut. Use the dedicated yaji board.', 'Accept & Fire (14m)'),
          _chit('#FK-8942', 'Chioma O. · 3 items · Rider in 3m', 'Jollof, suya, zobo', 'Suya grill · hot bag hold', 'Mark ready'),
          _chit('#FK-8940', 'Pickup · Tobi A. at the pass', 'Ofada rice & ayamase', 'Fire bay · pot 2', 'Mark ready'),
          _chit('#FK-8938', 'Funke A. · Bin #3', 'Bagged & sealed', 'Chowdeck rider · shelf B', 'Complete dispatch'),
        ]),
      ],
    );
  }

  Widget _chit(String id, String meta, String items, String note, String action) {
    return SizedBox(
      width: 280,
      child: KCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(id, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          Text(meta, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 8),
          Text(items, style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text(note, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 12),
          PrimaryButton(label: action, onPressed: () => session.showToast('Ticket status updated')),
        ]),
      ),
    );
  }
}
