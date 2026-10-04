import 'package:flutter/material.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_scope.dart';
import '../../ui_kit/_ui_kit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final scope = StickerScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(AppAsset.profileImage, width: 220),
          const SizedBox(height: 20),
          Text('Hello Sunny!', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 12),
          Text('State management: ${scope.manager}',
              key: const ValueKey('state-manager')),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Dark theme'),
            value: !scope.state.light,
            onChanged: (_) => scope.dispatch(const ToggleTheme()),
          ),
        ]),
      )),
    );
  }
}
