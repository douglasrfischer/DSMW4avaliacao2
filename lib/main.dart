import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ponto_movel/telas/login.dart';
import 'package:ponto_movel/telas/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJya3h3aGtrbWJzaW51d3V6cHJpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTYxMDUyNTYsImV4cCI6MjAxMTY4MTI1Nn0.eYzNCqaog9b7Wcq4c50DBgAw7E2MK82pYTXcmLZaIKk',
      url: 'https://rrkxwhkkmbsinuwuzpri.supabase.co');
  runApp(const MyApp());

  Supabase.instance.client.auth.signOut();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ponto Móvel',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(3, 80, 166, 1),
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(3, 80, 166, 1),
          ),
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(3, 80, 166, 1))
              )
          
          ),
          outlinedButtonTheme: const OutlinedButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 23)),
              iconSize: MaterialStatePropertyAll(32),
              alignment: Alignment.center,
              minimumSize: MaterialStatePropertyAll(Size(200, 40)),
            iconColor: MaterialStatePropertyAll(Color.fromRGBO(3, 80, 166, 1))
            ),
        )),
        debugShowCheckedModeBanner: true,
        routes: <String, WidgetBuilder>{
          '/login': (context) => const Login(),
          '/home': (context) => const Home(),
        },
        home: const Login());
  }
}
