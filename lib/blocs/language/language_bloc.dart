import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';
import '../../models/language_model.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LoadLanguages>((event, emit) {
      final langs = [
        Language(name: "French", flagImage: "assets/icons/france.png"),
        Language(name: "Spanish", flagImage: "assets/icons/spain.png"),
        Language(name: "Japanese", flagImage: "assets/icons/flag.png"),
         Language(name: "English", flagImage: "assets/icons/united-states.png"),
        Language(name: "Spanish", flagImage: "assets/icons/spain.png"),
        Language(name: "Japanese", flagImage: "assets/icons/flag.png"),
      ];
      emit(LanguageLoaded(langs));
    });
  }
}
