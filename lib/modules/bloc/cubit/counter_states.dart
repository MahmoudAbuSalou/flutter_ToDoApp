abstract class CounterStates {}

class InitialState extends CounterStates {}

class PlusState extends CounterStates {
  final int counter;

  PlusState(this.counter);
}

class MinusState extends CounterStates {
  final int counter;

  MinusState(this.counter);
}
