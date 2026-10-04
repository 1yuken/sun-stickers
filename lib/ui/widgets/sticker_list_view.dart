import 'package:flutter/material.dart';
import '../../data/_data.dart';
import '../../ui_kit/_ui_kit.dart';
import '../_ui.dart';

class StickerListView extends StatelessWidget {
  const StickerListView(
      {super.key, required this.stickers, this.isReversed = false});
  final List<Sticker> stickers;
  final bool isReversed;
  @override
  Widget build(BuildContext context) {
    final items = isReversed ? stickers.reversed.toList() : stickers;
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 25),
        itemBuilder: (_, index) {
          final sticker = items[index];
          return Semantics(
            button: true,
            label: 'Open ${sticker.name}',
            child: InkWell(
              key: ValueKey('sticker-${sticker.id}'),
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => StickerDetail(stickerId: sticker.id),
              )),
              child: Container(
                width: 160,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.dark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(sticker.image,
                        height: 100, width: 100, fit: BoxFit.contain),
                    Text('\$${sticker.price.toStringAsFixed(2)}',
                        style: AppTextStyle.h3Style
                            .copyWith(color: AppColor.accent)),
                    Text(sticker.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
