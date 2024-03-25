import 'package:flutter/material.dart';
import 'package:kabadi/models/users.dart';

class Match {
  List<Team> teams;
  DateTime date;
  TimeOfDay time;

  Match({
    required this.teams,
    required this.date,
    required this.time,
  });
}
