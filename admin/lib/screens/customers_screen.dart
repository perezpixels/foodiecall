import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class CustomersScreen extends StatefulWidget {
  CustomersScreen({super.key, required this.session});
  final KitchenSession session;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _Guest {
  _Guest({
    required this.name,
    required this.area,
    required this.channel,
    required this.orders,
    required this.spend,
    required this.status,
    required this.favorite,
    required this.phone,
    required this.note,
    required this.history,
  });

  final String name;
  final String area;
  final String channel;
  final int orders;
  final String spend;
  final String status;
  final String favorite;
  final String phone;
  String note;
  final List<String> history;
  bool suspended = false;
}

class _CustomersScreenState extends State<CustomersScreen> {
  final query = TextEditingController();
  String filter = 'All';
  late final List<_Guest> guests;
  late _Guest selected;

  @override
  void initState() {
    super.initState();
    guests = [
      _Guest(name: 'Adaeze Okonkwo', area: 'Lekki Phase 1', channel: 'Chowdeck', orders: 18, spend: '₦246,000', status: 'Active', favorite: 'Party jollof', phone: '+234 803 220 1184', note: 'Prefers less pepper.', history: ['#FK-8920 · Jollof · ₦4,500', '#FK-8801 · Suya · ₦6,500']),
      _Guest(name: 'Tobi Adeniran', area: 'Victoria Island', channel: 'Foodiecall Direct', orders: 4, spend: '₦38,200', status: 'Groundnut flag', favorite: 'Ofada & ayamase', phone: '+234 701 555 0190', note: 'No groundnut in yaji.', history: ['#FK-8945 · Suya · allergy hold']),
      _Guest(name: 'Chioma Obi', area: '14 Admiralty Way, Lekki', channel: 'Foodiecall Direct', orders: 11, spend: '₦162,400', status: 'Active', favorite: 'Egusi & pounded yam', phone: '+234 809 100 3344', note: 'Gate code 4412.', history: ['#FK-8942 · Jollof, suya, zobo']),
      _Guest(name: 'Funke Adewale', area: 'Surulere', channel: 'Pickup', orders: 7, spend: '₦54,000', status: 'Active', favorite: 'Small chops', phone: '+234 802 441 7781', note: 'Collects from the VI pass.', history: ['#FK-8938 · Bagged · ₦18,400']),
      _Guest(name: 'Halima Sule', area: 'Ikeja GRA', channel: 'Glovo', orders: 9, spend: '₦91,500', status: 'Active', favorite: 'Catfish pepper soup', phone: '+234 816 300 2290', note: 'Calls ahead on Fridays.', history: ['#FK-8931 · Ofada · ₦5,800']),
      _Guest(name: 'Zainab Musa', area: 'Ikoyi', channel: 'Chowdeck', orders: 2, spend: '₦15,700', status: 'Active', favorite: 'Zobo & plantain', phone: '+234 705 888 0142', note: 'New this month.', history: ['#FK-8910 · Zobo · ₦1,200']),
    ];
    selected = guests.first;
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shown = guests.where((guest) {
      final matchesFilter = filter == 'All' || (filter == 'Suspended' ? guest.suspended : guest.status == filter || (filter == 'Active' && !guest.suspended && guest.status == 'Active'));
      final text = query.text.toLowerCase();
      final matchesQuery = text.isEmpty || guest.name.toLowerCase().contains(text) || guest.area.toLowerCase().contains(text);
      return matchesFilter && matchesQuery;
    }).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Text('Customers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        Text('Accounts, addresses, allergy notes, and reorder history for Victoria Island.', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
        SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _Stat('${guests.where((g) => !g.suspended).length}', 'Active on the books'),
          _Stat('${guests.where((g) => g.status.contains('flag')).length}', 'Allergy notes'),
          _Stat('₦608,000', 'Spend this month'),
        ]),
        SizedBox(height: 16),
        KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(icon: Icons.map, title: 'Spend by neighbourhood'),
          SizedBox(height: 10),
          _area('Lekki Phase 1', 0.92, '₦246,000'),
          _area('Victoria Island', 0.66, '₦162,400'),
          _area('Ikeja GRA', 0.38, '₦91,500'),
          _area('Surulere', 0.22, '₦54,000'),
          _area('Ikoyi', 0.08, '₦15,700'),
        ])),
        SizedBox(height: 16),
        TextField(
          controller: query,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search name or area',
            prefixIcon: Icon(Icons.search, color: KitchenColors.onSurfaceVariant),
            filled: true,
            fillColor: KitchenColors.surfaceLowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        SizedBox(height: 12),
        Wrap(spacing: 8, children: [
          for (final item in ['All', 'Active', 'Groundnut flag', 'Suspended'])
            ChoiceChip(
              label: Text(item),
              selected: filter == item,
              selectedColor: KitchenColors.primary,
              labelStyle: TextStyle(color: filter == item ? KitchenColors.onPrimary : KitchenColors.onSurface, fontWeight: FontWeight.w600),
              onSelected: (_) => setState(() => filter = item),
            ),
        ]),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final grid = Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final guest in shown)
                _card(guest),
            ],
          );
          final detail = _detail(selected);
          if (c.maxWidth < 980) return Column(children: [grid, SizedBox(height: 16), detail]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: grid), SizedBox(width: 16), SizedBox(width: 320, child: detail)]);
        }),
      ],
    );
  }

  Widget _card(_Guest guest) {
    final active = selected == guest;
    final status = guest.suspended ? 'Suspended' : guest.status;
    return SizedBox(
      width: 240,
      child: Material(
        color: KitchenColors.surfaceLowest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => setState(() => selected = guest),
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: active ? KitchenColors.primary : KitchenColors.outlineVariant, width: active ? 2 : 1),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(backgroundColor: KitchenColors.primaryFixed, child: Text(_initials(guest.name), style: TextStyle(color: KitchenColors.primary, fontWeight: FontWeight.w800))),
                SizedBox(width: 8),
                Expanded(child: Text(guest.name, style: TextStyle(fontWeight: FontWeight.w700))),
              ]),
              SizedBox(height: 8),
              Text(guest.area, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
              Text(guest.channel, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
              SizedBox(height: 8),
              Text(guest.spend, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: KitchenColors.primary)),
              Text('${guest.orders} orders · ${guest.favorite}', style: TextStyle(fontSize: 12)),
              SizedBox(height: 8),
              KPill(label: status, fg: status == 'Active' ? KitchenColors.secondary : KitchenColors.error, bg: status == 'Active' ? KitchenColors.secondaryContainer : KitchenColors.errorContainer),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _detail(_Guest guest) {
    return KCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(guest.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        Text(guest.phone, style: TextStyle(color: KitchenColors.onSurfaceVariant)),
        SizedBox(height: 8),
        Text(guest.area, style: TextStyle(fontWeight: FontWeight.w600)),
        Text('Usual: ${guest.favorite}'),
        SizedBox(height: 8),
        Text(guest.note),
        SizedBox(height: 12),
        Text('Recent tickets', style: TextStyle(fontWeight: FontWeight.w700)),
        for (final line in guest.history) Padding(padding: EdgeInsets.only(top: 4), child: Text(line)),
        SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          GhostButton(label: 'Message', icon: Icons.sms_outlined, onPressed: () => widget.session.showToast('SMS queued for ${guest.name}')),
          GhostButton(label: 'Reorder favorite', icon: Icons.replay, onPressed: () => widget.session.showToast('${guest.favorite} added as a phone ticket')),
          GhostButton(
            label: guest.suspended ? 'Reinstate' : 'Suspend',
            icon: Icons.block,
            onPressed: () => setState(() {
              guest.suspended = !guest.suspended;
              widget.session.showToast(guest.suspended ? '${guest.name} is suspended' : '${guest.name} is active again');
            }),
          ),
        ]),
      ]),
    );
  }

  Widget _area(String name, double share, String spend) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w700))),
          Text(spend, style: TextStyle(fontWeight: FontWeight.w700, color: KitchenColors.primary)),
        ]),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(value: share, minHeight: 8, backgroundColor: KitchenColors.surfaceContainer, color: KitchenColors.primary),
        ),
      ]),
    );
  }
}

String _initials(String name) => name.split(' ').map((part) => part[0]).take(2).join();

class _Stat extends StatelessWidget {
  _Stat(this.value, this.label);
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: KCard(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
