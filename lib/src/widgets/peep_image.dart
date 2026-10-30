import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_peeps_avatar/src/models/peep_atom.dart';

/// Package the peep SVGs ship in.
const String peepsPackage = 'open_peeps_avatar';

/// A [PeepImage] represents one [PeepAtom] of a [Peep].
/// [PeepImage] uses [SvgPicture] to be scalable to any size.
class PeepImage extends StatelessWidget {
  const PeepImage({
    super.key,
    required this.peepAtom,
    required this.size,
    this.color,
    this.colors,
  });

  final Color? color;

  /// Recolours the art's white fill and black ink (see [PeepColors]).
  final PeepColors? colors;

  /// The atom which will be rendered
  final PeepAtom peepAtom;

  /// The size of the [PeepImage].
  final double size;

  /// The size of the largest atom base file
  /// Used to scale smaller atoms relative to the most dominant [PeepAtom].
  static const double _maxWidth = 473;
  static const double _maxHeight = 567;

  @override
  Widget build(BuildContext context) {
    if (peepAtom.name.toLowerCase().contains('none')) {
      return const SizedBox.shrink();
    }

    return SvgPicture(
      SvgAssetLoader(
        'assets/peeps/${peepAtom.directoryName}/${peepAtom.name}.svg',
        packageName: peepsPackage,
        colorMapper: colors,
      ),
      width: peepAtom.imageWidth / _maxWidth * size,
      height: peepAtom.imageHeight / _maxHeight * size,
      allowDrawingOutsideViewBox: true,
      clipBehavior: Clip.none,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

/// Swaps the two colours Open Peeps art uses: white fill (skin, or skin and
/// clothes on bodies) and black ink (lines and hair). Immutable with value
/// equality, so parsed pictures are cached per colour combination.
@immutable
class PeepColors extends ColorMapper {
  final Color? fill;
  final Color? ink;

  const PeepColors({this.fill, this.ink});

  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    // Near-black/near-white too: a few files use e.g. #221e1f instead of
    // pure black, which an exact match skipped (they stayed black).
    final l = color.computeLuminance();
    if (fill != null && (color == _white || l > 0.9)) return fill!;
    if (ink != null && (color == _black || l < 0.02)) return ink!;
    return color;
  }

  @override
  bool operator ==(Object other) =>
      other is PeepColors && other.fill == fill && other.ink == ink;

  @override
  int get hashCode => Object.hash(fill, ink);
}
