import 'package:flutter/material.dart';
import 'package:foodiecall_admin/screens/welcome_flow.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key, required this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool kitchen = true;
  int slide = 0;

  static final slides = [
    (Icons.soup_kitchen, KitchenColors.primaryFixed, KitchenColors.primary, 'Party jollof, suya, and egusi', 'Small-batch stews, smoky suya, and fresh peppers'),
    (Icons.timer_outlined, KitchenColors.secondaryContainer, KitchenColors.secondary, 'Hot from the fire in 25 minutes', 'Sealed in thermal boxes for Lagos traffic'),
    (Icons.delivery_dining, Color(0xFFFFDDB8), KitchenColors.tertiary, 'From the pass to Lekki', 'Chowdeck, Glovo, and Foodiecall riders on one ticket'),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 960;
    return Scaffold(
      backgroundColor: KitchenColors.surface,
      body: wide ? _web() : _compact(),
    );
  }

  Widget _web() {
    final current = slides[slide];
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF24140F), KitchenColors.primary, Color(0xFF1E1B19)],
              ),
            ),
            padding: EdgeInsets.fromLTRB(48, 44, 48, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foodiecall', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                Text('KITCHEN PORTAL', style: TextStyle(color: Color(0xFFFFDBCE), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                Spacer(),
                Text('Victoria Island line', style: TextStyle(color: Color(0xFFFFDBCE), fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                SizedBox(height: 12),
                Text('Open the pass for Chef Amaka’s brigade.', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.8)),
                SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Text('PIN for cooks and dispatch. Guest browse stays on the customer app.', style: TextStyle(color: Color(0xFFE9E1DD), height: 1.45, fontSize: 15)),
                ),
                SizedBox(height: 28),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white24)),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: current.$2, borderRadius: BorderRadius.circular(12)),
                        child: Icon(current.$1, color: current.$3),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(current.$4, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            Text(current.$5, style: TextStyle(color: Color(0xFFE9E1DD), fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    for (var i = 0; i < slides.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => slide = i),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 220),
                          margin: EdgeInsets.only(right: 6),
                          height: 8,
                          width: slide == i ? 28 : 8,
                          decoration: BoxDecoration(color: slide == i ? Colors.white : Colors.white38, borderRadius: BorderRadius.circular(99)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 440),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                children: [
                  Text('Sign in', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.6)),
                  Text('Kitchen & dispatch for Victoria Island.', style: TextStyle(color: KitchenColors.onSurfaceVariant)),
                  SizedBox(height: 20),
                  _promo(),
                  SizedBox(height: 16),
                  _roleToggle(),
                  SizedBox(height: 16),
                  ..._authFields(),
                  SizedBox(height: 16),
                  _primaryCta(),
                  SizedBox(height: 8),
                  TextButton(onPressed: widget.onSignedIn, child: Text('Browse Menu as Guest  ›', style: TextStyle(color: KitchenColors.primary, fontWeight: FontWeight.w600))),
                  _terms(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _compact() {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 28),
            children: [
              BrandHeader(),
              SizedBox(height: 20),
              _promo(),
              SizedBox(height: 16),
              _roleToggle(),
              SizedBox(height: 16),
              ..._authFields(),
              SizedBox(height: 12),
              _primaryCta(),
              SizedBox(height: 8),
              TextButton(onPressed: widget.onSignedIn, child: Text('Browse Menu as Guest  ›', style: TextStyle(color: KitchenColors.primary, fontWeight: FontWeight.w600))),
              _terms(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _promo() {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(color: Color(0x1A006E2D), borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundColor: KitchenColors.secondary, child: Icon(Icons.card_giftcard, color: Colors.white, size: 16)),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Welcome Feast Offer', style: TextStyle(color: KitchenColors.secondary, fontWeight: FontWeight.w700, fontSize: 12)),
                    _ChefCall(),
                  ],
                ),
                SizedBox(height: 2),
                Text('Get 25% off your first 3 chef-crafted orders placed this week.', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleToggle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: KitchenColors.surfaceContainer, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          _role('Customer Account', Icons.person_outline, !kitchen, () => setState(() => kitchen = false)),
          _role('Kitchen & Dispatch', Icons.soup_kitchen_outlined, kitchen, () => setState(() => kitchen = true)),
        ],
      ),
    );
  }

  List<Widget> _authFields() {
    if (!kitchen) {
      return [
        _social(_GoogleMark(), 'Continue with Google'),
        SizedBox(height: 8),
        _social(Icon(Icons.apple, size: 22), 'Continue with Apple'),
        SizedBox(height: 14),
        Row(children: [
          Expanded(child: Divider(color: KitchenColors.surfaceHighest)),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('or email address', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: KitchenColors.onSurfaceVariant))),
          Expanded(child: Divider(color: KitchenColors.surfaceHighest)),
        ]),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'your.email@example.com',
            prefixIcon: Icon(Icons.mail_outline, color: KitchenColors.onSurfaceVariant),
            filled: true,
            fillColor: KitchenColors.surfaceLowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
          ),
        ),
      ];
    }
    return [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KitchenColors.surfaceLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: KitchenColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.badge_outlined, color: KitchenColors.primary), SizedBox(width: 8), Text('Kitchen Portal Login', style: TextStyle(fontWeight: FontWeight.w600, color: KitchenColors.primary))]),
            SizedBox(height: 6),
            Text('Quick pin code authentication for line cooks, sous chefs, and delivery coordinators.', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter 4 or 6-digit Kitchen PIN',
                prefixIcon: Icon(Icons.pin, color: KitchenColors.onSurfaceVariant),
                filled: true,
                fillColor: KitchenColors.surfaceContainer,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _primaryCta() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: kitchen ? KitchenColors.onSurface : KitchenColors.primary,
          foregroundColor: kitchen ? KitchenColors.surface : Colors.white,
          shape: StadiumBorder(),
        ),
        onPressed: widget.onSignedIn,
        icon: Icon(kitchen ? Icons.login : Icons.arrow_forward, size: 18),
        label: Text(kitchen ? 'Open Line Display' : 'Get Started / Sign In'),
      ),
    );
  }

  Widget _terms() {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant),
        children: [
          TextSpan(text: 'By signing in, you agree to our '),
          TextSpan(text: 'Terms of Service', style: TextStyle(decoration: TextDecoration.underline, color: KitchenColors.onSurface)),
          TextSpan(text: ' & '),
          TextSpan(text: 'Privacy Policy', style: TextStyle(decoration: TextDecoration.underline, color: KitchenColors.onSurface)),
          TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _role(String label, IconData icon, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? KitchenColors.surfaceLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected ? [BoxShadow(color: Color(0x141C1917), blurRadius: 6)] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? KitchenColors.onSurface : KitchenColors.onSurfaceVariant),
              SizedBox(width: 6),
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? KitchenColors.onSurface : KitchenColors.onSurfaceVariant))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _social(Widget icon, String label) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: KitchenColors.surfaceLowest,
          foregroundColor: KitchenColors.onSurface,
          side: BorderSide(color: KitchenColors.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: widget.onSignedIn,
        icon: icon,
        label: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _ChefCall extends StatelessWidget {
  _ChefCall();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: KitchenColors.secondaryContainer, borderRadius: BorderRadius.circular(99)),
      child: Text('JOLLOF25', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF005320))),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Text('G', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4285F4), fontSize: 18));
  }
}
