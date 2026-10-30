import 'package:open_peeps_avatar/src/avatar_look.dart';

/// Every piece of text the studio shows. Defaults are English; pass your
/// own translations.
class PeepStudioStrings {
  final String title;
  final String head;
  final String face;
  final String facialHair;
  final String accessory;
  final String outfit;
  final String pose;
  final String skin;
  final String ink;
  final String background;
  final String pattern;
  final String sticker;
  final String fullBody;
  final String shuffle;
  final String undo;
  final String saveLook;
  final String savedLooks;
  final String keep;
  final String auto;
  final String classic;
  final String plain;

  /// Shown when a locked item is tapped and no `onLockedTap` is given.
  final String locked;

  const PeepStudioStrings({
    this.title = 'Customise Avatar',
    this.head = 'Head',
    this.face = 'Face',
    this.facialHair = 'Facial Hair',
    this.accessory = 'Accessory',
    this.outfit = 'Outfit',
    this.pose = 'Pose',
    this.skin = 'Skin',
    this.ink = 'Pen colour',
    this.background = 'Paper',
    this.pattern = 'Pattern',
    this.sticker = 'Sticker',
    this.fullBody = 'Full body',
    this.shuffle = 'Shuffle me',
    this.undo = 'Undo',
    this.saveLook = 'Save look',
    this.savedLooks = 'Saved looks',
    this.keep = 'Keep when shuffling',
    this.auto = 'Pick for me',
    this.classic = 'Classic',
    this.plain = 'Plain',
    this.locked = 'Locked',
  });

  String labelFor(AvatarPart part) => switch (part) {
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
}
