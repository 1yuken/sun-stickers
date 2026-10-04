import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

class StickerCubit extends Cubit<StickerState> {
  StickerCubit() : super(StickerState());
  void dispatch(StickerAction action) =>
      emit(reduceStickerState(state, action));
}

class CubitApp extends StatelessWidget {
  const CubitApp({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => StickerCubit(),
        child: BlocBuilder<StickerCubit, StickerState>(
          builder: (context, state) => StickersApp(
            state: state,
            dispatch: context.read<StickerCubit>().dispatch,
            manager: 'Cubit',
          ),
        ),
      );
}
