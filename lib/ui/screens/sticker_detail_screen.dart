import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_scope.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class StickerDetail extends StatelessWidget {
  const StickerDetail({super.key, required this.stickerId});
  final int stickerId;
  @override
  Widget build(BuildContext context) {
    final scope = StickerScope.of(context);
    // Resolve by ID on every rebuild, so routes never hold an obsolete copy.
    final sticker = scope.state.getStickerById(stickerId);
    return Scaffold(
      appBar:
          AppBar(title: Text(sticker.name, key: const ValueKey('detail-name'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(sticker.image,
                    height: 240, fit: BoxFit.contain)),
            const SizedBox(height: 20),
            Row(children: [
              RatingBarIndicator(
                rating: sticker.score,
                itemBuilder: (_, __) =>
                    const Icon(Icons.star, color: AppColor.yellow),
                itemCount: 5,
                itemSize: 20,
              ),
              const SizedBox(width: 12),
              Text('${sticker.score} (${sticker.voter})',
                  style: Theme.of(context).textTheme.titleMedium),
            ]),
            const SizedBox(height: 20),
            Text('Description',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 12),
            Text(sticker.description,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.dark
                : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('\$${scope.state.stickerPrice(sticker)}',
                    key: const ValueKey('detail-price'),
                    style:
                        AppTextStyle.h1Style.copyWith(color: AppColor.accent)),
                CounterButton(
                  onIncrementTap: () =>
                      scope.dispatch(IncreaseQuantity(stickerId)),
                  onDecrementTap: () =>
                      scope.dispatch(DecreaseQuantity(stickerId)),
                  label: Text('${sticker.quantity}',
                      key: const ValueKey('detail-quantity'),
                      style: Theme.of(context).textTheme.displayLarge),
                ),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    key: const ValueKey('add-to-cart'),
                    onPressed: sticker.cart
                        ? null
                        : () => scope.dispatch(AddToCart(stickerId)),
                    child: Text(sticker.cart ? 'Added to cart' : 'Add to cart'),
                  ),
                )),
                const SizedBox(width: 16),
                IconButton(
                  key: const ValueKey('toggle-favorite'),
                  tooltip: sticker.isFavorite
                      ? 'Remove from favorite'
                      : 'Add to favorite',
                  onPressed: () => scope.dispatch(ToggleFavorite(stickerId)),
                  icon: Icon(
                      sticker.isFavorite
                          ? AppIcon.heart
                          : AppIcon.outlinedHeart,
                      color: AppColor.accent),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
