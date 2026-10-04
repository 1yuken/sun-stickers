import '_models.dart';

class StickerCategory {
  final StickerType type;
  final bool isSelected;

  const StickerCategory(this.type, this.isSelected);

  StickerCategory copyWith({bool? isSelected}) =>
      StickerCategory(type, isSelected ?? this.isSelected);
}
