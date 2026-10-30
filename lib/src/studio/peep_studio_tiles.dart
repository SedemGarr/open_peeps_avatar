part of 'peep_studio.dart';

/// Keeps the category chips in view while the options scroll beneath.
class _PinnedHeader extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _PinnedHeader({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox(height: height, child: child);

  @override
  bool shouldRebuild(_PinnedHeader old) => true;
}

class _OptionTile extends StatelessWidget {
  final PeepStudioStyle style;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;
  final Widget child;

  const _OptionTile({
    required this.style,
    required this.selected,
    required this.locked,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          duration: PeepTheme.of(context).animationDuration,
          curve: Curves.easeOutBack,
          scale: selected ? 1.06 : 1,
          child: style.tile(
            context,
            selected,
            Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: locked ? 0.35 : 1,
                  child: Center(child: child),
                ),
                if (locked)
                  Align(
                    alignment: Alignment.topRight,
                    child: style.icon(context, PeepStudioIcon.locked, size: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
