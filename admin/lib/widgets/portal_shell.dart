import 'package:flutter/material.dart';
import 'package:foodiecall_admin/state/kitchen_session.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';
import 'package:foodiecall_admin/widgets/notifications_sheet.dart';

class PortalDestination {
  PortalDestination(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}

bool _matches(String location, String route) {
  if (location == route) return true;
  if (route == '/orders' && location == '/phone-order') return true;
  if (route == '/menu' && location == '/new-dish') return true;
  if (route == '/promotions' && location == '/new-promotion') return true;
  return false;
}

final portalDestinations = [
  PortalDestination('Dashboard', Icons.dashboard_outlined, '/dashboard'),
  PortalDestination('Orders', Icons.delivery_dining_outlined, '/orders'),
  PortalDestination('Menu Management', Icons.restaurant_menu_outlined, '/menu'),
  PortalDestination('Customers', Icons.people_outline, '/customers'),
  PortalDestination('Promotions', Icons.sell_outlined, '/promotions'),
  PortalDestination('Reports', Icons.query_stats_outlined, '/reports'),
  PortalDestination('Settings', Icons.tune, '/settings'),
];

class PortalShell extends StatelessWidget {
  PortalShell({
    super.key,
    required this.session,
    required this.location,
    required this.onNavigate,
    required this.child,
  });

  final KitchenSession session;
  final String location;
  final ValueChanged<String> onNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KitchenColors.surface,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 960;
              return Row(
                children: [
                  if (wide) _Sidebar(location: location, onNavigate: onNavigate),
                  Expanded(
                    child: Column(
                      children: [
                        _TopBar(session: session, onNavigate: onNavigate, showMenu: !wide),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          if (session.notificationsOpen)
            Positioned.fill(
              child: NotificationsSheet(
                onClose: session.closeNotifications,
                onOpenTicket: () {
                  session.closeNotifications();
                  onNavigate('/orders');
                },
              ),
            ),
          if (session.toast != null)
            Positioned(
              right: 24,
              bottom: 24,
              child: Material(
                color: KitchenColors.inverseSurface,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: KitchenColors.secondaryContainer, size: 20),
                      SizedBox(width: 10),
                      Text(session.toast!, style: TextStyle(color: KitchenColors.inverseOnSurface, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  _Sidebar({required this.location, required this.onNavigate});

  final String location;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 268,
      color: KitchenColors.surfaceLowest,
      padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: KitchenColors.primary, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.restaurant, color: Colors.white, size: 20),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Foodiecall', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1)),
                  Text('KITCHEN PORTAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: KitchenColors.primary)),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: KitchenColors.surfaceContainer, borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LiveDot(),
                SizedBox(width: 6),
                Text('Victoria Island • Live', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: KitchenColors.secondary)),
              ],
            ),
          ),
          SizedBox(height: 20),
          for (final dest in portalDestinations)
            _NavItem(
              dest: dest,
              active: _matches(location, dest.route),
              onTap: () => onNavigate(dest.route),
            ),
          Spacer(),
          InkWell(
            onTap: () => onNavigate('/orders'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: KitchenColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(Icons.monitor, color: KitchenColors.primary, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kitchen Display', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('Terminal #4 active', style: TextStyle(fontSize: 12, color: KitchenColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.storefront_outlined, size: 18, color: KitchenColors.onSurfaceVariant),
              SizedBox(width: 8),
              Expanded(child: Text('Victoria Island Kitchen · Lagos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              Icon(Icons.expand_more, size: 18, color: KitchenColors.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: KitchenColors.secondary, shape: BoxShape.circle),
    );
  }
}

class _NavItem extends StatelessWidget {
  _NavItem({required this.dest, required this.active, required this.onTap});

  final PortalDestination dest;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Material(
        color: active ? KitchenColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(dest.icon, size: 20, color: active ? KitchenColors.onPrimary : KitchenColors.onSurfaceVariant),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    dest.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: active ? KitchenColors.onPrimary : KitchenColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  _TopBar({required this.session, required this.onNavigate, this.showMenu = false});

  final KitchenSession session;
  final ValueChanged<String> onNavigate;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 24),
      color: KitchenColors.surface,
      child: Row(
        children: [
          if (showMenu)
            PopupMenuButton<String>(
              icon: Icon(Icons.menu),
              onSelected: onNavigate,
              itemBuilder: (context) => [
                for (final dest in portalDestinations) PopupMenuItem(value: dest.route, child: Text(dest.label)),
              ],
            ),
          Expanded(
            child: Container(
              height: 44,
              constraints: BoxConstraints(maxWidth: 460),
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: KitchenColors.surfaceContainer, borderRadius: BorderRadius.circular(999)),
              child: Row(
                children: [
                  Icon(Icons.search, size: 18, color: KitchenColors.onSurfaceVariant),
                  SizedBox(width: 8),
                  Expanded(child: Text('Search tickets, dishes, couriers...', style: TextStyle(color: KitchenColors.onSurfaceVariant, fontSize: 14))),
                  Text('⌘K', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: KitchenColors.onSurfaceVariant)),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: session.toggleAccepting,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: session.acceptingOrders ? Color(0x1A006E2D) : KitchenColors.errorContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: session.acceptingOrders ? KitchenColors.secondary : KitchenColors.error),
                  SizedBox(width: 6),
                  Text(
                    session.acceptingOrders ? 'Accepting Orders' : 'Inflow Paused',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: session.acceptingOrders ? KitchenColors.secondary : KitchenColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: session.darkMode ? 'Light mode' : 'Dark mode',
            onPressed: session.toggleTheme,
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 280),
              transitionBuilder: (child, animation) => RotationTransition(turns: animation, child: FadeTransition(opacity: animation, child: child)),
              child: Icon(session.darkMode ? Icons.light_mode : Icons.dark_mode, key: ValueKey(session.darkMode)),
            ),
            color: KitchenColors.onSurface,
          ),
          IconButton(
            onPressed: session.toggleNotifications,
            icon: Icon(Icons.notifications_none),
            color: KitchenColors.onSurface,
          ),
          InkWell(
            onTap: () => onNavigate('/profile'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: KitchenColors.primaryFixed,
                    child: Text('AA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: KitchenColors.primary)),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Chef Amaka', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      Text('Executive Chef', style: TextStyle(fontSize: 11, color: KitchenColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
