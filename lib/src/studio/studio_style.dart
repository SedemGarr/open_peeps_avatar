import 'package:flutter/material.dart';
import 'package:open_peeps_avatar/src/theme.dart';
import 'package:open_peeps_avatar/src/widgets/peep_card.dart';
import 'package:open_peeps_avatar/src/widgets/peep_sticker.dart';

/// Icons the studio draws.
enum PeepStudioIcon { close, shuffle, undo, saveLook, locked, unlocked, auto }

/// Swaps the studio's building blocks for your game's own widgets. Anything
/// left null uses a plain Material default.
class PeepStudioStyle {
  final Widget Function(
    BuildContext context,
    PeepStudioIcon icon,
    double? size,
  )?
  iconBuilder;

  /// The avatar preview, and the saved-look thumbnails (with [fullBody]
  /// false). [size] is the sticker's size or the card's width.
  final Widget Function(
    BuildContext context,
    int avatar, {
    required bool fullBody,
    required double size,
    required bool animate,
  })?
  avatarBuilder;

  /// The card behind each option; the studio adds selection scale, lock
  /// badge and dimming.
  final Widget Function(BuildContext context, bool selected, Widget child)?
  tileBuilder;

  /// The main Shuffle button; [padding] is smaller on phones.
  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    Widget icon,
    Widget label,
    EdgeInsets padding,
  )?
  buttonBuilder;

  final Widget Function(BuildContext context, Axis direction)? dividerBuilder;

  /// Outline for colour swatches.
  final ShapeBorder Function(BuildContext context)? swatchShape;

  const PeepStudioStyle({
    this.iconBuilder,
    this.avatarBuilder,
    this.tileBuilder,
    this.buttonBuilder,
    this.dividerBuilder,
    this.swatchShape,
  });

  Widget icon(BuildContext context, PeepStudioIcon icon, {double? size}) {
    if (iconBuilder != null) return iconBuilder!(context, icon, size);
    return Icon(switch (icon) {
      PeepStudioIcon.close => Icons.close,
      PeepStudioIcon.shuffle => Icons.shuffle,
      PeepStudioIcon.undo => Icons.undo,
      PeepStudioIcon.saveLook => Icons.bookmark_border,
      PeepStudioIcon.locked => Icons.lock_outline,
      PeepStudioIcon.unlocked => Icons.lock_open,
      PeepStudioIcon.auto => Icons.shuffle,
    }, size: size);
  }

  Widget avatar(
    BuildContext context,
    int avatar, {
    required bool fullBody,
    required double size,
    bool animate = false,
  }) {
    if (avatarBuilder != null) {
      return avatarBuilder!(
        context,
        avatar,
        fullBody: fullBody,
        size: size,
        animate: animate,
      );
    }
    return fullBody
        ? PeepCard(avatar: avatar, width: size)
        : PeepSticker(avatar: avatar, size: size, animate: animate);
  }

  Widget tile(BuildContext context, bool selected, Widget child) {
    if (tileBuilder != null) return tileBuilder!(context, selected, child);
    final theme = PeepTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: selected ? theme.highlight : theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.ink, width: selected ? 2 : 1),
      ),
      child: child,
    );
  }

  Widget button(
    BuildContext context,
    VoidCallback onPressed,
    Widget icon,
    Widget label,
    EdgeInsets padding,
  ) {
    if (buttonBuilder != null) {
      return buttonBuilder!(context, onPressed, icon, label, padding);
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: FilledButton.styleFrom(padding: padding),
    );
  }

  Widget divider(BuildContext context, Axis direction) {
    if (dividerBuilder != null) return dividerBuilder!(context, direction);
    return direction == Axis.horizontal
        ? const Divider(height: 1)
        : const VerticalDivider(width: 1);
  }

  ShapeBorder swatch(BuildContext context) =>
      swatchShape?.call(context) ??
      CircleBorder(
        side: BorderSide(color: PeepTheme.of(context).ink, width: 1.6),
      );
}
