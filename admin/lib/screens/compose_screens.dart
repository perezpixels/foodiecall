import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/kitchen_widgets.dart';

class PhoneOrderScreen extends StatefulWidget {
  PhoneOrderScreen({super.key, required this.session, required this.onClose});
  final KitchenSession session;
  final VoidCallback onClose;

  @override
  State<PhoneOrderScreen> createState() => _PhoneOrderScreenState();
}

class _PhoneOrderScreenState extends State<PhoneOrderScreen> {
  final name = TextEditingController(text: 'Ngozi Eze');
  final phone = TextEditingController(text: '+234 809 441 2201');
  final address = TextEditingController(text: '12 Bourdillon Road, Ikoyi');
  final note = TextEditingController();
  String handover = 'Bike delivery';
  final qty = <String, int>{'Party Jollof Rice': 1, 'Zobo': 1};

  static const catalog = {
    'Party Jollof Rice': 4500,
    'Beef Suya Platter': 6500,
    'Egusi & Pounded Yam': 7200,
    'Ofada Rice & Ayamase': 5800,
    'Catfish Pepper Soup': 8500,
    'Asun': 5200,
    'Fried Plantain': 1500,
    'Zobo': 1200,
  };

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    address.dispose();
    note.dispose();
    super.dispose();
  }

  int get subtotal => qty.entries.fold(0, (sum, e) => sum + catalog[e.key]! * e.value);
  int get delivery => handover == 'Pickup at VI' ? 0 : 1500;
  int get total => subtotal + delivery + 400;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        _FormHead(title: 'New manual phone order', subtitle: 'Victoria Island switchboard · ticket lands on the expo pass', onClose: widget.onClose),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final form = Column(children: [
            KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionTitle(icon: Icons.call, title: 'Guest'),
              SizedBox(height: 12),
              _field('Name', name),
              SizedBox(height: 10),
              _field('Phone', phone),
              SizedBox(height: 10),
              _field('Address', address),
              SizedBox(height: 12),
              Wrap(spacing: 8, children: [
                for (final option in ['Bike delivery', 'Pickup at VI', 'Chowdeck handoff'])
                  ChoiceChip(
                    label: Text(option),
                    selected: handover == option,
                    selectedColor: KitchenColors.primary,
                    labelStyle: TextStyle(color: handover == option ? KitchenColors.onPrimary : KitchenColors.onSurface, fontWeight: FontWeight.w600),
                    onSelected: (_) => setState(() => handover = option),
                  ),
              ]),
            ])),
            SizedBox(height: 16),
            KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionTitle(icon: Icons.restaurant_menu, title: 'Dishes'),
              SizedBox(height: 8),
              for (final entry in catalog.entries)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    Expanded(child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.w600))),
                    Text('₦${_money(entry.value)}', style: TextStyle(color: KitchenColors.primary, fontWeight: FontWeight.w700)),
                    SizedBox(width: 12),
                    _stepper(entry.key),
                  ]),
                ),
              SizedBox(height: 8),
              _field('Kitchen note', note, hint: 'Less pepper, extra plantain, no groundnut'),
            ])),
          ]);
          final quote = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ticket quote', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            for (final entry in qty.entries.where((e) => e.value > 0))
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  Expanded(child: Text('${entry.value}× ${entry.key}')),
                  Text('₦${_money(catalog[entry.key]! * entry.value)}'),
                ]),
              ),
            Divider(),
            Text('Subtotal ₦${_money(subtotal)}'),
            Text(handover == 'Pickup at VI' ? 'Delivery ₦0' : 'Priority bike ₦${_money(delivery)}'),
            Text('Packaging ₦400'),
            SizedBox(height: 8),
            Text('Total ₦${_money(total)}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: KitchenColors.primary)),
            SizedBox(height: 8),
            KPill(label: handover, fg: KitchenColors.secondary, bg: KitchenColors.secondaryContainer),
            SizedBox(height: 16),
            PrimaryButton(
              label: 'Fire ticket to expo',
              icon: Icons.local_fire_department,
              onPressed: () {
                widget.session.showToast('Phone order #FK-8950 fired · ₦${_money(total)}');
                widget.onClose();
              },
            ),
          ]));
          if (c.maxWidth < 900) return Column(children: [form, SizedBox(height: 16), quote]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: form), SizedBox(width: 16), Expanded(flex: 2, child: quote)]);
        }),
      ],
    );
  }

  Widget _stepper(String dish) {
    final count = qty[dish] ?? 0;
    return Row(children: [
      IconButton(onPressed: () => setState(() => qty[dish] = (count - 1).clamp(0, 9)), icon: Icon(Icons.remove_circle_outline, color: KitchenColors.primary)),
      Text('$count', style: TextStyle(fontWeight: FontWeight.w700)),
      IconButton(onPressed: () => setState(() => qty[dish] = (count + 1).clamp(0, 9)), icon: Icon(Icons.add_circle_outline, color: KitchenColors.primary)),
    ]);
  }
}

