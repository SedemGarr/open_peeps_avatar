import 'package:open_peeps_avatar/src/models/peep_atom.dart';

class Accessories {
  static List<PeepAtom> atoms = [
    const PeepAtom(
      name: '* None',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Eyepatch',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Glasses',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Glasses 2',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Glasses 3',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Glasses 4',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Glasses 5',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Sunglasses',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
    const PeepAtom(
      name: 'Sunglasses 2',
      directoryName: 'accessories',
      imageHeight: 138.0,
      imageWidth: 392.0,
    ),
  ];

  static Map<int, PeepAtom> atomsMap() => {for (var e in atoms) e.hashCode: e};
}
