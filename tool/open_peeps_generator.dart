import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:open_peeps_avatar/src/models/peep_atom.dart';

enum ImageInformation { width, height }

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class Generator {
  static const String pathToPackage = '../open_peeps';

  String get pathToAssets => path.join(pathToPackage, 'assets');
  String get pathToAtoms => path.join(pathToAssets, 'atoms');
  String get pathToPackageAtoms =>
      path.join(pathToPackage, 'lib', 'src', 'atoms');

  double _getImageInformation({
    required String content,
    required ImageInformation information,
  }) {
    final regex = switch (information) {
      ImageInformation.width => RegExp(r'(?<=width=")\d+(?!=px)'),
      ImageInformation.height => RegExp(r'(?<=height=")\d+(?!=px)'),
    };
    return double.parse(regex.stringMatch(content)!);
  }

  Iterable<PeepAtom> _getPeepAtomsFromDirectory({
    required Directory directory,
  }) sync* {
    final files = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.svg'));

    for (final file in files) {
      final name = path.basenameWithoutExtension(file.path);
      final content = file.readAsStringSync();

      yield PeepAtom(
        name: name,
        directoryName: path.basename(directory.path),
        imageWidth: _getImageInformation(
          content: content,
          information: ImageInformation.width,
        ),
        imageHeight: _getImageInformation(
          content: content,
          information: ImageInformation.height,
        ),
      );
    }
  }

  String _getAtomTypeClassName({required String directoryName}) =>
      directoryName.split('-').map((e) => e.toLowerCase().capitalize()).join();

  void _generateFileFromAtoms({
    required Iterable<PeepAtom> atoms,
    required Directory directory,
  }) {
    final list = atoms.toList()..sort((a, b) => a.name.compareTo(b.name));

    final directoryName = path.basename(directory.path);
    final className = _getAtomTypeClassName(directoryName: directoryName);
    final filePath = path.join(
      pathToPackageAtoms,
      '${directoryName.toLowerCase().replaceAll('-', '_')}.dart',
    );

    final atomInstances = list.map((e) => e.toCodeInstance()).join(',\n  ');

    final content =
        '''
import 'package:open_peeps_avatar/src/models/peep_atom.dart';

class $className {
  static List<PeepAtom> atoms = [
  $atomInstances,
  ];

  static Map<int, PeepAtom> atomsMap() =>
      {for (var e in atoms) e.hashCode: e};
}
''';

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsStringSync(content);
  }

  Future<void> generate() async {
    final atomsDirectory = Directory(pathToAtoms);
    final directories = atomsDirectory.listSync().whereType<Directory>();

    for (final directory in directories) {
      final atoms = _getPeepAtomsFromDirectory(directory: directory);
      _generateFileFromAtoms(atoms: atoms, directory: directory);
    }
  }
}
