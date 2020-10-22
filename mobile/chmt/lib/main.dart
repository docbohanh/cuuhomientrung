import 'package:chmt/pages/household/household_vm.dart';
import 'package:chmt/pages/rescuer/rescuer_vm.dart';
import 'package:chmt/router/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HouseHoldViewModel()),
        ChangeNotifierProvider(create: (_) => RescuerViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: Routes.splash,
    );
  }
}
