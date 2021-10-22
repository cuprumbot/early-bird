import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:early_bird/blocs/todo_bloc.dart';

class ToDoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ToDoBloc toDoBloc = Provider.of<ToDoBloc>(context);

    return Scaffold (
      body : Center(
        child : ListView.builder(
          itemCount: toDoBloc.tasks.length,
          reverse: false,
          itemBuilder: (BuildContext context, int index) {
            final entry = toDoBloc.tasks[index];
            return ListTile(
              leading:
                Text(entry.taskText),
              trailing:
                Icon(entry.pending ? Icons.check_box_outline_blank : Icons.check_box),
              onTap: () {
                toDoBloc.switchState(index);
              },
              onLongPress: () {
                toDoBloc.removeTask(index);
              },
            );
          },
        ),
      ),
    );
  }
}