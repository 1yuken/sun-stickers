import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_stickers/data/_data.dart';
import 'package:sun_stickers/ui_kit/_ui_kit.dart';
import 'package:sun_stickers/implementations/vanilla/vanilla_app.dart';

const captureScreenshots = bool.fromEnvironment('CAPTURE_SCREENSHOTS');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    if (!captureScreenshots) return;
    final sdk = Platform.environment['FLUTTER_ROOT'];
    if (sdk == null) throw StateError('Run this test using flutter test.');
    for (final family in ['Roboto', 'MaterialIcons']) {
      final filename = family == 'Roboto'
          ? 'Roboto-Regular.ttf'
          : 'MaterialIcons-Regular.otf';
      final loader = FontLoader(family);
      loader.addFont(File('$sdk/bin/cache/artifacts/material_fonts/$filename')
          .readAsBytes()
          .then((b) => ByteData.sublistView(b)));
      if (family == 'Roboto') {
        loader.addFont(
            File('$sdk/bin/cache/artifacts/material_fonts/Roboto-Bold.ttf')
                .readAsBytes()
                .then((b) => ByteData.sublistView(b)));
      }
      await loader.load();
    }
    for (final entry in {
      'AppIcon': 'assets/fonts/AppIcon.ttf',
      'packages/font_awesome_flutter/FontAwesomeSolid':
          'packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf',
    }.entries) {
      await (FontLoader(entry.key)..addFont(rootBundle.load(entry.value)))
          .load();
    }
  });

  testWidgets('capture report screens using real widgets and assets',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
        RepaintBoundary(key: boundaryKey, child: const VanillaApp()));
    await tester.runAsync(() async {
      final context = boundaryKey.currentContext!;
      for (final asset in [
        ...AppData.stickers.map((e) => e.image),
        AppAsset.emptyCart,
        AppAsset.emptyFavorite,
        AppAsset.profileImage,
      ]) {
        await precacheImage(AssetImage(asset), context);
      }
    });
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    await tester.pumpAndSettle();
    Future<void> tap(String key) async {
      await tester.tap(find.byKey(ValueKey(key)).first);
      await tester.pumpAndSettle();
    }

    Future<void> save(String filename) async {
      await tester.pump();
      final boundary = boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        final bytes = data!.buffer.asUint8List();
        image.dispose();
        final file = File('docs/screenshots/$filename.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes);
      });
    }

    await save('01-catalogue');
    await tap('category-toy');
    await save('02-category-toy');
    await tap('sticker-2');
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
    }
    await tap('toggle-favorite');
    await tap('add-to-cart');
    await save('03-detail-ball');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tap('nav-1');
    await save('04-cart');
    await tap('nav-2');
    await save('05-favorite');
    await tap('nav-0');
    await tap('toggle-theme');
    await save('06-dark-theme');
    await tap('nav-1');
    await tap('checkout');
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await save('07-empty-cart');
    await tap('nav-2');
    await tap('remove-favorite-2');
    await save('08-empty-favorite');
    debugDisableShadows = true;
    expect(tester.takeException(), isNull);
  }, skip: !captureScreenshots);
}
