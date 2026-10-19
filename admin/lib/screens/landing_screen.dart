import 'package:flutter/material.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  late final AnimationController _rise;
  late final AnimationController _drift;

  static final _playStore = Uri.parse('https://play.google.com/store/apps/details?id=com.foodiecall.kitchen');
  static final _appStore = Uri.parse('https://apps.apple.com/app/foodiecall-kitchen/id0000000000');

  @override
  void initState() {
    super.initState();
    _rise = AnimationController(vsync: this, duration: Duration(milliseconds: 900))..forward();
    _drift = AnimationController(vsync: this, duration: Duration(seconds: 14))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rise.dispose();
    _drift.dispose();
    super.dispose();
  }

  Future<void> _openReact() async {
    final target = Uri.base.resolve('react/');
    final ok = await launchUrl(target, webOnlyWindowName: '_self');
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open /react/ on this host to compare.')));
    }
  }

  Future<void> _openStore(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Store listing opens when the customer app is published.')),
      );
    }
  }

  void _showDownloadSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: KitchenColors.surfaceLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get the Foodiecall app', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              SizedBox(height: 6),
              Text('Order party jollof, suya, and egusi on your phone.', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: KitchenColors.onSurface, foregroundColor: KitchenColors.surface, shape: StadiumBorder()),
                  onPressed: () {
                    Navigator.pop(context);
                    _openStore(_playStore);
                  },
                  icon: Icon(Icons.android),
                  label: Text('Download on Google Play'),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KitchenColors.onSurface,
                    side: BorderSide(color: KitchenColors.outlineVariant),
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _openStore(_appStore);
                  },
                  icon: Icon(Icons.apple),
                  label: Text('Download on the App Store'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 980;
    return Scaffold(
      backgroundColor: KitchenColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _hero(wide)),
          SliverToBoxAdapter(child: _promise()),
          SliverToBoxAdapter(child: _roles(wide)),
          SliverToBoxAdapter(child: _flow()),
          SliverToBoxAdapter(child: _footer()),
        ],
      ),
    );
  }

  Widget _hero(bool wide) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height.clamp(640, 920),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _drift,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.04 + (_drift.value * 0.03),
                child: child,
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3A1608), Color(0xFFA33900), Color(0xFF1E1B19)],
                    ),
                  ),
                ),
                Image.network(
                  'https://images.unsplash.com/photo-1604329760661-e7a0b38c5cbb?auto=format&fit=crop&w=2400&q=80',
                  fit: BoxFit.cover,
                  color: Color(0x661E1B19),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (_, __, ___) => SizedBox.shrink(),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33000000), Color(0xCC1E1B19)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: wide ? 56 : 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: CurvedAnimation(parent: _rise, curve: Interval(0, 0.4, curve: Curves.easeOut)),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: KitchenColors.primary, borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.restaurant, color: Colors.white, size: 22),
                        ),
                        SizedBox(width: 12),
                        Text('Foodiecall', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.4)),
                        Spacer(),
                        TextButton(
                          onPressed: _openReact,
                          child: Text('React', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        ),
                        TextButton(
                          onPressed: widget.onGetStarted,
                          child: Text('Kitchen portal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  FadeTransition(
                    opacity: CurvedAnimation(parent: _rise, curve: Interval(0.15, 0.7, curve: Curves.easeOut)),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: _rise, curve: Interval(0.15, 0.75, curve: Curves.easeOutCubic))),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 640),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Foodiecall',
                              style: TextStyle(
                                fontSize: wide ? 72 : 48,
                                fontWeight: FontWeight.w800,
                                height: 0.95,
                                letterSpacing: -2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Chef-crafted Lagos meals, ordered on call and run from one kitchen pass.',
                              style: TextStyle(fontSize: wide ? 20 : 17, height: 1.4, color: Color(0xFFE9E1DD), fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 28),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  height: 54,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: KitchenColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 28),
                                      shape: StadiumBorder(),
                                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: widget.onGetStarted,
                                    child: Text('Get started'),
                                  ),
                                ),
                                SizedBox(
                                  height: 54,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(color: Colors.white70),
                                      padding: EdgeInsets.symmetric(horizontal: 22),
                                      shape: StadiumBorder(),
                                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: _showDownloadSheet,
                                    icon: Icon(Icons.phone_iphone, size: 20),
                                    label: Text('Download app'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: wide ? 64 : 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promise() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 72, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Text('One kitchen. Two surfaces.', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -0.8, height: 1.1)),
              SizedBox(height: 12),
              Text(
                'Guests browse, build a plate, pay, and track. Chefs run orders, menu, and dispatch from the Victoria Island portal.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5, color: KitchenColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roles(bool wide) {
    final guest = _roleBlock(
      icon: Icons.phone_iphone,
      title: 'For guests',
      body: 'Party jollof, suya, egusi, and pepper soup with portions, extras, and live tracking across Lagos.',
      action: 'Download on Play / App Store',
      onPressed: _showDownloadSheet,
    );
    final kitchen = _roleBlock(
      icon: Icons.soup_kitchen_outlined,
      title: 'For the kitchen',
      body: 'Dashboard, tickets, 86 inventory, customers, promotions, and reports on one pass for Chef Amaka’s brigade.',
      action: 'Open kitchen portal',
      onPressed: widget.onGetStarted,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: wide ? 56 : 24, vertical: 24),
      child: wide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: guest), SizedBox(width: 28), Expanded(child: kitchen)])
          : Column(children: [guest, SizedBox(height: 28), kitchen]),
    );
  }

  Widget _roleBlock({
    required IconData icon,
    required String title,
    required String body,
    required String action,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32, color: KitchenColors.primary),
        SizedBox(height: 16),
        Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
        SizedBox(height: 10),
        Text(body, style: TextStyle(fontSize: 15, height: 1.5, color: KitchenColors.onSurfaceVariant)),
        SizedBox(height: 18),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(foregroundColor: KitchenColors.primary, padding: EdgeInsets.zero),
          child: Text(action, style: TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  Widget _flow() {
    final steps = [
      ('Browse', 'Categories, search, and chef specials.'),
      ('Build', 'Portions, extras, and naira totals.'),
      ('Track', 'Fire → pack → rider → door.'),
      ('Run', 'Kitchen portal for every ticket.'),
    ];
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [KitchenColors.surfaceLow, KitchenColors.primaryFixed.withValues(alpha: 0.55)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 980),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From the pot to Lekki', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
              SizedBox(height: 8),
              Text('The customer app and kitchen portal share one order timeline.', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
              SizedBox(height: 28),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  for (var i = 0; i < steps.length; i++)
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('0${i + 1}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: KitchenColors.primary, letterSpacing: 1)),
                          SizedBox(height: 8),
                          Text(steps[i].$1, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                          SizedBox(height: 6),
                          Text(steps[i].$2, style: TextStyle(color: KitchenColors.onSurfaceVariant, height: 1.4)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 48, 24, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Text('Ready for dinner rush?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              SizedBox(height: 10),
              Text('Start in the kitchen portal, or put Foodiecall on your guests’ phones.', textAlign: TextAlign.center, style: TextStyle(color: KitchenColors.onSurfaceVariant)),
              SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: KitchenColors.primary, foregroundColor: Colors.white, minimumSize: Size(160, 48), shape: StadiumBorder()),
                    onPressed: widget.onGetStarted,
                    child: Text('Get started'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: KitchenColors.onSurface, side: BorderSide(color: KitchenColors.outlineVariant), minimumSize: Size(160, 48), shape: StadiumBorder()),
                    onPressed: _showDownloadSheet,
                    child: Text('Download app'),
                  ),
                ],
              ),
              SizedBox(height: 36),
              Text('Foodiecall Kitchen · Victoria Island, Lagos · WAT', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
