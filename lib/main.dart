import 'package:early_bird/blocs/alarm_bloc.dart';
import 'package:early_bird/pages/alarm_page.dart';
import 'package:early_bird/blocs/todo_bloc.dart';
import 'package:early_bird/pages/todo_page.dart';
import 'package:early_bird/pages/real_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers : [
        ChangeNotifierProvider<AlarmBloc>.value(
          value: AlarmBloc(),
        ),
        ChangeNotifierProvider<ToDoBloc>.value(
          value: ToDoBloc(),
        ),
      ],
      child : MaterialApp(
        title : 'Early Bird',
        home : MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Early Bird'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder : (context) => AlarmScreen(),
                  ),
                );
              },
              child: const Text('Alarmas'),
            ),
            ElevatedButton (
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder : (context) => ToDoScreen(),
                  ),
                );
              },
              child: const Text('Tareas'),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmScreen extends StatelessWidget {

  void _selectTime(context) async {
    final AlarmBloc alarmBloc = Provider.of<AlarmBloc>(context, listen: false);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      alarmBloc.timeOfDay = newTime;
    }
  }

  Widget build(BuildContext context) {
    final ToDoBloc toDoBloc = Provider.of<ToDoBloc>(context, listen: false);
    final AlarmBloc alarmBloc = Provider.of<AlarmBloc>(context, listen: false);



    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarma'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed:() {
                _selectTime(context);
              },
              child: Text('Elegir hora'),
            ),
            /*
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
            */
            Text('\n\nHora planeada para alarma:'),
            SizedBox(
              height: 30,
              child: AlarmPage(),
            ),
            Text('\n\nHora real:'),
            SizedBox(
              height: 30,
              child: RealPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoScreen extends StatelessWidget {

  Widget build(BuildContext context) {
    final ToDoBloc toDoBloc = Provider.of<ToDoBloc>(context, listen: false);
    final myController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: myController,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
                labelText: 'Nueva tarea...'
                ),
              ),
            ElevatedButton (
              onPressed: () {
                toDoBloc.addTask(myController.text, true);
                myController.text = "";
              },
              child: Text('Agregar')
            ),
            SizedBox(
              height: 400,
              child: ToDoPage()
            )
          ],
        ),
      ),
    );
  }
}