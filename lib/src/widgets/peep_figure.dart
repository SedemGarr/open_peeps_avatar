import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_peeps_avatar/src/avatar_look.dart';
import 'package:open_peeps_avatar/src/models/peep_atom.dart';
import 'package:open_peeps_avatar/src/atoms/anchors.dart';
import 'package:open_peeps_avatar/src/widgets/peep_image.dart';
import 'package:open_peeps_avatar/src/widgets/peep_semantics.dart';

/// A whole peep: the player's head placed on a body.
///
/// [fullBody] uses the look's pose (head to toe); otherwise the bust outfit
/// (head and shoulders). The head is positioned by matching the head canvas's
/// chin point to the body's neck stump (see [PeepAnchors]), with the body
/// drawn underneath so its neck tucks behind the face.
///
/// Laid out at a fixed base scale; wrap in a [FittedBox] to size it.
class PeepFigure extends StatelessWidget {
  final AvatarLook look;
  final AvatarMood mood;
  final bool fullBody;

  /// What screen readers say. Without one the figure is decorative.
  final String? semanticLabel;

  const PeepFigure({
    super.key,
    required this.look,
    this.mood = AvatarMood.neutral,
    this.fullBody = false,
    this.semanticLabel,
  });

  /// Head assembly size at the base scale.
  static const double _s = 64;

  /// SVG units → pixels for every part (matches the head assembly).
  static const double _k = _s * 0.75 / 567;

  /// How far below the neck stump's top the chin sits, in SVG units. The
  /// stumps run well above the body canvas, so this hides most of the neck
  /// behind the face (55 left a long, visible neck).
  static const double _neckTuck = 145;

  /// Moves the head along the body, in SVG units: negative = head further
  /// right. (It offsets the point the body's neck is matched to, so it
  /// moves the body; the head moves the opposite way relative to it.)
  static const double _neckShiftX = -40;

  /// Full-body poses read better with a slightly larger head.
  static const double _poseHeadScale = 1.32;

  /// Extra shift on full-body poses (same sign rule as [_neckShiftX]).
  static const double _poseShiftX = -20;

  @override
  Widget build(BuildContext context) {
    final fill = PeepColors(fill: look.skinColor, ink: look.inkColor);
    final inkOnly = PeepColors(ink: look.inkColor);

    final PeepAtom bodyAtom;
    final Offset neck;
    if (fullBody) {
      final entry = look.poseEntry;
      bodyAtom = entry.atom;
      neck = entry.neck;
    } else {
      bodyAtom = look.outfitAtom;
      neck = PeepAnchors.bodyNeck[bodyAtom.name] ?? const Offset(450, -40);
    }

    // Head assembly: the same layout PeepAvatar uses (r = s/64), whose head
    // canvas origin lands at (5r + 47k, 2r).
    final hs = fullBody ? _poseHeadScale : 1.0;
    final headSize = _s * hs;
    final headK = _k * hs;
    final r = headSize / 64;
    final headOrigin = Offset(5 * r + 47 * headK, 2 * r);
    final chin =
        headOrigin +
        PeepAnchors.headChin * headK +
        Offset((_neckShiftX + (fullBody ? _poseShiftX : 0)) * _k, 0);

    final bodyW = bodyAtom.imageWidth * _k;
    final bodyH = bodyAtom.imageHeight * _k;
    final body = chin - Offset(neck.dx, neck.dy + _neckTuck) * _k;

    final left = body.dx < 0 ? body.dx : 0.0;
    final top = body.dy < 0 ? body.dy : 0.0;
    final right = (body.dx + bodyW) > headSize ? body.dx + bodyW : headSize;
    final bottom = (body.dy + bodyH) > headSize ? body.dy + bodyH : headSize;

    return peepSemantics(
      label: semanticLabel,
      child: SizedBox(
        width: right - left,
        height: bottom - top,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: body.dx - left,
              top: body.dy - top,
              child: SvgPicture(
                SvgAssetLoader(
                  'assets/peeps/${bodyAtom.directoryName}/${bodyAtom.name}.svg',
                  packageName: peepsPackage,
                  colorMapper: fill,
                ),
                width: bodyW,
                height: bodyH,
                allowDrawingOutsideViewBox: true,
                clipBehavior: Clip.none,
              ),
            ),
            Positioned(
              left: -left,
              top: -top,
              child: PeepHead(
                look: look,
                mood: mood,
                size: headSize,
                skin: fill,
                ink: inkOnly,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Head, face, facial hair and accessory, laid out like [PeepAvatar].
class PeepHead extends StatelessWidget {
  final AvatarLook look;
  final AvatarMood mood;
  final double size;
  final PeepColors skin;
  final PeepColors ink;

  const PeepHead({
    super.key,
    required this.look,
    required this.mood,
    required this.size,
    required this.skin,
    required this.ink,
  });

  @override
  Widget build(BuildContext context) {
    final r = size / 64;
    final part = size * 0.75;
    final peep = look.peep;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 5 * r,
            top: 2 * r,
            child: PeepImage(peepAtom: peep.head, size: part, colors: skin),
          ),
          Positioned(
            left: 18.5 * r,
            top: 17.75 * r,
            child: PeepImage(
              peepAtom: look.faceFor(mood),
              size: part,
              colors: ink,
            ),
          ),
          Positioned(
            left: 15.25 * r,
            top: 30.5 * r,
            child: PeepImage(
              peepAtom: peep.facialHair,
              size: part,
              colors: ink,
            ),
          ),
          Positioned(
            left: 9 * r,
            top: 22.5 * r,
            child: PeepImage(peepAtom: peep.accessory, size: part, colors: ink),
          ),
        ],
      ),
    );
  }
}
