import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class PromotionsScreen extends StatelessWidget {
  PromotionsScreen({super.key, required this.session, required this.onCreate});
  final KitchenSession session;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Promotions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text('Codes, delivery offers, and the dates they run.', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
          ])),
          PrimaryButton(label: 'New promotion', icon: Icons.add, onPressed: onCreate),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _kpi('Redeemed this week', '228', 'JOLLOF25 leads'),
          _kpi('Discount given', '₦1.84m', '3.8% of GMV'),
          _kpi('Direct lift', '+₦4.8m', 'Versus aggregator take'),
        ]),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _promo('JOLLOF25', 'Welcome feast', '25% off the first 3 orders this week.', 'Active', '142 uses', true),
          _promo('LEKKI', 'Island delivery', 'Free Direct delivery, 11:30–14:30.', 'Scheduled', 'Starts Monday', false),
          _promo('SUYA10', 'Evening suya', '₦1,500 off orders over ₦8,000.', 'Active', '86 uses', true),
        ]),
      ],
    );
  }

  Widget _promo(String code, String title, String body, String state, String meta, bool live) {
    return SizedBox(
      width: 260,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: live ? KitchenColors.primary : KitchenColors.outlineVariant),
          color: KitchenColors.surfaceLowest,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(code, style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w800, color: KitchenColors.primary)),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 6),
          Text(body, style: TextStyle(color: KitchenColors.onSurfaceVariant)),
          SizedBox(height: 12),
          Row(children: [
            KPill(label: state, fg: live ? KitchenColors.secondary : KitchenColors.tertiary, bg: live ? KitchenColors.secondaryContainer : KitchenColors.primaryFixed),
            Spacer(),
            Text(meta, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: live ? 0.72 : 0.15, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: KitchenColors.primary),
          ),
        ]),
      ),
    );
  }

  Widget _kpi(String label, String value, String detail) {
    return SizedBox(
      width: 220,
      child: KCard(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: KitchenColors.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(detail, style: TextStyle(fontSize: 12, color: KitchenColors.secondary, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}
