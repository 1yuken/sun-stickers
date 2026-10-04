import 'package:flutter/material.dart';
import '../../data/_data.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_scope.dart';
import '../../ui_kit/_ui_kit.dart';
import '../_ui.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final scope = StickerScope.of(context);
    final state = scope.state;
    return Scaffold(
      appBar: AppBar(
          title: Text('Cart screen',
              style: Theme.of(context).textTheme.displayMedium)),
      body: EmptyWrapper(
        title: 'Empty cart',
        isEmpty: state.cart.isEmpty,
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: state.cart.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (_, index) {
            final sticker = state.cart[index];
            return Dismissible(
              key: ValueKey('cart-item-${sticker.id}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => scope.dispatch(RemoveFromCart(sticker.id)),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                color: Colors.redAccent,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: _CartItem(sticker: sticker),
            );
          },
        ),
      ),
      bottomNavigationBar: state.cart.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.dark
                      : Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _AmountRow(
                      label: 'Subtotal',
                      amount: state.subtotal,
                      valueKey: 'subtotal'),
                  const SizedBox(height: 12),
                  _AmountRow(
                      label: 'Taxes', amount: state.taxes, valueKey: 'taxes'),
                  const Divider(height: 30, thickness: 2),
                  _AmountRow(
                      label: 'Total', amount: state.total, valueKey: 'total'),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        key: const ValueKey('checkout'),
                        onPressed: () {
                          scope.dispatch(const Checkout());
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Checkout complete')));
                        },
                        child: const Text('Checkout'),
                      )),
                ]),
              ),
            ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({required this.sticker});
  final Sticker sticker;
  @override
  Widget build(BuildContext context) {
    final scope = StickerScope.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.dark
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(children: [
        Image.asset(sticker.image, width: 45, height: 60, fit: BoxFit.contain),
        const SizedBox(width: 12),
        Expanded(
            child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => StickerDetail(stickerId: sticker.id))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sticker.name,
                style: Theme.of(context).textTheme.displayMedium),
            Text('\$${sticker.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall),
            IconButton(
              key: ValueKey('remove-cart-${sticker.id}'),
              tooltip: 'Remove from cart',
              onPressed: () => scope.dispatch(RemoveFromCart(sticker.id)),
              icon: const Icon(Icons.delete_outline),
            ),
          ]),
        )),
        Column(children: [
          CounterButton(
            onIncrementTap: () => scope.dispatch(IncreaseQuantity(sticker.id)),
            onDecrementTap: () => scope.dispatch(DecreaseQuantity(sticker.id)),
            size: const Size(28, 28),
            padding: 8,
            label: Text('${sticker.quantity}',
                key: ValueKey('cart-quantity-${sticker.id}'),
                style: Theme.of(context).textTheme.displayMedium),
          ),
          Text('\$${scope.state.stickerPrice(sticker)}',
              key: ValueKey('cart-price-${sticker.id}'),
              style: AppTextStyle.h2Style.copyWith(color: AppColor.accent)),
        ]),
      ]),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow(
      {required this.label, required this.amount, required this.valueKey});
  final String label;
  final double amount;
  final String valueKey;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.headlineSmall),
          Text('\$${amount.toStringAsFixed(2)}',
              key: ValueKey(valueKey),
              style: Theme.of(context).textTheme.displayMedium),
        ],
      );
}
