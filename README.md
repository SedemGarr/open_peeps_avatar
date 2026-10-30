# open_peeps_avatar

Customisable [Open Peeps](https://www.openpeeps.com) avatars for Flutter games. Built by Wayyy Out Games, building on [open_peeps](https://pub.dev/packages/open_peeps) by Jens Horstmann.

- **`AvatarLook`**: head, face, facial hair, accessory, skin, pen colour, outfit, pose, background and pattern, packed into one `int` (exact on web, < 2^53).
- **Widgets**: `PeepSticker` (round head and shoulders), `PeepCard` (full body), `PeepFigure` / `PeepBust` / `PeepPortrait` to build your own frames, and `PeepAvatar` (head only, v1).
- **`PeepStudio`**: the full editor with shuffle, undo, keep-when-shuffling, saved looks and locked items. Text, icons and widgets are all swappable.

## Install

```sh
flutter pub add open_peeps_avatar
```

You don't need to declare the SVGs; they load from the package.

## Use

```dart
import 'package:open_peeps_avatar/open_peeps_avatar.dart';

// A new player
final avatar = const AvatarLook(head: 0, face: 0, facialHair: 0, accessory: 0)
    .shuffled(Random())
    .encode();

PeepSticker(avatar: avatar, size: 48, animate: true);
PeepCard(avatar: avatar, width: 160);

showPeepStudio(
  context: context,
  studio: PeepStudio(
    initial: avatar,
    onClose: (code) => saveAvatar(code),
    savedLooks: loadSavedLooks(),
    onSavedLooksChanged: storeSavedLooks, // omit to hide saving
  ),
);
```

### Theming

Colours come from the `ColorScheme` unless you add a `PeepTheme`:

```dart
ThemeData(extensions: [
  PeepTheme(
    card: Colors.white,
    ink: Colors.black,
    highlight: Colors.amber,
    backgrounds: [/* 5 colours: background options 1-5 */],
    classicBackground: (seed) => ..., // option 0, optional
  ),
]);
```

For the studio, pass `PeepStudioStrings(...)` for translations and `PeepStudioStyle(...)` to swap icons, the preview avatar, option tiles, the Shuffle button, dividers and swatch outlines.

### Locked items

Everything is free by default. To gate items behind your game's badges, call this once at startup, before any avatar is drawn:

```dart
AvatarUnlocks.configure(const AvatarUnlockRules(
  outfits: {'Gaming': 33},
  poses: {'bike': 37},
  inks: {3: 23},
));
```

Then give the studio `earned: {...badge ids}` and `onLockedTap`.

"Picked for you" outfits and poses (option 0) only come from free items, so changing the rules changes how those looks render. Keep the rules stable once players have saved avatars.

## Development

- `flutter test`: `test/avatar_encoding_test.dart` pins the encoding against values captured from Simple Shuffle; it must never change.
- `tool/open_peeps_generator.dart` regenerates the atom lists from SVGs.

## Credits

- Illustrations: [Open Peeps](https://www.openpeeps.com) by Pablo Stanley (CC0).
- Original atom and serializer code: [open_peeps](https://pub.dev/packages/open_peeps) by Jens Horstmann (MIT).
