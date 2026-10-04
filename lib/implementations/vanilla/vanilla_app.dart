import 'package:flutter/material.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

class VanillaApp extends StatefulWidget {
  const VanillaApp({super.key});
  @override
  State<VanillaApp> createState() => _VanillaAppState();
}

class _VanillaAppState extends State<VanillaApp> {
  StickerState _state = StickerState();
  void _dispatch(StickerAction action) {
    setState(() => _state = reduceStickerState(_state, action));
  }

  @override
  Widget build(BuildContext context) => StickersApp(
        state: _state,
        dispatch: _dispatch,
        manager: 'Без библиотек',
      );
}
