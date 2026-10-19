import 'package:flutter/material.dart';
import 'package:foodiecall_admin/theme/kitchen_colors.dart';

class KCard extends StatefulWidget {
  KCard({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  final Widget child;
  final EdgeInsets padding;

  @override
  State<KCard> createState() => _KCardState();
}

class _KCardState extends State<KCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: widget.padding,
        transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: KitchenColors.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: hovered ? KitchenColors.outlineVariant : Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Color(hovered ? 0x1A1C1917 : 0x0D1C1917),
              blurRadius: hovered ? 22 : 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

class KPill extends StatelessWidget {
  KPill({super.key, required this.label, this.fg, this.bg});

  final String label;
  final Color? fg;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg ?? KitchenColors.surfaceHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: fg ?? KitchenColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  SectionTitle({super.key, required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: KitchenColors.primary, size: 22),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.18, color: KitchenColors.onSurface),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  PrimaryButton({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: KitchenColors.primary,
        foregroundColor: KitchenColors.onPrimary,
        minimumSize: Size(0, 52),
        padding: EdgeInsets.symmetric(horizontal: 28),
        shape: StadiumBorder(),
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (icon != null) ...[SizedBox(width: 8), Icon(icon, size: 18)],
        ],
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  GhostButton({super.key, required this.label, required this.onPressed, this.icon, this.foreground});

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? KitchenColors.onSurface;
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: color,
        backgroundColor: KitchenColors.surfaceContainer,
        minimumSize: Size(0, 48),
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: StadiumBorder(),
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), SizedBox(width: 6)],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
