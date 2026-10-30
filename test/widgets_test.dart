import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_peeps_avatar/open_peeps_avatar.dart';

const int _code = 1565863724584196;

Widget _app(Widget child, {Size size = const Size(400, 800)}) => MediaQuery(
  data: MediaQueryData(size: size),
  child: MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

Future<void> _loadSvgs(WidgetTester tester) async {
  // Asset loading is real async work; let it finish outside the fake clock.
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 300)),
  );
  await tester.pump();
}

void main() {
  testWidgets('sticker and card load their SVGs from the package', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Column(
          children: [
            PeepSticker(avatar: _code, prop: AvatarProp.crown),
            PeepCard(avatar: _code, width: 120),
          ],
        ),
      ),
    );
    await _loadSvgs(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(SvgPicture), findsWidgets);

    // Every part resolves to a bundled asset.
    final bundle = DefaultAssetBundle.of(
      tester.element(find.byType(PeepSticker)),
    );
    final look = AvatarLook.decode(_code);
    for (final atom in [
      look.peep.head,
      look.peep.face,
      look.outfitAtom,
      look.poseEntry.atom,
    ]) {
      final key =
          'packages/$peepsPackage/assets/peeps/${atom.directoryName}/${atom.name}.svg';
      final data = await tester.runAsync(() => bundle.load(key));
      expect(data!.lengthInBytes, greaterThan(0), reason: key);
    }
  });

  testWidgets('PeepTheme falls back to the colour scheme', (tester) async {
    late PeepTheme theme;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) {
            theme = PeepTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(theme.backgrounds, hasLength(AvatarLook.backgrounds - 1));
  });

  for (final size in [const Size(400, 800), const Size(1000, 800)]) {
    testWidgets('studio edits, shuffles and reports on close (${size.width})', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      int? closedWith;
      PeepStudioStats? stats;
      List<int>? saved;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showPeepStudio(
                  context: context,
                  studio: PeepStudio(
                    initial: _code,
                    onClose: (c) => closedWith = c,
                    onStats: (s) => stats = s,
                    onSavedLooksChanged: (s) => saved = s,
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Shuffle me'));
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.byTooltip('Save look'));
      await tester.pump();
      expect(saved, hasLength(1));

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(closedWith, isNotNull);
      expect(stats!.shuffles, 1);
      expect(closedWith, stats!.look.encode());
    });
  }

  testWidgets('stickers can make room for their prop', (tester) async {
    await tester.pumpWidget(
      _app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PeepSticker(avatar: _code, size: 100, prop: AvatarProp.crown),
            PeepSticker(
              avatar: _code,
              size: 100,
              prop: AvatarProp.crown,
              reservePropSpace: true,
            ),
            PeepSticker(
              avatar: _code,
              size: 100,
              prop: AvatarProp.sparkle,
              reservePropSpace: true,
            ),
          ],
        ),
      ),
    );
    await _loadSvgs(tester);

    final frames = find.byType(PeepPropFrame);
    expect(tester.getSize(frames.at(0)), const Size(100, 100));
    expect(tester.getSize(frames.at(1)), const Size(100, 142));
    expect(tester.getSize(frames.at(2)), const Size(112, 112));
  });

  testWidgets('peeps are silent to screen readers unless labelled', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PeepSticker(
              avatar: _code,
              semanticLabel: "CleverOtter482's avatar",
            ),
            PeepCard(avatar: _code, width: 120),
          ],
        ),
      ),
    );
    await _loadSvgs(tester);

    expect(find.bySemanticsLabel("CleverOtter482's avatar"), findsOneWidget);
    expect(tester.getSemantics(find.byType(PeepCard)).label, isEmpty);
    handle.dispose();
  });

  testWidgets('a cutout outlines its child without changing its size', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        PeepCutout(
          color: Colors.white,
          child: SizedBox(
            height: 200,
            child: FittedBox(
              child: PeepFigure(look: AvatarLook.decode(_code), fullBody: true),
            ),
          ),
        ),
      ),
    );
    await _loadSvgs(tester);

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(PeepCutout)).height, 200);
  });

  testWidgets('a capture turns a peep into PNG bytes', (tester) async {
    final controller = PeepCaptureController();
    await tester.pumpWidget(
      _app(
        PeepCapture(
          controller: controller,
          child: const PeepSticker(avatar: _code, size: 80),
        ),
      ),
    );
    await _loadSvgs(tester);

    final png = await tester.runAsync(() => controller.toPng(pixelRatio: 2));
    // The PNG signature.
    expect(png!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    expect(() => PeepCaptureController().toImage(), throwsStateError);
  });
}
