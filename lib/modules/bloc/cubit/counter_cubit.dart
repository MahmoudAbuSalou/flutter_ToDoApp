import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/bloc/cubit/counter_states.dart';

class CounterCubit extends Cubit<CounterStates> {
  CounterCubit(initialState) : super(InitialState());
  int counter = 0;

  static CounterCubit get(context) => BlocProvider.of(context);

  void plusCounter() {
    counter++;
    emit(PlusState(counter));
  }

  void minusCounter() {
    counter--;
    emit(MinusState(counter));
  }
}
