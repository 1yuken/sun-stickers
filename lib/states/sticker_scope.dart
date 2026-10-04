import 'package:flutter/widgets.dart';
import 'sticker_action.dart';
import 'sticker_state.dart';

/// Passes each library's snapshot to common screens, including Navigator routes.
/// This widget stores no state and runs no business logic.
class StickerScope extends InheritedWidget {
  const StickerScope({
    super.key,
    required this.state,
    required this.dispatch,
    required this.manager,
    required super.child,
  });
  final StickerState state;
  final void Function(StickerAction) dispatch;
  final String manager;
  static StickerScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StickerScope>()!;
  @override
  bool updateShouldNotify(StickerScope oldWidget) =>
      state != oldWidget.state || manager != oldWidget.manager;
}
