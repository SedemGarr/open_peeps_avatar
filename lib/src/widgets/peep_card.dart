import 'package:flutter/material.dart';
import 'package:open_peeps_avatar/src/avatar_look.dart';
import 'package:open_peeps_avatar/src/theme.dart';
import 'package:open_peeps_avatar/src/widgets/peep_figure.dart';
import 'package:open_peeps_avatar/src/widgets/peep_semantics.dart';

/// The full-body peep on a card, in its pose, with an optional caption.
class PeepCard extends StatelessWidget {
  /// The encoded [AvatarLook].
  final int avatar;
  final double width;
  final AvatarMood mood;
  final Widget? caption;

  /// What screen readers say for the peep. Without one it's decorative
  /// (the [caption] is still read).
  final String? semanticLabel;

  const PeepCard({
    super.key,
    required this.avatar,
    this.width = 180,
    this.mood = AvatarMood.neutral,
    this.caption,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = PeepTheme.of(context);
    final look = AvatarLook.decode(avatar);
    final pad = width * 0.06;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(pad, pad, pad, pad * 1.4),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.ink, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          peepSemantics(
            label: semanticLabel,
            child: PeepPortrait(
              look: look,
              seed: avatar,
              mood: mood,
              width: width,
            ),
          ),
          if (caption != null) ...[SizedBox(height: pad), caption!],
        ],
      ),
    );
  }
}

/// The full-body figure on its background and pattern, for card layouts.
class PeepPortrait extends StatelessWidget {
  final AvatarLook look;

  /// Picks the classic background; usually the avatar's code.
  final int seed;
  final AvatarMood mood;

  /// The card's width; sets the inner padding.
  final double width;

  const PeepPortrait({
    super.key,
    required this.look,
    required this.seed,
    required this.width,
    this.mood = AvatarMood.neutral,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CustomPaint(
          painter: AvatarPatternPainter(
            color: avatarBackground(context, look, seed),
            pattern: look.pattern,
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: FittedBox(
              child: PeepFigure(look: look, mood: mood, fullBody: true),
            ),
          ),
        ),
      ),
    );
  }
}
