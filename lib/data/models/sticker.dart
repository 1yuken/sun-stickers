enum StickerType { all, toy, fauna, plant, berry, fruit, other }

class Sticker {
  final int id;
  final String image;
  final String name;
  final double price;
  final int quantity;
  final bool isFavorite;
  final String description;
  final double score;
  final StickerType type;
  final int voter;
  final bool cart;

  const Sticker(
    this.id,
    this.image,
    this.name,
    this.price,
    this.quantity,
    this.isFavorite,
    this.description,
    this.score,
    this.type,
    this.voter,
    this.cart,
  );

  Sticker copyWith({int? quantity, bool? isFavorite, bool? cart}) => Sticker(
        id,
        image,
        name,
        price,
        quantity ?? this.quantity,
        isFavorite ?? this.isFavorite,
        description,
        score,
        type,
        voter,
        cart ?? this.cart,
      );
}
