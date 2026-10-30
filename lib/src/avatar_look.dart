import 'dart:math';
import 'dart:ui';

import 'package:open_peeps_avatar/src/models/peep.dart';
import 'package:open_peeps_avatar/src/models/peep_atom.dart';
import 'package:open_peeps_avatar/src/atoms/accessories.dart';
import 'package:open_peeps_avatar/src/atoms/anchors.dart';
import 'package:open_peeps_avatar/src/atoms/body.dart';
import 'package:open_peeps_avatar/src/atoms/face.dart';
import 'package:open_peeps_avatar/src/atoms/facial_hair.dart';
import 'package:open_peeps_avatar/src/atoms/head.dart';
import 'package:open_peeps_avatar/src/serializer/serializer.dart';
import 'package:open_peeps_avatar/src/unlocks.dart';

/// A passing expression, shown instead of the player's chosen face.
enum AvatarMood {
  neutral,
  happy,
  laughing,
  sad,
  shocked,
  smug,
  thinking,
  blink,
}

/// Code-drawn props shown in context (not saved), e.g. a crown for #1.
enum AvatarProp { none, crown, sparkle }

/// Everything about a player's avatar.
///
/// Packed into a single int ([encode]/[decode]) so it stores anywhere a
/// number does. The low 32 bits are the original v1 encoding (head, face,
/// facial hair, accessory, see [PeepSerializer]), so v1 readers still decode
/// those, and the new choices sit above them. The extra part is packed with
/// plain arithmetic (not bit shifts, which are 32-bit on the web) and keeps
/// the whole value under 2^53, so it's exact on every platform.
class AvatarLook {
  final int head;
  final int face;
  final int facialHair;
  final int accessory;

  /// 0 = uncoloured paper (the original look), then skin tones.
  final int skin;

  /// Pen colour for lines and hair; 0 = black ink.
  final int ink;

  /// 0 = picked for you, else `Body.atoms[outfit - 1]`.
  final int outfit;

  /// 0 = picked for you, else `PeepAnchors.poses[pose - 1]`.
  final int pose;

  /// 0 = the classic colour derived from the avatar, else a paper colour.
  final int background;

  /// 0 = plain, 1 dots, 2 grid, 3 stripes.
  final int pattern;

  const AvatarLook({
    required this.head,
    required this.face,
    required this.facialHair,
    required this.accessory,
    this.skin = 0,
    this.ink = 0,
    this.outfit = 0,
    this.pose = 0,
    this.background = 0,
    this.pattern = 0,
  });

  // ── Options ───────────────────────────────────────────────────────────────

  static const List<Color> skinTones = [
    Color(0xFFFFFFFF),
    Color(0xFFFBE3D3),
    Color(0xFFF3CBA5),
    Color(0xFFE2B184),
    Color(0xFFC68C5C),
    Color(0xFFA26A42),
    Color(0xFF7A4B2C),
    Color(0xFF55331F),
  ];

  static const List<Color> inks = [
    Color(0xFF000000),
    Color(0xFF1F3FA0),
    Color(0xFFB3261E),
    Color(0xFF1B6B3A),
    Color(0xFF5B2A86),
    Color(0xFF5A5A5A),
  ];

  static const int backgrounds = 6;
  static const int patterns = 4;

  // ── Encoding ──────────────────────────────────────────────────────────────

  static const int _v1Span = 4294967296; // 2^32

  static const int _skinN = 8, _inkN = 6, _outfitN = 31, _poseN = 35;
  static const int _bgN = backgrounds, _patternN = patterns;

  factory AvatarLook.decode(int value) {
    final v = value < 0 ? 0 : value;
    var ext = v ~/ _v1Span;
    final peep = PeepSerializer.deserializeVersion1(value: v - ext * _v1Span);
    int take(int n) {
      final r = ext % n;
      ext ~/= n;
      return r;
    }

    final skin = take(_skinN);
    final ink = take(_inkN);
    final outfit = take(_outfitN);
    final pose = take(_poseN);
    final background = take(_bgN);
    final pattern = take(_patternN);
    return AvatarLook(
      head: Head.atoms.indexOf(peep.head),
      face: Face.atoms.indexOf(peep.face),
      facialHair: FacialHair.atoms.indexOf(peep.facialHair),
      accessory: Accessories.atoms.indexOf(peep.accessory),
      skin: skin,
      ink: ink,
      outfit: outfit,
      pose: pose,
      background: background,
      pattern: pattern,
    );
  }

