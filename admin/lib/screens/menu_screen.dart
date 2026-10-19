import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key, required this.session, required this.onAddDish});
  final KitchenSession session;
  final VoidCallback onAddDish;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Menu & 86 Inventory Hub', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text('POS Sync Live · 41 active recipes', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
          ])),
          GhostButton(label: 'Batch 86 Ingredients', icon: Icons.block, onPressed: () => _batch(context)),
          SizedBox(width: 8),
          PrimaryButton(label: 'Add new dish', icon: Icons.add, onPressed: onAddDish),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _Mini('38 / 41', 'Live active online'),
          _Mini('3', "Currently 86'd · next arrival 4:30 PM"),
          _Mini('71.4%', 'Avg food cost margin · target 70%'),
        ]),
        SizedBox(height: 12),
        Wrap(spacing: 8, children: [
          KPill(label: 'All Items (41)', fg: KitchenColors.onPrimary, bg: KitchenColors.primary),
          KPill(label: 'Rice & Stews (12)'),
          KPill(label: 'Grills & Suya (8)'),
          KPill(label: 'Soups & Swallow (10)'),
          KPill(label: 'Small Chops (6)'),
          KPill(label: 'Drinks (5)'),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _dishCard('Party Jollof Rice', 'Fire Bay', '₦4,500', 'In stock', false),
          _dishCard('Beef Suya Platter', 'Grill', '₦6,500', '86’d · yaji', true),
          _dishCard('Ofada & Ayamase', 'Fire Bay', '₦5,800', '14 left', false),
          _dishCard('Egusi & Pounded Yam', 'Soup Pot', '₦7,200', 'In stock', false),
          _dishCard('Catfish Pepper Soup', 'Soup Pot', '₦8,500', '3 left', false),
          _dishCard('Asun', 'Grill', '₦5,200', '86’d', true),
        ]),
        SizedBox(height: 16),
        Text('Showing 6 of 41 active catalog recipes', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
        SizedBox(height: 16),
        KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(icon: Icons.tune, title: 'Global Modifiers & Add-on Availability'),
          SizedBox(height: 8),
          Text('Add-ons apply across rice, grills, and soups.', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            KPill(label: "Agege bread · 86'd", fg: KitchenColors.error, bg: KitchenColors.errorContainer),
            KPill(label: 'Extra plantain · ₦800', fg: KitchenColors.secondary, bg: Color(0x26006E2D)),
            KPill(label: 'Agege bread · Disabled'),
            KPill(label: 'Boiled egg · ₦500', fg: KitchenColors.secondary, bg: Color(0x26006E2D)),
          ]),
        ])),
      ],
    );
  }

  Widget _dishCard(String name, String station, String price, String status, bool out) {
    return SizedBox(
      width: 220,
      child: KCard(
        padding: EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: out ? KitchenColors.errorContainer : KitchenColors.primaryFixed,
            ),
            alignment: Alignment.center,
            child: Icon(out ? Icons.block : Icons.ramen_dining, color: out ? KitchenColors.error : KitchenColors.primary),
          ),
          SizedBox(height: 10),
          Text(name, style: TextStyle(fontWeight: FontWeight.w700)),
          Text(station, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 8),
          Text(price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: KitchenColors.primary)),
          SizedBox(height: 6),
          Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: out ? KitchenColors.error : KitchenColors.secondary)),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: out ? 0.04 : 0.78, minHeight: 6, backgroundColor: KitchenColors.surfaceContainer, color: out ? KitchenColors.error : KitchenColors.secondary),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: () => session.showToast('Edit $name'), icon: Icon(Icons.edit, size: 18, color: KitchenColors.onSurfaceVariant)),
          ),
        ]),
      ),
    );
  }

  void _batch(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm & Broadcast 86'),
        content: Text('Yaji, ofada rice, and goat meat. Suya, ofada, and asun leave the menu until the truck arrives.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              session.showToast('86 broadcast sent to aggregators');
            },
            child: Text('Confirm & Broadcast 86'),
          ),
        ],
      ),
    );
  }

  Widget _row(String dish, String station, String price, String status, String cap, String margin, bool out) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Expanded(flex: 3, child: Text(dish, style: TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(station, style: TextStyle(fontSize: 12))),
        Expanded(child: Text(price, style: TextStyle(fontWeight: FontWeight.w700))),
        Expanded(flex: 2, child: Text(status, style: TextStyle(fontWeight: FontWeight.w700, color: out ? KitchenColors.error : KitchenColors.secondary))),
        Expanded(flex: 2, child: Text(cap, style: TextStyle(fontSize: 12))),
        Expanded(child: Text(margin, style: TextStyle(fontSize: 12))),
        IconButton(onPressed: () => session.showToast('Edit $dish'), icon: Icon(Icons.edit, size: 18)),
      ]),
    );
  }
}

class _Head extends StatelessWidget {
  _Head();
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: KitchenColors.onSurfaceVariant);
    return Row(children: [
      Expanded(flex: 3, child: Text('DISH / RECIPE', style: style)),
      Expanded(child: Text('STATION', style: style)),
      Expanded(child: Text('PRICE', style: style)),
      Expanded(flex: 2, child: Text('STATUS', style: style)),
      Expanded(flex: 2, child: Text('CAP / SOLD', style: style)),
      Expanded(child: Text('MARGIN', style: style)),
      SizedBox(width: 40),
    ]);
  }
}

class _Mini extends StatelessWidget {
  _Mini(this.value, this.label);
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 240, child: KCard(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
    ])));
  }
}
