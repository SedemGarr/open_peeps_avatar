import 'package:flutter/widgets.dart';

/// Peeps are decorative unless they're given a [label]: then the whole
/// avatar reads as one image, instead of one unlabelled image per SVG part.
Widget peepSemantics({required String? label, required Widget child}) {
  if (label == null) {
    return ExcludeSemantics(child: child);
  }

  return Semantics(
    label: label,
    image: true,
    excludeSemantics: true,
    child: child,
  );
}
