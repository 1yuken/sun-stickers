import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_stickers/data/_data.dart';
import 'package:sun_stickers/states/sticker_scope.dart';
import 'package:sun_stickers/states/sticker_state.dart';
import 'app_variants.dart';

StickerState snapshot(WidgetTester tester) =>
    tester.widget<StickerScope>(find.byType(StickerScope)).state;

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey(key)).first);
  await tester.pumpAndSettle();
}

void main() {
  for (final variant in appVariants.entries) {
    group(variant.key, () {
      testWidgets('all 14 requirements through real screens and routes',
          (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(variant.value());
        await tester.pumpAndSettle();

        await tapKey(tester, 'nav-1');
        expect(find.text('Empty cart'), findsOneWidget);
        expect(find.byKey(const ValueKey('checkout')), findsNothing);
        await tapKey(tester, 'nav-2');
        expect(find.text('Empty favorite'), findsOneWidget);
        await tapKey(tester, 'nav-0');

        await tapKey(tester, 'category-toy');
        expect(
            snapshot(tester).categories.where((e) => e.isSelected).single.type,
            StickerType.toy);
        expect(
            snapshot(tester)
                .stickersByCategory
                .every((e) => e.type == StickerType.toy),
            isTrue);
        expect(find.byKey(const ValueKey('sticker-1')), findsNothing);
        final categoryButton = tester
            .widget<TextButton>(find.byKey(const ValueKey('category-toy')));
        expect(categoryButton.style!.backgroundColor!.resolve({}),
            isNot(Colors.transparent));

        await tapKey(tester, 'sticker-2'); // Ball, not hardcoded Apple.
        expect(
            tester.widget<Text>(find.byKey(const ValueKey('detail-name'))).data,
            'Ball');
        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();
        expect(snapshot(tester).getStickerById(2).quantity, 1);
        for (var i = 0; i < 2; i++) {
          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();
        }
        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();
        expect(
            tester
                .widget<Text>(find.byKey(const ValueKey('detail-quantity')))
                .data,
            '2');
        expect(
            tester
                .widget<Text>(find.byKey(const ValueKey('detail-price')))
                .data,
            '\$30.00');
        await tapKey(tester, 'toggle-favorite');
        await tapKey(tester, 'add-to-cart');
        expect(find.text('Added to cart'), findsOneWidget);
        expect(snapshot(tester).cart.length, 1);
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tapKey(tester, 'nav-1');
        expect(find.byKey(const ValueKey('cart-item-2')), findsOneWidget);
        expect(tester.widget<Text>(find.byKey(const ValueKey('subtotal'))).data,
            '\$30.00');
        expect(tester.widget<Text>(find.byKey(const ValueKey('total'))).data,
            '\$35.00');
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(
            tester
                .widget<Text>(find.byKey(const ValueKey('cart-price-2')))
                .data,
            '\$45.00');
        expect(snapshot(tester).subtotal, 45);
        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();
        expect(snapshot(tester).subtotal, 30);

        // An open detail route must see changes made in the cart.
        await tester.tap(find.text('Ball'));
        await tester.pumpAndSettle();
        expect(
            tester
                .widget<Text>(find.byKey(const ValueKey('detail-quantity')))
                .data,
            '2');
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.drag(
            find.byKey(const ValueKey('cart-item-2')), const Offset(-500, 0));
        await tester.pumpAndSettle();
        expect(find.text('Empty cart'), findsOneWidget);
        expect(snapshot(tester).getStickerById(2).quantity, 1);

        await tapKey(tester, 'nav-2');
        await tapKey(tester, 'favorite-item-2');
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        await tapKey(tester, 'add-to-cart');
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tapKey(tester, 'nav-1');
        await tapKey(tester, 'checkout');
        expect(find.text('Empty cart'), findsOneWidget);
        expect(snapshot(tester).cart, isEmpty);
        expect(snapshot(tester).total, 0);
        expect(snapshot(tester).getStickerById(2).quantity, 1);
        // Checkout must not clear favorites.
        await tapKey(tester, 'nav-2');
        expect(find.byKey(const ValueKey('favorite-item-2')), findsOneWidget);
        await tapKey(tester, 'favorite-item-2');
        await tapKey(tester, 'toggle-favorite');
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Empty favorite'), findsOneWidget);

        await tapKey(tester, 'nav-0');
        await tapKey(tester, 'toggle-theme');
        expect(snapshot(tester).light, isFalse);
        expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
            ThemeMode.dark);
        await tapKey(tester, 'nav-3');
        expect(find.text('State management: ${variant.key}'), findsOneWidget);
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        expect(snapshot(tester).light, isTrue);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      });

      testWidgets('search, explicit removal, independent initial state',
          (tester) async {
        await tester.pumpWidget(variant.value());
        await tester.pumpAndSettle();
        expect(snapshot(tester).cart, isEmpty);
        expect(snapshot(tester).favorite, isEmpty);
        expect(snapshot(tester).selectedCategory, StickerType.all);
        await tester.enterText(find.byKey(const ValueKey('search')), ' APP ');
        await tester.pumpAndSettle();
        expect(snapshot(tester).stickersByCategory.single.name, 'Apple');
        await tester.enterText(
            find.byKey(const ValueKey('search')), 'not-a-sticker');
        await tester.pumpAndSettle();
        expect(find.text('No stickers found'), findsOneWidget);
        await tester.enterText(find.byKey(const ValueKey('search')), 'Apple');
        await tester.pumpAndSettle();
        await tapKey(tester, 'sticker-1');
        await tapKey(tester, 'toggle-favorite');
        await tapKey(tester, 'add-to-cart');
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tapKey(tester, 'nav-1');
        await tapKey(tester, 'remove-cart-1');
        expect(find.text('Empty cart'), findsOneWidget);
        await tapKey(tester, 'nav-2');
        await tapKey(tester, 'remove-favorite-1');
        expect(find.text('Empty favorite'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      });
    });
  }
}
