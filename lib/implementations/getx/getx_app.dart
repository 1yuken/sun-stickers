import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

class StickerController extends GetxController {
  final snapshot = StickerState().obs;
  void dispatch(StickerAction action) {
    snapshot.value = reduceStickerState(snapshot.value, action);
  }
}

class GetxApp extends StatelessWidget {
  const GetxApp({super.key});
  @override
  Widget build(BuildContext context) => GetX<StickerController>(
        init: StickerController(),
        global: false,
        builder: (controller) => StickersApp(
          state: controller.snapshot.value,
          dispatch: controller.dispatch,
          manager: 'GetX',
        ),
      );
}
