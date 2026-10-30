import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:open_peeps_avatar/src/theme.dart';

/// Draws a solid outline around [child]'s silhouette, like a die-cut
/// sticker, so peeps drawn in dark ink stand out on dark backgrounds.
///
/// Works with any peep widget, e.g. a [PeepFigure] in a scene:
///
/// ```dart
/// PeepCutout(child: PeepFigure(look: look, fullBody: true))
/// ```
///
/// [child] is painted twice (once flattened into the outline), so prefer it
/// for a handful of figures rather than every row of a long list.
class PeepCutout extends StatelessWidget {
  final Widget child;

  /// The outline's colour; [PeepTheme.card] by default.
  final Color? color;

  /// The outline's thickness in logical pixels.
  final double width;

  const PeepCutout({
    super.key,
    required this.child,
    this.color,
    this.width = 4,
  });

  @override
  Widget build(BuildContext context) {
    final outline = color ?? PeepTheme.of(context).card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ExcludeSemantics(
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.dilate(radiusX: width, radiusY: width),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(outline, BlendMode.srcIn),
              child: child,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
