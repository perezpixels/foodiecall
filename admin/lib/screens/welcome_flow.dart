import 'package:flutter/material.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';

class WelcomeFlow extends StatefulWidget {
  WelcomeFlow({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<WelcomeFlow> createState() => _WelcomeFlowState();
}

class _WelcomeFlowState extends State<WelcomeFlow> {
  int page = 0;

  static final slides = [
    (
      Icons.soup_kitchen,
      KitchenColors.primaryFixed,
      KitchenColors.primary,
      'Party jollof, suya, and egusi',
      'Small-batch stews, smoky suya, and fresh peppers, packed so they still taste like the pot.',
    ),
    (
      Icons.timer_outlined,
      KitchenColors.secondaryContainer,
      KitchenColors.secondary,
      'Hot from the fire in 25 minutes',
      'Jollof leaves the pot steaming, sealed in thermal boxes the line can actually hold through Lagos traffic.',
    ),
    (
      Icons.delivery_dining,
      Color(0xFFFFDDB8),
      KitchenColors.tertiary,
      'From the pass to Lekki',
      'Dispatch pings for Chowdeck, Glovo, and Foodiecall riders, with the same ticket the guest is watching.',
    ),
  ];

  void _next() {
    if (page < slides.length - 1) {
      setState(() => page += 1);
    } else {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 960;
    final slide = slides[page];

    return Scaffold(
      backgroundColor: KitchenColors.surface,
      body: wide ? _webLayout(slide) : _compactLayout(slide),
    );
  }

  Widget _webLayout((IconData, Color, Color, String, String) slide) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A1208), KitchenColors.primary, Color(0xFF1E1B19)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.4, -0.2),
                        radius: 1.1,
                        colors: [KitchenColors.primaryContainer.withValues(alpha: 0.55), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(48, 40, 48, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.restaurant, color: Colors.white),
                          ),
                          SizedBox(width: 12),
                          Text('Foodiecall Kitchen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                        ],
                      ),
                      Spacer(),
                      Text('0${page + 1} / 03', style: TextStyle(color: Color(0xFFFFDBCE), fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                      SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 380),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: Text(
                          slide.$4,
                          key: ValueKey(page),
                          style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w800, height: 1.05, letterSpacing: -1.2),
                        ),
                      ),
                      SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 420),
                        child: Text(slide.$5, style: TextStyle(color: Color(0xFFE9E1DD), fontSize: 17, height: 1.5)),
                      ),
                      SizedBox(height: 36),
                      Wrap(
                        spacing: 10,
                        children: [
                          for (var i = 0; i < slides.length; i++)
                            InkWell(
                              onTap: () => setState(() => page = i),
                              borderRadius: BorderRadius.circular(99),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                width: i == page ? 36 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: i == page ? Colors.white : Colors.white38,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: widget.onFinished, child: Text('Skip'))),
                Spacer(),
                Text('KITCHEN PORTAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: KitchenColors.primary)),
                SizedBox(height: 10),
                Text('Welcome to the line', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.8)),
                SizedBox(height: 10),
                Text('Three beats before you open the Victoria Island pass.', style: TextStyle(color: KitchenColors.onSurfaceVariant, fontSize: 15, height: 1.45)),
                SizedBox(height: 28),
                for (var i = 0; i < slides.length; i++) ...[
                  _StepTile(
                    index: i,
                    active: i == page,
                    title: slides[i].$4,
                    icon: slides[i].$1,
                    iconBg: slides[i].$2,
                    iconColor: slides[i].$3,
                    onTap: () => setState(() => page = i),
                  ),
                  if (i < slides.length - 1) SizedBox(height: 10),
                ],
                Spacer(),
                Row(
                  children: [
                    if (page > 0)
                      TextButton(
                        onPressed: () => setState(() => page -= 1),
                        child: Text('Back'),
                      ),
                    Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: KitchenColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size(180, 52),
                        shape: StadiumBorder(),
                      ),
                      onPressed: _next,
                      child: Text(page < slides.length - 1 ? 'Continue' : 'Get Started'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _compactLayout((IconData, Color, Color, String, String) slide) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 20),
        child: Column(
          children: [
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: widget.onFinished, child: Text('Skip'))),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                child: Column(
                  key: ValueKey(page),
                  children: [
                    SizedBox(height: 8),
                    _BrandMark(),
                    _FreshChip(),
                    Text('Foodiecall Kitchen', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
                    Text('Chef-crafted comfort delivered on call', style: TextStyle(fontSize: 14, color: KitchenColors.onSurfaceVariant)),
                    SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: KitchenColors.surfaceLowest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: KitchenColors.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(color: slide.$2, borderRadius: BorderRadius.circular(16)),
                            child: Icon(slide.$1, color: slide.$3, size: 28),
                          ),
                          SizedBox(height: 16),
                          Text(slide.$4, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          SizedBox(height: 8),
                          Text(slide.$5, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, height: 1.4, color: KitchenColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < slides.length; i++)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: page == i ? 24 : 6,
                    decoration: BoxDecoration(
                      color: page == i ? KitchenColors.primary : KitchenColors.surfaceHighest,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: KitchenColors.primary, foregroundColor: Colors.white, shape: StadiumBorder()),
                onPressed: _next,
                child: Text(page < slides.length - 1 ? 'Continue' : 'Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  _StepTile({
    required this.index,
    required this.active,
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  final int index;
  final bool active;
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? KitchenColors.surfaceLowest : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 220),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: active ? KitchenColors.primary : KitchenColors.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Step 0${index + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: KitchenColors.primary, letterSpacing: 0.6)),
                    Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BrandMark(),
        _FreshChip(),
        Text('Foodiecall Kitchen', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
        Text('Chef-crafted comfort delivered on call', style: TextStyle(fontSize: 14, color: KitchenColors.onSurfaceVariant)),
      ],
    );
  }
}

class _FreshChip extends StatelessWidget {
  _FreshChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: KitchenColors.primaryFixed, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, size: 14, color: Color(0xFF7F2B00)),
          SizedBox(width: 4),
          Text('FRESH FROM THE PAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: Color(0xFF7F2B00))),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: KitchenColors.surfaceContainer,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x141C1917), blurRadius: 12, offset: Offset(0, 4))],
              ),
              alignment: Alignment.center,
              child: Icon(Icons.ramen_dining, size: 42, color: KitchenColors.primary),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: KitchenColors.secondary, shape: BoxShape.circle),
                child: Icon(Icons.restaurant, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
