import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/bloc/cubit/counter_cubit.dart';
import 'cubit/counter_states.dart';

// ignore: must_be_immutable
class CounterScreen extends StatelessWidget {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(InitialState),
      child: BlocConsumer<CounterCubit, CounterStates>(
        listener: (context, state) {
          if(state is PlusState) print("Plus State :${state.counter}");
          if(state is MinusState) print("Minus State :${state.counter}");
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey[300],
                        child: TextButton(
                            onPressed: () {
                              CounterCubit.get(context).minusCounter();
                            },
                            child: Icon(
                              Icons.remove,
                              size: 50,
                            )),
                      ),
                      Text(
                        "${CounterCubit.get(context).counter}",
                        style: TextStyle(fontSize: 40),
                      ),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey[300],
                        child: TextButton(
                            onPressed: () {
                              CounterCubit.get(context).plusCounter();
                            },
                            child: Icon(
                              Icons.add,
                              size: 50,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
