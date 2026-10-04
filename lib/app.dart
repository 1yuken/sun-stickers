import 'package:flutter/material.dart';
import 'states/sticker_action.dart';
import 'states/sticker_scope.dart';
import 'states/sticker_state.dart';
import 'ui/_ui.dart';
import 'ui_kit/_ui_kit.dart';

class StickersApp extends StatelessWidget {
  const StickersApp({
    super.key,
    required this.state,
    required this.dispatch,
    required this.manager,
  });
  final StickerState state;
  final void Function(StickerAction) dispatch;
  final String manager;
  @override
  Widget build(BuildContext context) => StickerScope(
        state: state,
        dispatch: dispatch,
        manager: manager,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sunny Stickers - $manager',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.light ? ThemeMode.light : ThemeMode.dark,
          home: const HomeScreen(),
        ),
      );
}
