import 'package:flutter_test/flutter_test.dart';
import 'package:sun_stickers/data/_data.dart';
import 'package:sun_stickers/states/sticker_action.dart';
import 'package:sun_stickers/states/sticker_state.dart';

void main() {
  test('immutable snapshots and seed data are never changed', () {
    final initial = StickerState();
    final changed = initial
        .onIncreaseQuantityTap(1)
        .onAddToCartTap(1)
        .onAddRemoveFavoriteTap(1);
    expect(initial.getStickerById(1).quantity, 1);
    expect(initial.cart, isEmpty);
    expect(initial.favorite, isEmpty);
    expect(changed.cart.single.quantity, 2);
    expect(changed.favorite.single.quantity, 2);
    expect(AppData.stickers.first.cart, isFalse);
    expect(() => changed.stickers.clear(), throwsUnsupportedError);
    expect(() => changed.cart.clear(), throwsUnsupportedError);
    expect(StickerState().favorite, isEmpty);
  });
  test('every category filters correctly and all restores all 22 stickers', () {
    for (final type in StickerType.values) {
      final state = StickerState().onCategoryTap(type);
      expect(state.categories.where((e) => e.isSelected).single.type, type);
      expect(state.stickersByCategory, isNotEmpty);
      if (type != StickerType.all) {
        expect(state.stickersByCategory.every((e) => e.type == type), isTrue);
      }
    }
    expect(
        StickerState()
            .onCategoryTap(StickerType.toy)
            .onCategoryTap(StickerType.all)
            .stickersByCategory
            .length,
        22);
  });
  test('cart totals, duplicate adds, quantities and favorites stay in sync',
      () {
    final state = StickerState()
        .onAddToCartTap(1)
        .onAddToCartTap(1)
        .onAddToCartTap(2)
        .onIncreaseQuantityTap(2)
        .onAddRemoveFavoriteTap(2);
    expect(state.cart.length, 2);
    expect(state.cartQuantity, 3);
    expect(state.subtotal, 40);
    expect(state.taxes, 5);
    expect(state.total, 45);
    final changed = state.onIncreaseQuantityTap(2);
    expect(changed.cart.last.quantity, 3);
    expect(changed.favorite.single.quantity, 3);
    expect(changed.subtotal, 55);
  });
  test('decrement cannot make quantity less than one', () {
    final state =
        StickerState().onDecreaseQuantityTap(1).onDecreaseQuantityTap(1);
    expect(state.getStickerById(1).quantity, 1);
  });
  test('remove resets only the target quantity and preserves favorite', () {
    final state = StickerState()
        .onAddToCartTap(1)
        .onIncreaseQuantityTap(1)
        .onAddRemoveFavoriteTap(1)
        .onAddToCartTap(2)
        .onIncreaseQuantityTap(2)
        .onRemoveFromCartTap(1);
    expect(state.getStickerById(1).quantity, 1);
    expect(state.favorite.single.id, 1);
    expect(state.cart.single.id, 2);
    expect(state.cart.single.quantity, 2);
  });
  test('checkout resets purchased stickers, preserves others and favorite', () {
    final state = StickerState()
        .onAddToCartTap(1)
        .onIncreaseQuantityTap(1)
        .onAddRemoveFavoriteTap(1)
        .onIncreaseQuantityTap(2)
        .onCheckOutTap();
    expect(state.cart, isEmpty);
    expect(state.subtotal, 0);
    expect(state.taxes, 0);
    expect(state.total, 0);
    expect(state.getStickerById(1).quantity, 1);
    expect(state.getStickerById(2).quantity, 2);
    expect(state.favorite.single.id, 1);
  });
  test('search combines with category and handles case and whitespace', () {
    final state =
        StickerState().onCategoryTap(StickerType.toy).onSearchChanged(' BALL ');
    expect(state.stickersByCategory.map((e) => e.name), ['Ball', 'Balloon']);
    expect(state.onCategoryTap(StickerType.fruit).stickersByCategory, isEmpty);
  });
  test('theme round trip and unknown IDs', () {
    final initial = StickerState();
    expect(initial.toggleTheme().light, isFalse);
    expect(initial.toggleTheme().toggleTheme().light, isTrue);
    expect(() => initial.onAddToCartTap(-1), throwsStateError);
  });
  test('rapid command sequence uses the latest state each time', () {
    var state = StickerState();
    for (var i = 0; i < 100; i++) {
      state = reduceStickerState(state, const IncreaseQuantity(1));
    }
    state = reduceStickerState(state, const AddToCart(1));
    expect(state.cart.single.quantity, 101);
    expect(state.total, 1015);
  });
}
