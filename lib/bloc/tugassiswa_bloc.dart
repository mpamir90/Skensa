import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tugassiswa_event.dart';
part 'tugassiswa_state.dart';

class TugassiswaBloc extends Bloc<TugassiswaEvent, TugassiswaState> {
  TugassiswaBloc() : super(TugassiswaInitial());

  @override
  Stream<TugassiswaState> mapEventToState(
    TugassiswaEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
