import 'dart:developer';
import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver{
  @override
  void onCreate(BlocBase bloc){
    super.onCreate(bloc);
    log('onCreate -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onEvent -- bloc: ${bloc.runtimeType}, event: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('onEvent -- bloc: ${bloc.runtimeType}, event: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onEvent -- bloc: ${bloc.runtimeType}, event: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onEvent -- bloc: ${bloc.runtimeType}');
  }
} 