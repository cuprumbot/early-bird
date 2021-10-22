import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:early_bird/blocs/alarm_bloc.dart';
import 'package:early_bird/blocs/todo_bloc.dart';

class RealPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlarmBloc alarmBloc = Provider.of<AlarmBloc>(context);
    final ToDoBloc toDoBloc = Provider.of<ToDoBloc>(context);

    int tasks = toDoBloc.countPendingTasks();
    TimeOfDay real = alarmBloc.substractMinutesPerTask(15, tasks);

    return Scaffold (
      body : Center(
        child : Text(
          (real.hour < 10 ? "0" : "") + real.hour.toString() + ":" + (real.minute < 10 ? "0" : "") + real.minute.toString(),
          textScaleFactor: 2.0,
        ),
      ),
    );
  }
}