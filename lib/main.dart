import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:provider/provider.dart';
import 'package:skensa/Services/AuthService.dart';

import 'package:skensa/View/Wrapper.dart';

import 'Hive Databases/HiveDb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build();
  await Firebase.initializeApp();
  await HiveDb.hiveInit();
  runApp(SkensaApp());
}

class SkensaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SKENSA",
      home: StreamProvider(
          create: (BuildContext context) => AuthService.userNotify,
          child: Wrapper()),
    );
  }
}
