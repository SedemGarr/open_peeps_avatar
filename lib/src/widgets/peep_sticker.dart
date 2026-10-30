import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:open_peeps_avatar/src/avatar_look.dart';
import 'package:open_peeps_avatar/src/theme.dart';
import 'package:open_peeps_avatar/src/widgets/peep_figure.dart';

/// A player's avatar as a round sticker: head and shoulders in their outfit,
/// on their chosen background colour and pattern.
///
/// [animate] makes it blink now and then. [mood] swaps in an expression;
/// [prop] adds a code-drawn crown or sparkle.
class PeepSticker extends StatelessWidget {
  /// The encoded [AvatarLook].
  final int avatar;
  final double size;
  final bool animate;
  final AvatarMood mood;
  final AvatarProp prop;

  const PeepSticker({
    super.key,
    required this.avatar,
    this.size = 64,
    this.animate = false,
    this.mood = AvatarMood.neutral,
    this.prop = AvatarProp.none,
  });

  @override
  Widget build(BuildContext context) {
    final look = AvatarLook.decode(avatar);
    final theme = PeepTheme.of(context);
    Widget sticker(AvatarMood mood) => Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(math.max(2, size * 0.05)),
      decoration: BoxDecoration(
        color: theme.card,
        shape: BoxShape.circle,
        border: Border.all(color: theme.ink, width: size < 40 ? 1.4 : 2),
      ),
      child: ClipOval(
        child: CustomPaint(
          painter: AvatarPatternPainter(
            color: avatarBackground(context, look, avatar),
            pattern: look.pattern,
          ),
          child: PeepBust(look: look, mood: mood),
        ),
      ),
    );

    final child = animate
        ? PeepBlink(mood: mood, builder: (context, mood) => sticker(mood))
        : sticker(mood);
    return PeepPropFrame(prop: prop, size: size, child: child);
  }
}

/// Head and shoulders, filling and cropped to its box.
class PeepBust extends StatelessWidget {
  final AvatarLook look;
  final AvatarMood mood;

  const PeepBust({
    super.key,
    required this.look,
    this.mood = AvatarMood.neutral,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      // Show the top of the figure only.
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.74,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: PeepFigure(look: look, mood: mood),
        ),
      ),
    );
  }
}

/// Rebuilds with [AvatarMood.blink] every few seconds while [mood] is
/// neutral. Pauses with tickers and when animations are disabled.
class PeepBlink extends StatefulWidget {
  final AvatarMood mood;
  final Widget Function(BuildContext context, AvatarMood mood) builder;

  const PeepBlink({super.key, required this.mood, required this.builder});

  @override
  State<PeepBlink> createState() => _PeepBlinkState();
}

class _PeepBlinkState extends State<PeepBlink> {
  static final math.Random _rng = math.Random();
  Timer? _timer;
  bool _blinking = false;

  @override
  void initState() {
    super.initState();
    _scheduleBlink();
  }

  void _scheduleBlink() {
    _timer = Timer(Duration(milliseconds: 2400 + _rng.nextInt(3600)), () {
      if (!mounted) return;
      if (TickerMode.valuesOf(context).enabled &&
          !(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
        setState(() => _blinking = true);
        _timer = Timer(const Duration(milliseconds: 150), () {
          if (!mounted) return;
          setState(() => _blinking = false);
          _scheduleBlink();
        });
      } else {
        _scheduleBlink();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mood = _blinking && widget.mood == AvatarMood.neutral
        ? AvatarMood.blink
        : widget.mood;
    return widget.builder(context, mood);
  }
}

/// Places [prop] over a [size] square [child]: a crown on top or a sparkle
/// at the corner.
class PeepPropFrame extends StatelessWidget {
  final AvatarProp prop;
  final double size;
  final Widget child;

  const PeepPropFrame({
    super.key,
    required this.prop,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (prop == AvatarProp.none) return child;
    final d = size;
    return SizedBox.square(
      dimension: d,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            left: prop == AvatarProp.crown ? d * 0.22 : null,
            right: prop == AvatarProp.sparkle ? -d * 0.08 : null,
            top: prop == AvatarProp.crown ? -d * 0.36 : -d * 0.08,
            child: PeepProp(prop: prop, size: d),
          ),
        ],
      ),
    );
  }
}

/// A code-drawn crown or sparkle, sized for an avatar of [size].
class PeepProp extends StatelessWidget {
  final AvatarProp prop;
  final double size;

  const PeepProp({super.key, required this.prop, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = PeepTheme.of(context);
    final w = prop == AvatarProp.crown ? size * 0.56 : size * 0.34;
    return Transform.rotate(
      angle: prop == AvatarProp.crown ? -0.12 : 0.2,
      child: CustomPaint(
        size: Size(w, prop == AvatarProp.crown ? w * 0.62 : w),
        painter: _PropPainter(prop, fill: theme.highlight, ink: theme.ink),
      ),
    );
  }
}

class _PropPainter extends CustomPainter {
  final AvatarProp prop;
  final Color fill;
  final Color ink;

  _PropPainter(this.prop, {required this.fill, required this.ink});

  @override
  void paint(Canvas canvas, Size s) {
    final path = Path();
    if (prop == AvatarProp.crown) {
      path
        ..moveTo(s.width * 0.05, s.height * 0.95)
        ..lineTo(s.width * 0.02, s.height * 0.25)
        ..lineTo(s.width * 0.28, s.height * 0.55)
        ..lineTo(s.width * 0.5, s.height * 0.05)
        ..lineTo(s.width * 0.72, s.height * 0.55)
        ..lineTo(s.width * 0.98, s.height * 0.25)
        ..lineTo(s.width * 0.95, s.height * 0.95)
        ..close();
    } else {
      final c = s.center(Offset.zero);
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4 - math.pi / 2;
        final r = i.isEven ? s.width / 2 : s.width * 0.14;
        final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
    }
    final stroke = math.max(1.2, s.width * 0.06);
    canvas.drawPath(path.shift(Offset(stroke, stroke)), Paint()..color = ink);
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeJoin = StrokeJoin.round,
    );
    if (prop == AvatarProp.crown) {
      final dot = Paint()..color = ink;
      for (final x in [0.28, 0.5, 0.72]) {
        canvas.drawCircle(Offset(s.width * x, s.height * 0.78), stroke, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_PropPainter old) =>
      old.prop != prop || old.fill != fill || old.ink != ink;
}
