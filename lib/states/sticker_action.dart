import '../data/_data.dart';
import 'sticker_state.dart';

/// Events for BLoC and actions for Redux; also the common UI command protocol.
sealed class StickerAction {
  const StickerAction();
}

class SelectCategory extends StickerAction {
  const SelectCategory(this.category);
  final StickerType category;
}

class SearchStickers extends StickerAction {
  const SearchStickers(this.query);
  final String query;
}

class IncreaseQuantity extends StickerAction {
  const IncreaseQuantity(this.id);
  final int id;
}

class DecreaseQuantity extends StickerAction {
  const DecreaseQuantity(this.id);
  final int id;
}

class AddToCart extends StickerAction {
  const AddToCart(this.id);
  final int id;
}

class RemoveFromCart extends StickerAction {
  const RemoveFromCart(this.id);
  final int id;
}

class Checkout extends StickerAction {
  const Checkout();
}

class ToggleFavorite extends StickerAction {
  const ToggleFavorite(this.id);
  final int id;
}

class ToggleTheme extends StickerAction {
  const ToggleTheme();
}

/// Pure Dart domain transitions. Each library owns storage, notifications and
/// widget subscriptions; none depends on another state manager.
StickerState reduceStickerState(StickerState state, StickerAction action) =>
    switch (action) {
      SelectCategory(:final category) => state.onCategoryTap(category),
      SearchStickers(:final query) => state.onSearchChanged(query),
      IncreaseQuantity(:final id) => state.onIncreaseQuantityTap(id),
      DecreaseQuantity(:final id) => state.onDecreaseQuantityTap(id),
      AddToCart(:final id) => state.onAddToCartTap(id),
      RemoveFromCart(:final id) => state.onRemoveFromCartTap(id),
      Checkout() => state.onCheckOutTap(),
      ToggleFavorite(:final id) => state.onAddRemoveFavoriteTap(id),
      ToggleTheme() => state.toggleTheme(),
    };
