import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmBloc extends ChangeNotifier {
  late SharedPreferences _prefs;
  int persistentHour = 0;
  int persistentMinute = 0;

  AlarmBloc() {
    _loadShared();
  }

  _loadShared () async {
    /* Al iniciarse la aplicacion, leer hora guardada */
    _prefs = await SharedPreferences.getInstance();
    persistentHour = _prefs.getInt('hora') ?? 0;
    persistentMinute = _prefs.getInt('minuto') ?? 0;

    /* Colocar la hora */
    _timeOfDay = TimeOfDay(hour: persistentHour, minute: persistentMinute);

    /* Reportar la hora leída */
    print('hora recuperada ' + _timeOfDay.toString());

    notifyListeners();
  }

  TimeOfDay _timeOfDay = TimeOfDay.now();
  TimeOfDay get timeOfDay => _timeOfDay;
  int get hour => _timeOfDay.hour;
  int get minute => _timeOfDay.minute;

  set timeOfDay (TimeOfDay val) {
    _timeOfDay = val;

    /* Cuando se elige hora, guardarla en prefs */
    _prefs.setInt('hora', val.hour);
    _prefs.setInt('minuto', val.minute);

    notifyListeners();
  }

  TimeOfDay substractMinutesPerTask(int minutes, int tasks) {
    TimeOfDay ext = _timeOfDay;
    ext = ext.plusMinutes(-minutes * tasks);
    return ext;
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay plusMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = this.hour * 60 + this.minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }
}