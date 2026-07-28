import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'core/core.dart';
import 'features/auth/auth.dart';

class MyFFSCApp extends StatelessWidget {
  const MyFFSCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(CheckAuthEvent()),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return const AppRouterApp();
        },
      ),
    );
  }
}

class AppRouterApp extends StatefulWidget {
  const AppRouterApp({super.key});

  @override
  State<AppRouterApp> createState() => _AppRouterAppState();
}

class _AppRouterAppState extends State<AppRouterApp> {
  late final RoutesConfig _routesConfig;

  @override
  void initState() {
    super.initState();
    _routesConfig = RoutesConfig(authBloc: context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My FFSC 💙☀️',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _routesConfig.router,
    );
  }
}
