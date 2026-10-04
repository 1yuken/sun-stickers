import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

StickerState stickerReducer(StickerState state, dynamic action) =>
    action is StickerAction ? reduceStickerState(state, action) : state;

class ReduxApp extends StatefulWidget {
  const ReduxApp({super.key});
  @override
  State<ReduxApp> createState() => _ReduxAppState();
}

class _ReduxAppState extends State<ReduxApp> {
  final _store =
      Store<StickerState>(stickerReducer, initialState: StickerState());
  @override
  void dispose() {
    unawaited(_store.teardown());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoreProvider<StickerState>(
        store: _store,
        child: StoreConnector<StickerState, StickerState>(
          converter: (store) => store.state,
          distinct: true,
          builder: (_, state) => StickersApp(
            state: state,
            dispatch: (action) => _store.dispatch(action),
            manager: 'Redux',
          ),
        ),
      );
}
