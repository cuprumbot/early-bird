import 'package:early_bird/blocs/alarm_bloc.dart';
import 'package:early_bird/pages/alarm_page.dart';
import 'package:early_bird/blocs/todo_bloc.dart';
import 'package:early_bird/pages/todo_page.dart';
import 'package:early_bird/pages/real_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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
    final ToDoBloc toDoBloc = Provider.of<ToDoBloc>(context, listen: false);

    AndroidAlarmManager.initialize();

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      alarmBloc.timeOfDay = newTime;

      /*
      await AndroidAlarmManager.oneShot(
          const Duration(seconds: 5),
          123,
          alarmCallback,
          alarmClock: true,
          allowWhileIdle: true,
          wakeup: true
      );
      */

      int tasks = toDoBloc.countPendingTasks();
      TimeOfDay real = alarmBloc.substractMinutesPerTask(15, tasks);

      DateTime now = DateTime.now();
      DateTime alarmTime = DateTime(now.year, now.month, now.day, real.hour, real.minute);

      if ( (real.hour < now.hour) || (real.hour == now.hour && real.minute < now.minute) ) {
        // Si la hora de la alarma es menor
        // O si empatan las horas, comparar minutos
        // --> La alarma es mañana

        alarmTime = alarmTime.add(const Duration(days: 1));
      }

      await AndroidAlarmManager.oneShotAt(
        alarmTime,
        123,
        alarmCallback,
        alarmClock: true,
        allowWhileIdle: true,
        wakeup: true
      );

      print('Alarma colocada');
      print(alarmTime.toString());
    }
  }

  static Future<void> alarmCallback() async {
    print('ALARMA DISPARADA');

    /*
      Se debe cerrar la aplicación para silenciar el audio
      Si la aplicación está cerrada, debe abrirse y luego cerrarse
    */

    FlutterRingtonePlayer.playAlarm();
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
            Text('\n\nHora planeada para alarma:'),
            SizedBox(
              height: 30,
              child: AlarmPage(),
            ),
            Text('\n\nHora real en que sonará:'),
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