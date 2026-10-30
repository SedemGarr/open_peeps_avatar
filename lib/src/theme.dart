import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_peeps_avatar/src/avatar_look.dart';

/// Colours and timing for avatar widgets. Add it to `ThemeData.extensions`
/// to match your game; without it, colours come from the [ColorScheme].
@immutable
class PeepTheme extends ThemeExtension<PeepTheme> {
  /// The sticker's die-cut edge and card backing.
  final Color card;

  /// Outlines, props and pattern ink.
  final Color ink;

  /// Selected tiles and prop fills.
  final Color highlight;

  /// Background options 1 to [AvatarLook.backgrounds] - 1 (0 is classic).
  final List<Color> backgrounds;

  /// Background option 0: a colour derived from the avatar's code.
  final Color Function(int seed)? classicBackground;

  final Duration animationDuration;

  const PeepTheme({
    required this.card,
    required this.ink,
    required this.highlight,
    required this.backgrounds,
    this.classicBackground,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : assert(backgrounds.length == AvatarLook.backgrounds - 1);

  /// Defaults built from [scheme].
  factory PeepTheme.fromColorScheme(ColorScheme scheme) => PeepTheme(
    card: scheme.surface,
    ink: scheme.onSurface,
    highlight: scheme.primaryContainer,
    backgrounds: [
      scheme.primaryContainer,
      scheme.secondaryContainer,
      scheme.tertiaryContainer,
      Color.alphaBlend(scheme.primary.withValues(alpha: 0.55), scheme.surface),
      scheme.surface,
    ],
  );

  static PeepTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<PeepTheme>() ??
        PeepTheme.fromColorScheme(theme.colorScheme);
  }

  /// The colour for background option [index]; [seed] picks the classic one.
  Color background(int index, int seed) {
    if (index >= 1 && index <= backgrounds.length) {
      return backgrounds[index - 1];
    }
    return classicBackground?.call(seed) ??
        Color.alphaBlend(colorFromSeed(seed).withValues(alpha: 0.55), card);
  }

  /// A vivid colour from an integer seed.
  static Color colorFromSeed(int seed) {
    final random = Random(seed);
    final hue = random.nextDouble() * 360;
    final saturation = 0.75 + random.nextDouble() * 0.20;
    final lightness = 0.50 + random.nextDouble() * 0.15;
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  static const Color _darkInk = Color(0xFF1A1A1A);
  static const Color _lightInk = Color(0xFFFFFBF2);

  /// Whichever ink contrasts more with [background].
  static Color inkOn(Color background) {
    final l = background.computeLuminance();
    final onDark = (_lightInk.computeLuminance() + 0.05) / (l + 0.05);
    final onLight = (l + 0.05) / (_darkInk.computeLuminance() + 0.05);
    return onDark >= onLight ? _lightInk : _darkInk;
  }

  @override
  PeepTheme copyWith({
    Color? card,
    Color? ink,
    Color? highlight,
    List<Color>? backgrounds,
    Color Function(int seed)? classicBackground,
    Duration? animationDuration,
  }) => PeepTheme(
    card: card ?? this.card,
    ink: ink ?? this.ink,
    highlight: highlight ?? this.highlight,
    backgrounds: backgrounds ?? this.backgrounds,
    classicBackground: classicBackground ?? this.classicBackground,
    animationDuration: animationDuration ?? this.animationDuration,
  );

  @override
  PeepTheme lerp(PeepTheme? other, double t) {
    if (other == null) return this;
    return PeepTheme(
      card: Color.lerp(card, other.card, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      backgrounds: [
        for (var i = 0; i < backgrounds.length; i++)
          Color.lerp(backgrounds[i], other.backgrounds[i], t)!,
      ],
      classicBackground: t < 0.5 ? classicBackground : other.classicBackground,
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
    );
  }
}

/// The background a look sits on. [seed] is usually the avatar's code.
Color avatarBackground(BuildContext context, AvatarLook look, int seed) =>
    PeepTheme.of(context).background(look.background, seed);

/// Background colour with an optional printed pattern, in faint ink.
class AvatarPatternPainter extends CustomPainter {
  final Color color;
  final int pattern;

  AvatarPatternPainter({required this.color, required this.pattern});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
    final p = Paint()
      ..color = PeepTheme.inkOn(color).withValues(alpha: 0.14)
      ..strokeWidth = max(1, size.width * 0.015)
      ..strokeCap = StrokeCap.round;
    final gap = max(5.0, size.width / 9);
    switch (pattern) {
      case 1:
        for (double y = gap / 2; y < size.height; y += gap) {
          for (double x = gap / 2; x < size.width; x += gap) {
            canvas.drawCircle(Offset(x, y), p.strokeWidth * 1.1, p);
          }
        }
      case 2:
        for (double v = 0; v < size.width + size.height; v += gap) {
          canvas.drawLine(Offset(v, 0), Offset(v, size.height), p);
          canvas.drawLine(Offset(0, v), Offset(size.width, v), p);
        }
      case 3:
        p.strokeWidth *= 2.2;
        for (double v = -size.height; v < size.width; v += gap * 1.4) {
          canvas.drawLine(
            Offset(v, size.height),
            Offset(v + size.height, 0),
            p,
          );
        }
    }
  }

  @override
  bool shouldRepaint(AvatarPatternPainter old) =>
      old.color != color || old.pattern != pattern;
}