class NewDishScreen extends StatefulWidget {
  NewDishScreen({super.key, required this.session, required this.onClose});
  final KitchenSession session;
  final VoidCallback onClose;

  @override
  State<NewDishScreen> createState() => _NewDishScreenState();
}

class _NewDishScreenState extends State<NewDishScreen> {
  final name = TextEditingController(text: 'Afang Soup & Fufu');
  final price = TextEditingController(text: '7800');
  final description = TextEditingController(text: 'Waterleaf and okazi in palm oil, served with soft fufu.');
  String category = 'Soups & Swallow';
  String station = 'Soup Pot';
  bool featured = true;

  @override
  void dispose() {
    name.dispose();
    price.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        _FormHead(title: 'Add a new dish', subtitle: 'Goes live on Chowdeck, Glovo, and the Foodiecall store after you publish', onClose: widget.onClose),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final fields = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.ramen_dining, title: 'Recipe'),
            SizedBox(height: 12),
            _field('Dish name', name, onChanged: () => setState(() {})),
            SizedBox(height: 10),
            _field('Description', description, onChanged: () => setState(() {})),
            SizedBox(height: 10),
            _field('Base price (₦)', price, onChanged: () => setState(() {})),
            SizedBox(height: 12),
            Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              for (final item in ['Rice & Stews', 'Grills & Suya', 'Soups & Swallow', 'Small Chops', 'Drinks'])
                ChoiceChip(
                  label: Text(item),
                  selected: category == item,
                  selectedColor: KitchenColors.primary,
                  labelStyle: TextStyle(color: category == item ? KitchenColors.onPrimary : KitchenColors.onSurface),
                  onSelected: (_) => setState(() => category = item),
                ),
            ]),
            SizedBox(height: 12),
            Text('Station', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              for (final item in ['Fire Bay', 'Grill', 'Soup Pot', 'Small Chops'])
                ChoiceChip(
                  label: Text(item),
                  selected: station == item,
                  selectedColor: KitchenColors.tertiary,
                  labelStyle: TextStyle(color: station == item ? Colors.white : KitchenColors.onSurface),
                  onSelected: (_) => setState(() => station = item),
                ),
            ]),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Feature on the evening menu'),
              value: featured,
              activeThumbColor: KitchenColors.onPrimary,
              activeTrackColor: KitchenColors.primary,
              onChanged: (value) => setState(() => featured = value),
            ),
          ]));
          final preview = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [KitchenColors.primary, KitchenColors.tertiary]),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.soup_kitchen, color: Colors.white, size: 48),
            ),
            SizedBox(height: 12),
            Text(name.text.isEmpty ? 'Untitled dish' : name.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Text(description.text, style: TextStyle(color: KitchenColors.onSurfaceVariant)),
            SizedBox(height: 8),
            Text('₦${price.text}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: KitchenColors.primary)),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              KPill(label: category, fg: KitchenColors.primary, bg: KitchenColors.primaryFixed),
              KPill(label: station),
              if (featured) KPill(label: 'Featured', fg: KitchenColors.secondary, bg: KitchenColors.secondaryContainer),
            ]),
            SizedBox(height: 16),
            PrimaryButton(
              label: 'Publish dish',
              icon: Icons.publish,
              onPressed: () {
                widget.session.showToast('${name.text} is live at ₦${price.text}');
                widget.onClose();
              },
            ),
          ]));
          if (c.maxWidth < 900) return Column(children: [fields, SizedBox(height: 16), preview]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: fields), SizedBox(width: 16), Expanded(flex: 2, child: preview)]);
        }),
      ],
    );
  }
}

