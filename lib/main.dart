import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:laboratorio_3/firebase_options.dart';
import 'package:laboratorio_3/pages/splash_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [ //intenacionalizacion de la app, que lenguajes maneja la app
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const[
        Locale("es", "CO"), // Lenguaje español colombia
        Locale("en","US"),
      ],
      theme: ThemeData(
        //useMaterial3: true,
        //brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const SplashPage(),
    );
  }
}
