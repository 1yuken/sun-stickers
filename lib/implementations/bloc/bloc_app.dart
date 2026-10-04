import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../states/sticker_action.dart';
import '../../states/sticker_state.dart';

class StickerBloc extends Bloc<StickerAction, StickerState> {
  StickerBloc() : super(StickerState()) {
    on<StickerAction>((event, emit) => emit(reduceStickerState(state, event)));
  }
}

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => StickerBloc(),
        child: BlocBuilder<StickerBloc, StickerState>(
          builder: (context, state) => StickersApp(
            state: state,
            dispatch: context.read<StickerBloc>().add,
            manager: 'BLoC',
          ),
        ),
      );
}
