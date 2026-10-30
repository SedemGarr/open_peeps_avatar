class PeepAtom {
  final String name;
  final String directoryName;
  final double imageHeight;
  final double imageWidth;

  const PeepAtom({
    required this.name,
    required this.directoryName,
    required this.imageHeight,
    required this.imageWidth,
  });

  /// Creates a [PeepAtom] instance from a json object.
  factory PeepAtom.fromJson(Map<String, dynamic> json) => PeepAtom(
    name: json['name'] as String,
    directoryName: json['directoryName'] as String,
    imageHeight: (json['imageHeight'] as num).toDouble(),
    imageWidth: (json['imageWidth'] as num).toDouble(),
  );

  /// Converts the instance to a json object.
  Map<String, dynamic> toJson() => {
    'name': name,
    'directoryName': directoryName,
    'imageHeight': imageHeight,
    'imageWidth': imageWidth,
  };

  /// Returns a copy of this instance with the given fields replaced.
  PeepAtom copyWith({
    String? name,
    String? directoryName,
    double? imageHeight,
    double? imageWidth,
  }) => PeepAtom(
    name: name ?? this.name,
    directoryName: directoryName ?? this.directoryName,
    imageHeight: imageHeight ?? this.imageHeight,
    imageWidth: imageWidth ?? this.imageWidth,
  );

  /// Converts the instance to code.
  String toCodeInstance() {
    return """
PeepAtom(
  name: '$name',
  directoryName: '$directoryName',
  imageHeight: $imageHeight,
  imageWidth: $imageWidth,
)""";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeepAtom &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          directoryName == other.directoryName &&
          imageHeight == other.imageHeight &&
          imageWidth == other.imageWidth;

  @override
  int get hashCode => Object.hash(name, directoryName, imageHeight, imageWidth);

  @override
  String toString() =>
      'PeepAtom(name: $name, directoryName: $directoryName, '
      'imageHeight: $imageHeight, imageWidth: $imageWidth)';
}