class NewPromotionScreen extends StatefulWidget {
  NewPromotionScreen({super.key, required this.session, required this.onClose});
  final KitchenSession session;
  final VoidCallback onClose;

  @override
  State<NewPromotionScreen> createState() => _NewPromotionScreenState();
}

class _NewPromotionScreenState extends State<NewPromotionScreen> {
  final code = TextEditingController(text: 'EFO15');
  final title = TextEditingController(text: 'Efo riro Friday');
  final value = TextEditingController(text: '15');
  bool percent = true;
  String window = 'Dinner';

  @override
  void dispose() {
    code.dispose();
    title.dispose();
    value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offer = percent ? '${value.text}% off' : '₦${value.text} off';
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        _FormHead(title: 'New promotion', subtitle: 'Codes apply on Foodiecall Direct first, then Chowdeck and Glovo if you include them', onClose: widget.onClose),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final fields = KCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionTitle(icon: Icons.sell_outlined, title: 'Offer'),
            SizedBox(height: 12),
            _field('Code', code, onChanged: () => setState(() {})),
            SizedBox(height: 10),
            _field('Name', title, onChanged: () => setState(() {})),
            SizedBox(height: 10),
            _field(percent ? 'Percent off' : 'Naira off', value, onChanged: () => setState(() {})),
            SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              ChoiceChip(
                label: Text('Percentage'),
                selected: percent,
                selectedColor: KitchenColors.primary,
                labelStyle: TextStyle(color: percent ? KitchenColors.onPrimary : KitchenColors.onSurface),
                onSelected: (_) => setState(() => percent = true),
              ),
              ChoiceChip(
                label: Text('Fixed naira'),
                selected: !percent,
                selectedColor: KitchenColors.primary,
                labelStyle: TextStyle(color: !percent ? KitchenColors.onPrimary : KitchenColors.onSurface),
                onSelected: (_) => setState(() => percent = false),
              ),
            ]),
            SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              for (final item in ['Lunch', 'Dinner', 'All day'])
                ChoiceChip(
                  label: Text(item),
                  selected: window == item,
                  selectedColor: KitchenColors.secondary,
                  labelStyle: TextStyle(color: window == item ? Colors.white : KitchenColors.onSurface),
                  onSelected: (_) => setState(() => window = item),
                ),
            ]),
          ]));
          final preview = Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [KitchenColors.primary, KitchenColors.primaryContainer]),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(code.text, style: TextStyle(color: Colors.white, letterSpacing: 1.4, fontWeight: FontWeight.w800)),
              SizedBox(height: 8),
              Text(title.text, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              SizedBox(height: 6),
              Text('$offer · $window · Victoria Island', style: TextStyle(color: Colors.white)),
              SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: KitchenColors.primaryContainer, shape: StadiumBorder()),
                onPressed: () {
                  widget.session.showToast('${code.text} is scheduled for $window');
                  widget.onClose();
                },
                child: Text('Publish promotion'),
              ),
            ]),
          );
          if (c.maxWidth < 900) return Column(children: [fields, SizedBox(height: 16), preview]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: fields), SizedBox(width: 16), Expanded(flex: 2, child: preview)]);
        }),
      ],
    );
  }
}

class _FormHead extends StatelessWidget {
  _FormHead({required this.title, required this.subtitle, required this.onClose});
  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(onPressed: onClose, icon: Icon(Icons.arrow_back, color: KitchenColors.onSurface)),
      SizedBox(width: 4),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        Text(subtitle, style: TextStyle(color: KitchenColors.onSurfaceVariant)),
      ])),
    ]);
  }
}

Widget _field(String label, TextEditingController controller, {String? hint, VoidCallback? onChanged}) {
  return TextField(
    controller: controller,
    onChanged: (_) => onChanged?.call(),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: KitchenColors.surfaceLow,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    ),
  );
}

String _money(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}
