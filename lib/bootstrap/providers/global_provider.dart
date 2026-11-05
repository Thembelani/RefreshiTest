import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/delivery_times/delivery_times_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/order_summary/order_summary_bloc.dart';

class GlobalProvider {
  static MultiBlocProvider create({required MaterialApp materialApp}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
        BlocProvider<CatalogItemsBloc>.value(value: getIt<CatalogItemsBloc>()),
        BlocProvider<CartBloc>.value(value: getIt<CartBloc>()),
        BlocProvider<DeliveryTimesBloc>.value(
          value: getIt<DeliveryTimesBloc>(),
        ),
        BlocProvider<OrderSummaryBloc>.value(value: getIt<OrderSummaryBloc>()),
      ],
      child: materialApp,
    );
  }
}
