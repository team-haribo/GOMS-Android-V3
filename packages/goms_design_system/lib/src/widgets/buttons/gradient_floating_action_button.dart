import 'package:flutter/material.dart';

class GradientFloatingActionButton extends StatelessWidget {
  const GradientFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.baseColor,
    this.size = 64,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color baseColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final gradientColors = _buildGradient(baseColor);

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.14),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: baseColor.withValues(alpha: 0.46),
              blurRadius: 26,
              spreadRadius: 1.5,
            ),
            BoxShadow(
              color: baseColor.withValues(alpha: 0.24),
              blurRadius: 46,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  static List<Color> _buildGradient(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    final lighter =
        hsl.withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0)).toColor();
    final darker =
        hsl.withLightness((hsl.lightness - 0.04).clamp(0.0, 1.0)).toColor();

    return [lighter, darker];
  }
}
