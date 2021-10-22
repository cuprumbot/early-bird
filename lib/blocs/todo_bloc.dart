import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoBloc extends ChangeNotifier {
  late SharedPreferences _prefs;
  List<String> persistPendientes = [];
  List<String> persistCompletas = [];

  ToDoBloc() {
    _loadShared();
  }

  _loadShared () async {
    /* Al iniciarse la aplicacion, leer tareas guardadas */
    _prefs = await SharedPreferences.getInstance();
    persistPendientes = _prefs.getStringList('pendientes') ?? [];
    persistCompletas = _prefs.getStringList('completas') ?? [];

    /* Usar listas para llenar tasks */
    for(String p in persistPendientes) {
      tasks.add(Task(p, true));
    }
    for(String c in persistCompletas) {
      tasks.add(Task(c, false));
    }

    /* Reportar tareas recuperadas */
    print('tareas pendientes recuperadas: ${persistPendientes.length}');
    print('tareas completas recuperadas: ${persistCompletas.length}');

    notifyListeners();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  storeAgainInPrefs() {
    List<String> pend = [];
    List<String> comp = [];

    for (Task t in tasks) {
      if (t.pending) {
        pend.add(t.taskText);
      } else {
        comp.add(t.taskText);
      }
    }

    _prefs.setStringList('pendientes', pend);
    _prefs.setStringList('completas', comp);
  }

  addTask(String text, bool pend) {
    _tasks.add(Task(text, pend));
    notifyListeners();

    storeAgainInPrefs();
  }

  switchState(int index) {
    _tasks[index].pending = !_tasks[index].pending;
    notifyListeners();

    storeAgainInPrefs();
  }

  removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();

    storeAgainInPrefs();
  }

  int countPendingTasks() {
    int count = 0;
    for (Task t in tasks) {
      if (t.pending) {
        count++;
      }
    }
    return count;
  }
}

class Task {
  String taskText = "";
  bool pending = false;

  Task(String text, bool pend) {
    taskText = text;
    pending = pend;
  }
}