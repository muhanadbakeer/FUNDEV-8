import 'package:div/screens/auth/SplashView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../login/cubit/cubit1.dart';
import '../notes/notes_screen.dart';

// ✅ لازم يكون Top-level
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // هون تقدر تسجل أو تخزن notification data
  debugPrint("BG Message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // ✅ Firebase
  await Firebase.initializeApp();

  // ✅ Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Request permission + token
  await FirebaseMessaging.instance.requestPermission();
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("FCM TOKEN: $token");

  // ✅ Ads (مرة وحدة فقط)
  await MobileAds.instance.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('ar'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('tr'),
        Locale('ru'),
        Locale('zh'),
        Locale('ja'),
        Locale('ko'),
        Locale('pt'),
        Locale('id'),
        Locale('ms'),
        Locale('hi'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      // optional: startLocale: Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DIV للتغذية",
      debugShowCheckedModeBanner: false,

      // ✅ EasyLocalization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
      ),

      home: NotesScreen(),
    );
  }
}
