import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';

class GlobalProvider {
  static MultiBlocProvider create({required MaterialApp materialApp}) {
    return MultiBlocProvider(providers: [
      BlocProvider<AuthBloc>(create: (BuildContext context) {
        return getIt<AuthBloc>();
      })
    ], child: materialApp);
  }
}