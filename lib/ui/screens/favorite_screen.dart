import 'package:flutter/material.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_scope.dart';
import '../../ui_kit/_ui_kit.dart';
import '../_ui.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final scope = StickerScope.of(context);
    final items = scope.state.favorite;
    return Scaffold(
      appBar: AppBar(
          title: Text('Favorite screen',
              style: Theme.of(context).textTheme.displayMedium)),
      body: EmptyWrapper(
        type: EmptyWrapperType.favorite,
        title: 'Empty favorite',
        isEmpty: items.isEmpty,
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (_, index) {
            final sticker = items[index];
            return Card(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : AppColor.dark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                key: ValueKey('favorite-item-${sticker.id}'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => StickerDetail(stickerId: sticker.id))),
                title: Text(sticker.name,
                    style: Theme.of(context).textTheme.headlineMedium),
                leading:
                    Image.asset(sticker.image, width: 45, fit: BoxFit.contain),
                subtitle: Text(sticker.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge),
                trailing: IconButton(
                  key: ValueKey('remove-favorite-${sticker.id}'),
                  tooltip: 'Remove from favorite',
                  onPressed: () => scope.dispatch(ToggleFavorite(sticker.id)),
                  icon: const Icon(AppIcon.heart, color: Colors.redAccent),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
