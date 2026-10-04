import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

final stickerProvider = NotifierProvider<StickerNotifier, StickerState>(
  StickerNotifier.new,
);

class StickerNotifier extends Notifier<StickerState> {
  @override
  StickerState build() => StickerState();
  void dispatch(StickerAction action) =>
      state = reduceStickerState(state, action);
}

class RiverpodApp extends StatelessWidget {
  const RiverpodApp({super.key});
  @override
  Widget build(BuildContext context) =>
      const ProviderScope(child: _RiverpodView());
}

class _RiverpodView extends ConsumerWidget {
  const _RiverpodView();
  @override
  Widget build(BuildContext context, WidgetRef ref) => StickersApp(
        state: ref.watch(stickerProvider),
        dispatch: ref.read(stickerProvider.notifier).dispatch,
        manager: 'Riverpod',
      );
}
