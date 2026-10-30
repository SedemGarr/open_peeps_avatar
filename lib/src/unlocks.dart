import 'package:open_peeps_avatar/src/atoms/anchors.dart';
import 'package:open_peeps_avatar/src/atoms/body.dart';
import 'package:open_peeps_avatar/src/avatar_look.dart';

/// Which avatar items a game locks, and the requirement (e.g. a badge id)
/// that unlocks each one. Requirement ids mean whatever the game wants; the
/// studio just checks them against its `earned` set.
class AvatarUnlockRules {
  /// Outfit atom name → requirement.
  final Map<String, int> outfits;

  /// Pose atom name → requirement.
  final Map<String, int> poses;

  /// Ink index → requirement.
  final Map<int, int> inks;

  /// Background index → requirement.
  final Map<int, int> backgrounds;

  /// Pattern index → requirement.
  final Map<int, int> patterns;

  const AvatarUnlockRules({
    this.outfits = const {},
    this.poses = const {},
    this.inks = const {},
    this.backgrounds = const {},
    this.patterns = const {},
  });

  /// Everything free.
  static const AvatarUnlockRules none = AvatarUnlockRules();
}

/// Avatar items earned in game.
///
/// Representation items (skin tones, the wheelchair pose, hair, faces) are
/// never locked.
///
/// "Picked for you" outfits and poses only come from free items, so changing
/// the rules changes how looks with outfit/pose 0 render. Call [configure]
/// once at startup, before any avatar is shown, and keep the rules stable.
class AvatarUnlocks {
  const AvatarUnlocks._();

  static AvatarUnlockRules _rules = AvatarUnlockRules.none;

  static AvatarUnlockRules get rules => _rules;

  static void configure(AvatarUnlockRules rules) => _rules = rules;

  /// Requirement for outfit option [i] (1-based), or null if free.
  static int? outfit(int i) =>
      i <= 0 ? null : _rules.outfits[Body.atoms[i - 1].name];

  /// Requirement for pose option [i] (1-based), or null if free.
  static int? pose(int i) =>
      i <= 0 ? null : _rules.poses[PeepAnchors.poses[i - 1].atom.name];

  /// Requirement for option [i] of [part], or null if it's free.
  static int? badgeFor(AvatarPart part, int i) => switch (part) {
    AvatarPart.outfit => outfit(i),
    AvatarPart.pose => pose(i),
    AvatarPart.ink => _rules.inks[i],
    AvatarPart.background => _rules.backgrounds[i],
    AvatarPart.pattern => _rules.patterns[i],
    _ => null,
  };

  static bool isUnlocked(AvatarPart part, int i, Set<int> earned) {
    final badge = badgeFor(part, i);
    return badge == null || earned.contains(badge);
  }
}
