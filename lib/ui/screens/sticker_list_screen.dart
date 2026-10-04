import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_scope.dart';
import '../../ui_kit/_ui_kit.dart';
import '../_ui.dart';

class StickerList extends StatelessWidget {
  const StickerList({super.key});
  @override
  Widget build(BuildContext context) {
    final scope = StickerScope.of(context);
    final state = scope.state;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('toggle-theme'),
          tooltip: 'Toggle theme',
          icon: const FaIcon(FontAwesomeIcons.dice),
          onPressed: () => scope.dispatch(const ToggleTheme()),
        ),
        title: Text('Sunny Stickers',
            style: Theme.of(context).textTheme.displayMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
                child: Text('Cart: ${state.cartQuantity}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    key: const ValueKey('cart-badge'))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Morning, Sunny',
                style: Theme.of(context).textTheme.headlineSmall),
            Text('What sticker do you want\nto buy today',
                style: Theme.of(context).textTheme.displayLarge),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                key: const ValueKey('search'),
                onChanged: (query) => scope.dispatch(SearchStickers(query)),
                decoration: const InputDecoration(
                  hintText: 'Search sticker',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            Text('Available for you',
                style: Theme.of(context).textTheme.displaySmall),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (_, index) {
                    final category = state.categories[index];
                    return TextButton(
                      key: ValueKey('category-${category.type.name}'),
                      style: TextButton.styleFrom(
                        backgroundColor: category.isSelected
                            ? AppColor.accent
                            : Colors.transparent,
                        foregroundColor: category.isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.headlineMedium?.color,
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () =>
                          scope.dispatch(SelectCategory(category.type)),
                      child: Text(category.type.name.firstCapital),
                    );
                  },
                ),
              ),
            ),
            if (state.stickersByCategory.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(24), child: Text('No stickers found'))
            else ...[
              StickerListView(stickers: state.stickersByCategory),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 5),
                child: Text('Best stickers of the week',
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              StickerListView(
                  stickers: state.stickersByCategory, isReversed: true),
            ],
          ],
        ),
      ),
    );
  }
}
