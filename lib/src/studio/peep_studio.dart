import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_peeps_avatar/src/atoms/accessories.dart';
import 'package:open_peeps_avatar/src/atoms/anchors.dart';
import 'package:open_peeps_avatar/src/atoms/body.dart';
import 'package:open_peeps_avatar/src/atoms/face.dart';
import 'package:open_peeps_avatar/src/atoms/facial_hair.dart';
import 'package:open_peeps_avatar/src/atoms/head.dart';
import 'package:open_peeps_avatar/src/avatar_look.dart';
import 'package:open_peeps_avatar/src/models/peep_atom.dart';
import 'package:open_peeps_avatar/src/studio/avatar_parts.dart';
import 'package:open_peeps_avatar/src/studio/studio_strings.dart';
import 'package:open_peeps_avatar/src/studio/studio_style.dart';
import 'package:open_peeps_avatar/src/theme.dart';
import 'package:open_peeps_avatar/src/unlocks.dart';
import 'package:open_peeps_avatar/src/widgets/peep_image.dart';

part 'peep_studio_tiles.dart';

/// Opens [studio] in a dialog on wide screens, or an almost-full-height
/// bottom sheet on phones.
Future<void> showPeepStudio({
  required BuildContext context,
  required PeepStudio studio,
}) {
  Widget header(BuildContext context, EdgeInsets padding) => Padding(
    padding: padding,
    child: Row(
      children: [
        Expanded(
          child: Text(
            studio.strings.title,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: studio.style.icon(context, PeepStudioIcon.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );

  if (MediaQuery.sizeOf(context).width >= PeepStudio.wideBreakpoint) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780, maxHeight: 760),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              header(context, const EdgeInsets.fromLTRB(20, 16, 8, 0)),
              studio.style.divider(context, Axis.horizontal),
              Flexible(child: studio),
            ],
          ),
        ),
      ),
    );
  }
  // Phones get almost the whole screen: a dialog left the options grid only
  // a sliver of height.
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.96,
      child: Column(
        children: [
          header(context, const EdgeInsets.fromLTRB(20, 0, 8, 4)),
          Expanded(child: studio),
        ],
      ),
    ),
  );
}

/// One summary per studio visit, for analytics.
class PeepStudioStats {
  final bool changed;
  final int edits;
  final int shuffles;
  final int savedLooks;
  final AvatarLook look;

  const PeepStudioStats({
    required this.changed,
    required this.edits,
    required this.shuffles,
    required this.savedLooks,
    required this.look,
  });
}

/// The avatar editor: a live preview, part categories and an option grid,
/// with shuffle, undo and saved looks.
class PeepStudio extends StatefulWidget {
  /// The encoded look the studio opens with.
  final int initial;

  /// Called with the encoded look when the studio closes.
  final ValueChanged<int> onClose;

  /// Requirements the player has met (see [AvatarUnlocks]).
  final Set<int> earned;

  /// Called when a locked option is tapped, with the requirement it needs.
  /// Defaults to a snackbar showing [PeepStudioStrings.locked].
  final void Function(AvatarPart part, int requirement)? onLockedTap;

  /// Saved looks, newest first. Saving is hidden without
  /// [onSavedLooksChanged].
  final List<int> savedLooks;
  final ValueChanged<List<int>>? onSavedLooksChanged;

  /// Called once, as the studio closes.
  final ValueChanged<PeepStudioStats>? onStats;

  final PeepStudioStrings strings;
  final PeepStudioStyle style;

  const PeepStudio({
    super.key,
    required this.initial,
    required this.onClose,
    this.earned = const {},
    this.onLockedTap,
    this.savedLooks = const [],
    this.onSavedLooksChanged,
    this.onStats,
    this.strings = const PeepStudioStrings(),
    this.style = const PeepStudioStyle(),
  });

  /// From this width the studio shows preview and options side by side.
  static const double wideBreakpoint = 640;

  static const int maxSavedLooks = 6;

  @override
  State<PeepStudio> createState() => _PeepStudioState();
}

class _PeepStudioState extends State<PeepStudio> {
  late AvatarLook _look = AvatarLook.decode(widget.initial);
  final List<AvatarLook> _history = [];
  final Set<AvatarPart> _keep = {};
  final Random _rng = Random();
  late List<int> _saved = widget.savedLooks;
  AvatarPart _part = AvatarPart.head;
  bool _fullBody = false;
  int _shuffles = 0;
  int _edits = 0;

