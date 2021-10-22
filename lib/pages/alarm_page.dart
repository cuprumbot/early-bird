import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:early_bird/blocs/alarm_bloc.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlarmBloc alarmBloc = Provider.of<AlarmBloc>(context);

    return Scaffold (
      body : Center(
        child : Text(
          (alarmBloc.hour < 10 ? "0" : "") + alarmBloc.hour.toString() + ":" + (alarmBloc.minute < 10 ? "0" : "") + alarmBloc.minute.toString(),
          textScaleFactor: 2.0,
        ),
      ),
    );
  }
}