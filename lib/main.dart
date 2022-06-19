import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'app.dart';

Future<void> main() async {
  await initHiveForFlutter();
  runApp(const App());
}
