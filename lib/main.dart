import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/providers/global_provider.dart';
import 'package:refreshi_test/bootstrap/router/app_router.dart';
import 'package:refreshi_test/bootstrap/theme/app_theme.dart';
import 'package:refreshi_test/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const RefreshiApp());
}

class RefreshiApp extends StatefulWidget {
  const RefreshiApp({super.key});

  @override
  State<RefreshiApp> createState() => _RefreshiAppState();
}

class _RefreshiAppState extends State<RefreshiApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return GlobalProvider.create(
      materialApp: MaterialApp.router(
        title: 'Refreshi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
