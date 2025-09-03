import 'package:equatable/equatable.dart';
import '../../feature/student/data/models/language_model.dart';

abstract class LanguageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final List<Language> languages;
  LanguageLoaded(this.languages);
}
