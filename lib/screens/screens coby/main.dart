import 'package:div/screens/auth/SplashView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../feature/ads/banner_ads.dart';
import '../../feature/map/googl_map.dart';
import '../login/cubit/cubit1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM TOKEN: $token");

  MobileAds.instance.initialize();
  await MobileAds.instance.initialize();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider<LoginCubit>(create: (context) => LoginCubit())],
      child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale("ar")],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: SplashView(),
    );
  }
}