  PeepStudioStrings get _strings => widget.strings;
  PeepStudioStyle get _style => widget.style;
  bool get _canSave => widget.onSavedLooksChanged != null;

  @override
  void dispose() {
    final code = _look.encode();
    widget.onStats?.call(
      PeepStudioStats(
        changed: code != widget.initial,
        edits: _edits,
        shuffles: _shuffles,
        savedLooks: _saved.length,
        look: _look,
      ),
    );
    widget.onClose(code);
    super.dispose();
  }

  void _set(AvatarLook look) {
    if (look == _look) return;
    _edits++;
    setState(() {
      _history.add(_look);
      if (_history.length > 40) _history.removeAt(0);
      _look = look;
    });
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() => _look = _history.removeLast());
  }

  void _shuffle() {
    HapticFeedback.lightImpact();
    _shuffles++;
    _set(_look.shuffled(_rng, keep: _keep, earnedBadges: widget.earned));
  }

  void _saveLook() {
    final code = _look.encode();
    setState(() {
      _saved = [
        code,
        ..._saved.where((c) => c != code),
      ].take(PeepStudio.maxSavedLooks).toList();
    });
    widget.onSavedLooksChanged?.call(_saved);
  }

  void _removeSaved(int code) {
    setState(() => _saved = _saved.where((c) => c != code).toList());
    widget.onSavedLooksChanged?.call(_saved);
  }

  void _pick(AvatarPart part, int i) {
    final badge = AvatarUnlocks.badgeFor(part, i);
    if (badge != null && !widget.earned.contains(badge)) {
      if (widget.onLockedTap != null) {
        widget.onLockedTap!(part, badge);
      } else {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(_strings.locked)));
      }
      return;
    }
    HapticFeedback.selectionClick();
    // Picking an outfit or pose shows it on the preview.
    if (part == AvatarPart.pose) _fullBody = true;
    if (part == AvatarPart.outfit) _fullBody = false;
    _set(_look.withPart(part, i));
  }

  // ── Building ──────────────────────────────────────────────────────────────

  Widget _modeChips({required double spacing}) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        ChoiceChip(
          label: Text(_strings.sticker),
          selected: !_fullBody,
          onSelected: (_) => setState(() => _fullBody = false),
        ),
        ChoiceChip(
          label: Text(_strings.fullBody),
          selected: _fullBody,
          onSelected: (_) => setState(() => _fullBody = true),
        ),
      ],
    );
  }

  Widget _previewAvatar({required double sticker, required double card}) {
    final code = _look.encode();
    return AnimatedSwitcher(
      duration: PeepTheme.of(context).animationDuration,
      child: KeyedSubtree(
        key: ValueKey(_fullBody),
        child: _style.avatar(
          context,
          code,
          fullBody: _fullBody,
          size: _fullBody ? card : sticker,
          animate: !_fullBody,
        ),
      ),
    );
  }

  List<Widget> _actions(EdgeInsets padding) => [
    _style.button(
      context,
      _shuffle,
      AnimatedRotation(
        turns: _shuffles.toDouble(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        child: _style.icon(context, PeepStudioIcon.shuffle),
      ),
      Text(_strings.shuffle),
      padding,
    ),
    IconButton(
      tooltip: _strings.undo,
      onPressed: _history.isEmpty ? null : _undo,
      icon: _style.icon(context, PeepStudioIcon.undo),
    ),
    if (_canSave)
      IconButton(
        tooltip: _strings.saveLook,
        onPressed: _saveLook,
        icon: _style.icon(context, PeepStudioIcon.saveLook),
      ),
  ];

  Widget _savedThumb(int code, double size) => GestureDetector(
    onTap: () => _set(AvatarLook.decode(code)),
    onLongPress: () => _removeSaved(code),
    child: _style.avatar(context, code, fullBody: false, size: size),
  );

  Widget _preview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _modeChips(spacing: 8),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: Center(child: _previewAvatar(sticker: 150, card: 150)),
        ),
        const SizedBox(height: 16),
        // Wraps the icon buttons under Shuffle in a narrow side column.
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: _actions(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        if (_saved.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            _strings.savedLooks,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final code in _saved) _savedThumb(code, 44)],
          ),
        ],
      ],
    );
  }

  Widget _categories() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final part in AvatarPart.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                avatar: _keep.contains(part)
                    ? _style.icon(context, PeepStudioIcon.locked, size: 14)
                    : null,
                label: Text(_strings.labelFor(part)),
                selected: _part == part,
                onSelected: (_) => setState(() => _part = part),
              ),
            ),
        ],
      ),
    );
  }

  Widget _keepChip() {
    final part = _part;
    final keep = _keep.contains(part);
    return FilterChip(
      avatar: _style.icon(
        context,
        keep ? PeepStudioIcon.locked : PeepStudioIcon.unlocked,
        size: 16,
      ),
      showCheckmark: false,
      label: Text(_strings.keep),
      selected: keep,
      onSelected: (v) =>
          setState(() => v ? _keep.add(part) : _keep.remove(part)),
    );
  }

  static const SliverGridDelegate _grid =
      SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 84,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      );

  Widget _tile(BuildContext context, int i) {
    final part = _part;
    final badge = AvatarUnlocks.badgeFor(part, i);
    return _OptionTile(
      style: _style,
      selected: _look.valueOf(part) == i,
      locked: badge != null && !widget.earned.contains(badge),
      onTap: () => _pick(part, i),
      child: _thumbnail(part, i),
    );
  }

  Widget _options() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: _keepChip(),
        ),
        Flexible(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: _grid,
            itemCount: _part.optionCount,
            itemBuilder: _tile,
          ),
        ),
      ],
    );
  }

  /// Phone header: preview on the left, actions and saved looks beside it.
  Widget _compactPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 150,
          child: Center(child: _previewAvatar(sticker: 112, card: 104)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _modeChips(spacing: 6),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                runSpacing: 6,
                children: _actions(
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              if (_saved.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final c in _saved)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _savedThumb(c, 40),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _thumbnail(AvatarPart part, int i) {
    final skin = PeepColors(fill: _look.skinColor, ink: _look.inkColor);
    final ink = PeepColors(ink: _look.inkColor);
    Widget atom(PeepAtom a, PeepColors c) => FittedBox(
      child: PeepImage(peepAtom: a, size: 48, colors: c),
    );
    // Scaled to fit: icon plus two lines overflowed small tiles.
    Widget auto() => FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _style.icon(context, PeepStudioIcon.auto, size: 22),
          Text(
            _strings.auto,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
    Widget swatch(Color c) => Container(
      decoration: ShapeDecoration(color: c, shape: _style.swatch(context)),
    );

    return switch (part) {
      AvatarPart.head => atom(Head.atoms[i], skin),
      AvatarPart.face => atom(Face.atoms[i], ink),
      AvatarPart.facialHair => atom(FacialHair.atoms[i], ink),
      AvatarPart.accessory => atom(Accessories.atoms[i], ink),
      AvatarPart.outfit => i == 0 ? auto() : atom(Body.atoms[i - 1], skin),
      AvatarPart.pose =>
        i == 0 ? auto() : atom(PeepAnchors.poses[i - 1].atom, skin),
      AvatarPart.skin => swatch(AvatarLook.skinTones[i]),
      AvatarPart.ink => swatch(AvatarLook.inks[i]),
      AvatarPart.background => Stack(
        alignment: Alignment.center,
        children: [
          swatch(
            avatarBackground(
              context,
              _look.copyWith(background: i),
              _look.encode(),
            ),
          ),
          if (i == 0)
            Text(
              _strings.classic,
              style: Theme.of(context).textTheme.labelSmall,
            ),
        ],
      ),
      AvatarPart.pattern => ClipOval(
        child: CustomPaint(
          painter: AvatarPatternPainter(
            color: avatarBackground(context, _look, _look.encode()),
            pattern: i,
          ),
          // A CustomPaint without a child takes no space, so the patterned
          // tiles need something to fill them or they draw nothing.
          child: i == 0
              ? Center(
                  child: Text(
                    _strings.plain,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                )
              : const SizedBox.expand(),
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= PeepStudio.wideBreakpoint;
    final editor = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _categories(),
        Flexible(child: _options()),
      ],
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 280,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _preview(),
            ),
          ),
          _style.divider(context, Axis.vertical),
          Expanded(child: editor),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: _compactPreview(),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _PinnedHeader(
            height: 112,
            child: ColoredBox(
              color: PeepTheme.of(context).card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _style.divider(context, Axis.horizontal),
                  const SizedBox(height: 8),
                  _categories(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: _keepChip(),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverGrid(
            gridDelegate: _grid,
            delegate: SliverChildBuilderDelegate(
              _tile,
              childCount: _part.optionCount,
            ),
          ),
        ),
      ],
    );
  }
}
