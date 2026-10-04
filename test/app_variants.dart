import 'package:flutter/widgets.dart';
import 'package:sun_stickers/implementations/vanilla/vanilla_app.dart';
import 'package:sun_stickers/implementations/getx/getx_app.dart';
import 'package:sun_stickers/implementations/bloc/bloc_app.dart';
import 'package:sun_stickers/implementations/cubit/cubit_app.dart';
import 'package:sun_stickers/implementations/mobx/mobx_app.dart';
import 'package:sun_stickers/implementations/redux/redux_app.dart';
import 'package:sun_stickers/implementations/provider/provider_app.dart';
import 'package:sun_stickers/implementations/riverpod/riverpod_app.dart';

final appVariants = <String, Widget Function()>{
  'Без библиотек': () => const VanillaApp(),
  'GetX': () => const GetxApp(),
  'BLoC': () => const BlocApp(),
  'Cubit': () => const CubitApp(),
  'MobX': () => const MobxApp(),
  'Redux': () => const ReduxApp(),
  'Provider': () => const ProviderApp(),
  'Riverpod': () => const RiverpodApp(),
};
