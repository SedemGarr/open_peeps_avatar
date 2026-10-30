import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Takes pictures of a [PeepCapture], e.g. to share a result card with the
/// player's peep on it.
class PeepCaptureController {
  final GlobalKey _key = GlobalKey();

  RenderRepaintBoundary get _boundary {
    final object = _key.currentContext?.findRenderObject();

    if (object is! RenderRepaintBoundary) {
      throw StateError(
        'PeepCaptureController is not attached to a PeepCapture on screen',
      );
    }

    return object;
  }

  /// The capture as an image, at [pixelRatio] physical pixels per logical
  /// pixel. Call it once the peep has been shown: its SVGs load
  /// asynchronously, and a capture taken before they land is blank.
  Future<ui.Image> toImage({double pixelRatio = 3}) =>
      _boundary.toImage(pixelRatio: pixelRatio);

  /// The capture as PNG bytes, ready to save or share.
  Future<Uint8List> toPng({double pixelRatio = 3}) async {
    final image = await toImage(pixelRatio: pixelRatio);

    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }
}

/// Marks [child] for [controller] to capture. Anything can go inside: a
/// sticker, a card, or a whole share card with text around the peep.
class PeepCapture extends StatelessWidget {
  final PeepCaptureController controller;
  final Widget child;

  const PeepCapture({super.key, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(key: controller._key, child: child);
}
