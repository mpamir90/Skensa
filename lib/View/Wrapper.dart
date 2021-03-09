import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:skensa/View/Guru/HomeViewGuru.dart';
import 'package:skensa/View/HomeView.dart';

import 'package:skensa/View/LoginView.dart';

import 'package:skensa/bloc/hydrateduser_bloc.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    debugPrint((user == null) ? "User : null" : "User : Not Null");

    return MultiBlocProvider(
        providers: [
          BlocProvider<HydrateduserBloc>(
            create: (context) => HydrateduserBloc(),
          ),
        ],
        child: BlocBuilder<HydrateduserBloc, HydrateduserState>(
            builder: (context, state) {
          print("HydrateduserBlocBuilder : Berjalan");
          if (state is OnAddInfoGuruSucceded) {
            print("OnAddInfoGuruSucceded");
            return HomeViewGuru(
                state.guru, BlocProvider.of<HydrateduserBloc>(context));
          }
          if (state is OnAddInfoSiswaSucceded) {
            return HomeView(state.siswa);
          }
          return LoginView(BlocProvider.of<HydrateduserBloc>(context));
        }));
  }
}
