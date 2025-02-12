import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class GlobalBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) {
      developer.log(name: 'CUBIT', change.nextState.toString());
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    developer.log(name: 'BLOC', transition.nextState.toString());
  }
}
