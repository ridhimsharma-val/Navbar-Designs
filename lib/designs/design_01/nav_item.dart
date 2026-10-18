import 'package:flutter/material.dart';

/// Data model representing a navigation item specifically for Design 01:
/// Minimal Circle Bottom Navigation Bar.
///
/// Encapsulates the label, inactive icon, active icon, and optional accessibility tooltip.
@immutable
class Design01NavItem {
  /// The text label displayed underneath the icon (12 px, single-line).
  final String label;

  /// Icon displayed in the inactive (unselected) state.
  final IconData inactiveIcon;

  /// Icon displayed in the active (selected) state.
  final IconData activeIcon;

  /// Optional accessibility tooltip or semantic label.
  /// Defaults to [label] if not provided.
  final String? tooltip;

  /// Optional custom builder for the active icon widget, allowing specialized
  /// bold/filled vector glyphs where standard Material fonts only offer thin outlines.
  final Widget Function(BuildContext context, Color color, double size)?
      activeWidgetBuilder;

  const Design01NavItem({
    required this.label,
    required this.inactiveIcon,
    required this.activeIcon,
    this.tooltip,
    this.activeWidgetBuilder,
  });

  /// Builds the active widget, using [activeWidgetBuilder] if provided,
  /// or defaulting to a standard [Icon] using [activeIcon].
  Widget buildActiveWidget(
    BuildContext context, {
    required Color color,
    required double size,
    Key? key,
  }) {
    if (activeWidgetBuilder != null) {
      return KeyedSubtree(
        key: key,
        child: activeWidgetBuilder!(context, color, size),
      );
    }
    return Icon(
      activeIcon,
      key: key,
      size: size,
      color: color,
    );
  }

  static Widget _buildBoldSearchIcon(
    BuildContext context,
    Color color,
    double size,
  ) {
    return BoldSearchIcon(size: size, color: color);
  }

  /// The standard 4 navigation items specified for Design 01:
  /// 1. Home (Outline house -> Filled house)
  /// 2. Search (Outline magnifying glass -> Bold filled magnifying glass)
  /// 3. History (Outline clock -> Filled clock)
  /// 4. Profile (Outline person -> Filled person)
  static const List<Design01NavItem> defaultItems = [
    Design01NavItem(
      label: 'Home',
      inactiveIcon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    Design01NavItem(
      label: 'Search',
      inactiveIcon: Icons.search_rounded,
      activeIcon: Icons.search,
      activeWidgetBuilder: _buildBoldSearchIcon,
    ),
    Design01NavItem(
      label: 'History',
      inactiveIcon: Icons.access_time_rounded,
      activeIcon: Icons.watch_later_rounded,
    ),
    Design01NavItem(
      label: 'Profile',
      inactiveIcon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Design01NavItem &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          inactiveIcon == other.inactiveIcon &&
          activeIcon == other.activeIcon &&
          tooltip == other.tooltip;

  @override
  int get hashCode =>
      label.hashCode ^
      inactiveIcon.hashCode ^
      activeIcon.hashCode ^
      tooltip.hashCode;
}

/// Custom-drawn bold search icon widget for Design 01.
///
/// Magnifies the stroke weight from Material's thin outline (~1.8px) to a
/// prominent, solid 3.3px stroke, matching the visual weight of adjacent
/// filled icons (Home, History, Profile) inside the 24x24 logical box.
class BoldSearchIcon extends StatelessWidget {
  final double size;
  final Color color;

  const BoldSearchIcon({
    super.key,
    this.size = 24.0,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _BoldSearchIconPainter(color: color),
      ),
    );
  }
}

class _BoldSearchIconPainter extends CustomPainter {
  final Color color;

  const _BoldSearchIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Bold Circular Lens
    const center = Offset(9.8, 9.8);
    const radius = 5.6;
    canvas.drawCircle(center, radius, paint);

    // Bold Diagonal Handle
    const handleStart = Offset(13.8, 13.8);
    const handleEnd = Offset(19.2, 19.2);
    canvas.drawLine(handleStart, handleEnd, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BoldSearchIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