  int encode() {
    final ext =
        skin +
        _skinN *
            (ink +
                _inkN *
                    (outfit +
                        _outfitN *
                            (pose + _poseN * (background + _bgN * pattern))));
    return PeepSerializer.serializeVersion1(peep: peep) + ext * _v1Span;
  }

  // ── Parts ─────────────────────────────────────────────────────────────────

  Peep get peep => Peep(
    head: Head.atoms[head],
    face: Face.atoms[face],
    facialHair: FacialHair.atoms[facialHair],
    accessory: Accessories.atoms[accessory],
  );

  /// The face to draw for [mood] (the player's own face when neutral).
  PeepAtom faceFor(AvatarMood mood) {
    final name = switch (mood) {
      AvatarMood.neutral => null,
      AvatarMood.happy => 'Smile Big',
      AvatarMood.laughing => 'Smile LOL',
      AvatarMood.sad => 'Concerned',
      AvatarMood.shocked => 'Awe',
      AvatarMood.smug => 'Cheeky',
      AvatarMood.thinking => 'Suspicious',
      AvatarMood.blink => 'Eyes Closed',
    };
    if (name == null) return Face.atoms[face];
    return Face.atoms.firstWhere(
      (a) => a.name == name,
      orElse: () => Face.atoms[face],
    );
  }

  /// Outfits picked "for you" come only from the free ones.
  PeepAtom get outfitAtom {
    if (outfit > 0) return Body.atoms[outfit - 1];
    final free = [
      for (var i = 0; i < Body.atoms.length; i++)
        if (AvatarUnlocks.outfit(i + 1) == null) Body.atoms[i],
    ];
    return free[(head * 7 + face * 3 + facialHair) % free.length];
  }

  ({PeepAtom atom, Offset neck}) get poseEntry {
    if (pose > 0) return PeepAnchors.poses[pose - 1];
    final free = [
      for (var i = 0; i < PeepAnchors.poses.length; i++)
        if (AvatarUnlocks.pose(i + 1) == null &&
            PeepAnchors.poses[i].atom.directoryName.endsWith('standing'))
          PeepAnchors.poses[i],
    ];
    return free[(head + accessory * 5 + face) % free.length];
  }

  Color get skinColor => skinTones[skin.clamp(0, skinTones.length - 1)];
  Color get inkColor => inks[ink.clamp(0, inks.length - 1)];

  AvatarLook copyWith({
    int? head,
    int? face,
    int? facialHair,
    int? accessory,
    int? skin,
    int? ink,
    int? outfit,
    int? pose,
    int? background,
    int? pattern,
  }) => AvatarLook(
    head: head ?? this.head,
    face: face ?? this.face,
    facialHair: facialHair ?? this.facialHair,
    accessory: accessory ?? this.accessory,
    skin: skin ?? this.skin,
    ink: ink ?? this.ink,
    outfit: outfit ?? this.outfit,
    pose: pose ?? this.pose,
    background: background ?? this.background,
    pattern: pattern ?? this.pattern,
  );

  /// A random look, keeping [keep] parts and never picking locked items.
  AvatarLook shuffled(
    Random rng, {
    Set<AvatarPart> keep = const {},
    Set<int> earnedBadges = const {},
  }) {
    int pick(AvatarPart part, int current, int count, {int from = 0}) {
      if (keep.contains(part)) return current;
      final options = [
        for (var i = from; i < count; i++)
          if (AvatarUnlocks.isUnlocked(part, i, earnedBadges)) i,
      ];
      return options[rng.nextInt(options.length)];
    }

    return AvatarLook(
      head: pick(AvatarPart.head, head, Head.atoms.length),
      face: pick(AvatarPart.face, face, Face.atoms.length),
      facialHair: pick(
        AvatarPart.facialHair,
        facialHair,
        FacialHair.atoms.length,
      ),
      accessory: pick(
        AvatarPart.accessory,
        accessory,
        Accessories.atoms.length,
      ),
      skin: pick(AvatarPart.skin, skin, skinTones.length),
      ink: pick(AvatarPart.ink, ink, inks.length),
      outfit: pick(AvatarPart.outfit, outfit, Body.atoms.length + 1, from: 1),
      pose: pick(AvatarPart.pose, pose, PeepAnchors.poses.length + 1, from: 1),
      background: pick(AvatarPart.background, background, backgrounds),
      pattern: pick(AvatarPart.pattern, pattern, patterns),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AvatarLook && other.encode() == encode();

  @override
  int get hashCode => encode().hashCode;
}

/// The parts players can change in the studio.
enum AvatarPart {
  head,
  face,
  facialHair,
  accessory,
  outfit,
  pose,
  skin,
  ink,
  background,
  pattern,
}
