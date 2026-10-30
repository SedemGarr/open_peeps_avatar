## 0.2.0

- `PeepCutout`: a die-cut outline around any peep, so dark-ink peeps stand out on dark backgrounds.
- `PeepCapture` and `PeepCaptureController`: capture a peep (or a whole share card) as an image or PNG bytes.
- `semanticLabel` on `PeepSticker`, `PeepCard` and `PeepFigure`. Peeps without one are now hidden from screen readers instead of exposing an unlabelled image per SVG part.
- `PeepSticker.reservePropSpace` grows the sticker to fit its crown or sparkle, which otherwise draws outside it.

## 0.1.1

- Add an Open Peeps illustration to the README.

## 0.1.0

- Initial release.
- `AvatarLook`: head, face, facial hair, accessory, skin, pen colour, outfit, pose, background and pattern in one int, backwards compatible with `open_peeps`' v1 serializer.
- `PeepSticker`, `PeepCard`, `PeepFigure`, `PeepBust`, `PeepPortrait` and `PeepAvatar` widgets, with moods and props.
- `PeepStudio` editor with shuffle, undo, saved looks and locked items; text, icons and widgets are customisable.
- `PeepTheme` theme extension and configurable `AvatarUnlocks`.
