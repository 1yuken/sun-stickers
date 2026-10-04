import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

class StickerNotifier extends ChangeNotifier {
  StickerState _state = StickerState();
  StickerState get state => _state;
  void dispatch(StickerAction action) {
    _state = reduceStickerState(_state, action);
    notifyListeners();
  }
}

class ProviderApp extends StatelessWidget {
  const ProviderApp({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => StickerNotifier(),
        child: Consumer<StickerNotifier>(
          builder: (_, notifier, __) => StickersApp(
            state: notifier.state,
            dispatch: notifier.dispatch,
            manager: 'Provider',
          ),
        ),
      );
}
