import 'package:flutter/material.dart';
import 'package:foodiecall_admin/screens/analytics_screen.dart';
import 'package:foodiecall_admin/screens/compose_screens.dart';
import 'package:foodiecall_admin/screens/customers_screen.dart';
import 'package:foodiecall_admin/screens/dashboard_screen.dart';
import 'package:foodiecall_admin/screens/menu_screen.dart';
import 'package:foodiecall_admin/screens/orders_screen.dart';
import 'package:foodiecall_admin/screens/profile_screen.dart';
import 'package:foodiecall_admin/screens/promotions_screen.dart';
import 'package:foodiecall_admin/screens/settings_screen.dart';
import 'package:foodiecall_admin/screens/sign_in_screen.dart';
import 'package:foodiecall_admin/screens/welcome_flow.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/portal_shell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(FoodiecallAdminApp());
}

class FoodiecallAdminApp extends StatefulWidget {
  const FoodiecallAdminApp({super.key});

  @override
  State<FoodiecallAdminApp> createState() => _FoodiecallAdminAppState();
}

class _FoodiecallAdminAppState extends State<FoodiecallAdminApp> {
  final session = KitchenSession();
  late String stage;
  String location = '/dashboard';

  @override
  void initState() {
    super.initState();
    session.addListener(_onSession);
    // React landing owns marketing; this app starts at kitchen onboarding.
    stage = Uri.base.queryParameters['admin'] == '1' ? 'signin' : 'welcome';
  }

  @override
  void dispose() {
    session.removeListener(_onSession);
    session.dispose();
    super.dispose();
  }

  void _onSession() => setState(() {});

  void _openDashboard() {
    session.completeProvisioning();
    setState(() {
      stage = 'portal';
      location = '/dashboard';
    });
  }

  Future<void> _leaveToMarketing() async {
    session.signOut();
    final marketing = Uri.base.resolve('../');
    await launchUrl(marketing, webOnlyWindowName: '_self');
  }

  @override
  Widget build(BuildContext context) {
    KitchenColors.apply(session.darkMode);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();
    return AnimatedTheme(
      duration: Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      data: KitchenColors.material(textTheme),
      child: MaterialApp(
        title: 'Foodiecall Kitchen',
        debugShowCheckedModeBanner: false,
        theme: KitchenColors.material(textTheme),
        home: switch (stage) {
          'welcome' => WelcomeFlow(onFinished: () => setState(() => stage = 'signin')),
          'signin' => SignInScreen(onSignedIn: _openDashboard),
          _ => PortalShell(
              session: session,
              location: location,
              onNavigate: (route) => setState(() => location = route),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 420),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(location),
                  child: switch (location) {
                    '/orders' => OrdersScreen(session: session, onNewOrder: () => setState(() => location = '/phone-order')),
                    '/phone-order' => PhoneOrderScreen(session: session, onClose: () => setState(() => location = '/orders')),
                    '/menu' => MenuScreen(session: session, onAddDish: () => setState(() => location = '/new-dish')),
                    '/new-dish' => NewDishScreen(session: session, onClose: () => setState(() => location = '/menu')),
                    '/customers' => CustomersScreen(session: session),
                    '/promotions' => PromotionsScreen(session: session, onCreate: () => setState(() => location = '/new-promotion')),
                    '/new-promotion' => NewPromotionScreen(session: session, onClose: () => setState(() => location = '/promotions')),
                    '/reports' => AnalyticsScreen(session: session),
                    '/settings' => SettingsScreen(session: session),
                    '/profile' => ProfileScreen(
                        session: session,
                        onSignOut: _leaveToMarketing,
                      ),
                    _ => DashboardScreen(session: session, onNavigate: (route) => setState(() => location = route)),
                  },
                ),
              ),
            ),
        },
      ),
    );
  }
}
