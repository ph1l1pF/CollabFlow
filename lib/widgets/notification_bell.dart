import 'package:flutter/material.dart';
import 'package:ugcworks/constants/app_colors.dart';

/// A reusable notification bell widget that displays a bell icon
/// with optional strike-through when notifications are disabled.
/// 
/// Usage:
/// ```dart
/// NotificationBell(
///   hasNotifications: true,  // Shows active bell
///   size: 20.0,             // Optional size (default: 16.0)
///   activeColor: Colors.blue, // Optional active color
///   inactiveColor: Colors.grey, // Optional inactive color
/// )
/// ```
class NotificationBell extends StatelessWidget {
  final bool hasNotifications;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const NotificationBell({
    super.key,
    required this.hasNotifications,
    this.size = 16.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final bellColor = hasNotifications 
        ? (activeColor ?? AppColors.primaryPink)
        : (inactiveColor ?? Colors.grey);

    return Stack(
      children: [
        Icon(
          Icons.notifications,
          color: bellColor,
          size: size,
        ),
        if (!hasNotifications)
          Positioned.fill(
            child: CustomPaint(
              painter: StrikeThroughPainter(),
            ),
          ),
      ],
    );
  }
}

/// Custom painter that draws a diagonal strike-through line
/// across the notification bell when notifications are disabled.
class StrikeThroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw diagonal line from top-left to bottom-right
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
