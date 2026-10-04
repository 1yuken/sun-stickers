import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

/// Explicit MobX Observable/Action API; no generated files are needed.
class StickerStore {
  final snapshot = Observable(StickerState(), name: 'StickerStore.snapshot');
  void dispatch(StickerAction action) => runInAction(
        () => snapshot.value = reduceStickerState(snapshot.value, action),
        name: 'StickerStore.dispatch',
      );
}

class MobxApp extends StatefulWidget {
  const MobxApp({super.key});
  @override
  State<MobxApp> createState() => _MobxAppState();
}

class _MobxAppState extends State<MobxApp> {
  final _store = StickerStore();
  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) => StickersApp(
          state: _store.snapshot.value,
          dispatch: _store.dispatch,
          manager: 'MobX',
        ),
      );
}
