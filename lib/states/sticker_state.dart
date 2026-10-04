import '../data/_data.dart';

/// Immutable snapshot shared by the eight state management implementations.
/// Derived lists always read the latest stickers, including quantity changes.
class StickerState {
  StickerState({
    List<Sticker>? stickers,
    this.selectedCategory = StickerType.all,
    this.light = true,
    this.searchQuery = '',
  }) : stickers = List.unmodifiable(stickers ?? AppData.stickers);

  final List<Sticker> stickers;
  final StickerType selectedCategory;
  final bool light;
  final String searchQuery;

  List<StickerCategory> get categories => List.unmodifiable(
        AppData.categories.map(
          (e) => e.copyWith(isSelected: e.type == selectedCategory),
        ),
      );
  List<Sticker> get stickersByCategory => List.unmodifiable(stickers.where(
        (e) =>
            (selectedCategory == StickerType.all ||
                e.type == selectedCategory) &&
            e.name.toLowerCase().contains(searchQuery.trim().toLowerCase()),
      ));
  List<Sticker> get cart => List.unmodifiable(stickers.where((e) => e.cart));
  List<Sticker> get favorite =>
      List.unmodifiable(stickers.where((e) => e.isFavorite));
  Sticker getStickerById(int id) => stickers.firstWhere((e) => e.id == id);
  String stickerPrice(Sticker sticker) =>
      (sticker.quantity * sticker.price).toStringAsFixed(2);
  double get subtotal => cart.fold(0, (sum, e) => sum + e.price * e.quantity);
  // The tutorial uses a fixed $5 tax. An empty cart has no payable total.
  double get taxes => cart.isEmpty ? 0 : 5;
  double get total => subtotal + taxes;
  int get cartQuantity => cart.fold(0, (sum, e) => sum + e.quantity);

  StickerState copyWith({
    List<Sticker>? stickers,
    StickerType? selectedCategory,
    bool? light,
    String? searchQuery,
  }) =>
      StickerState(
        stickers: stickers ?? this.stickers,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        light: light ?? this.light,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  StickerState onCategoryTap(StickerType category) =>
      copyWith(selectedCategory: category);
  StickerState onSearchChanged(String query) => copyWith(searchQuery: query);
  StickerState onIncreaseQuantityTap(int id) =>
      _update(id, (e) => e.copyWith(quantity: e.quantity + 1));
  StickerState onDecreaseQuantityTap(int id) => _update(
        id,
        (e) => e.quantity <= 1 ? e : e.copyWith(quantity: e.quantity - 1),
      );
  StickerState onAddToCartTap(int id) =>
      _update(id, (e) => e.copyWith(cart: true));
  StickerState onRemoveFromCartTap(int id) =>
      _update(id, (e) => e.copyWith(cart: false, quantity: 1));
  StickerState onCheckOutTap() => copyWith(
        stickers: stickers
            .map((e) => e.cart ? e.copyWith(cart: false, quantity: 1) : e)
            .toList(),
      );
  StickerState onAddRemoveFavoriteTap(int id) =>
      _update(id, (e) => e.copyWith(isFavorite: !e.isFavorite));
  StickerState toggleTheme() => copyWith(light: !light);

  StickerState _update(int id, Sticker Function(Sticker) change) {
    getStickerById(id); // Reject an unknown ID rather than silently succeeding.
    return copyWith(
      stickers: stickers.map((e) => e.id == id ? change(e) : e).toList(),
    );
  }
}
