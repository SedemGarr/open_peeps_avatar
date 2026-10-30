import 'package:open_peeps_avatar/src/atoms/accessories.dart';
import 'package:open_peeps_avatar/src/atoms/anchors.dart';
import 'package:open_peeps_avatar/src/atoms/body.dart';
import 'package:open_peeps_avatar/src/atoms/face.dart';
import 'package:open_peeps_avatar/src/atoms/facial_hair.dart';
import 'package:open_peeps_avatar/src/atoms/head.dart';
import 'package:open_peeps_avatar/src/avatar_look.dart';

/// What the studio shows for each customisable part.
extension AvatarPartInfo on AvatarPart {
  /// How many options the part has. Outfit and pose include 0, "picked
  /// for you".
  int get optionCount => switch (this) {
    AvatarPart.head => Head.atoms.length,
    AvatarPart.face => Face.atoms.length,
    AvatarPart.facialHair => FacialHair.atoms.length,
    AvatarPart.accessory => Accessories.atoms.length,
    AvatarPart.outfit => Body.atoms.length + 1,
    AvatarPart.pose => PeepAnchors.poses.length + 1,
    AvatarPart.skin => AvatarLook.skinTones.length,
    AvatarPart.ink => AvatarLook.inks.length,
    AvatarPart.background => AvatarLook.backgrounds,
    AvatarPart.pattern => AvatarLook.patterns,
  };
}

/// Reading and setting a look one part at a time.
extension AvatarLookParts on AvatarLook {
  int valueOf(AvatarPart part) => switch (part) {
    AvatarPart.head => head,
    AvatarPart.face => face,
    AvatarPart.facialHair => facialHair,
    AvatarPart.accessory => accessory,
    AvatarPart.outfit => outfit,
    AvatarPart.pose => pose,
    AvatarPart.skin => skin,
    AvatarPart.ink => ink,
    AvatarPart.background => background,
    AvatarPart.pattern => pattern,
  };

  AvatarLook withPart(AvatarPart part, int i) => switch (part) {
    AvatarPart.head => copyWith(head: i),
    AvatarPart.face => copyWith(face: i),
    AvatarPart.facialHair => copyWith(facialHair: i),
    AvatarPart.accessory => copyWith(accessory: i),
    AvatarPart.outfit => copyWith(outfit: i),
    AvatarPart.pose => copyWith(pose: i),
    AvatarPart.skin => copyWith(skin: i),
    AvatarPart.ink => copyWith(ink: i),
    AvatarPart.background => copyWith(background: i),
    AvatarPart.pattern => copyWith(pattern: i),
  };
}
