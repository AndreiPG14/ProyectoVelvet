import 'package:flutter/material.dart';


import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'config/constants/environment.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

Future<void> main() async {
  await Environment.initEnvironment();
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeProvider);
    final appRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
