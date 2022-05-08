import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

/// A cubit that manages the brightness of the app.
class BrightnessCubit extends Cubit<Brightness> {
  /// Initializes a new [BrightnessCubit].
  BrightnessCubit() : super(Brightness.light);

  /// Toggle the brightness.
  void toggle() {
    if (state == Brightness.light) {
      emit(Brightness.dark);
    } else {
      emit(Brightness.light);
    }
  }
}
