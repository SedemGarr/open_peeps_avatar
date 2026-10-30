import 'package:open_peeps_avatar/src/models/peep_atom.dart';

/// Represents an abstract person, aka a peep.
class Peep {
  final PeepAtom head;
  final PeepAtom face;
  final PeepAtom facialHair;
  final PeepAtom accessory;

  const Peep({
    required this.head,
    required this.face,
    required this.facialHair,
    required this.accessory,
  });

  /// Creates a [Peep] instance from a json object.
  factory Peep.fromJson(Map<String, dynamic> json) => Peep(
    head: PeepAtom.fromJson(json['head'] as Map<String, dynamic>),
    face: PeepAtom.fromJson(json['face'] as Map<String, dynamic>),
    facialHair: PeepAtom.fromJson(json['facialHair'] as Map<String, dynamic>),
    accessory: PeepAtom.fromJson(json['accessory'] as Map<String, dynamic>),
  );

  /// Converts the instance to a json object.
  Map<String, dynamic> toJson() => {
    'head': head.toJson(),
    'face': face.toJson(),
    'facialHair': facialHair.toJson(),
    'accessory': accessory.toJson(),
  };

  /// Returns a copy of this instance with the given fields replaced.
  Peep copyWith({
    PeepAtom? head,
    PeepAtom? face,
    PeepAtom? facialHair,
    PeepAtom? accessory,
  }) => Peep(
    head: head ?? this.head,
    face: face ?? this.face,
    facialHair: facialHair ?? this.facialHair,
    accessory: accessory ?? this.accessory,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Peep &&
          runtimeType == other.runtimeType &&
          head == other.head &&
          face == other.face &&
          facialHair == other.facialHair &&
          accessory == other.accessory;

  @override
  int get hashCode => Object.hash(head, face, facialHair, accessory);

  @override
  String toString() =>
      'Peep(head: $head, face: $face, facialHair: $facialHair, accessory: $accessory)';
}
