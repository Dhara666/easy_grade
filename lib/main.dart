
import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/pages/splash_page/splash_page.dart';
import 'package:easy_grade/provider/community_provider.dart';
import 'package:easy_grade/provider/dashboard_provider.dart';
import 'package:easy_grade/provider/help_center_provider.dart';
import 'package:easy_grade/provider/notification_provider.dart';
import 'package:easy_grade/provider/profile_provider.dart';
import 'package:easy_grade/provider/signin_provider.dart';
import 'package:easy_grade/provider/signup_provider.dart';
import 'package:easy_grade/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'generated/l10n.dart';
import 'provider/course_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constant/color_constant.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initializeNotification();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Locale? locale;
    List<SingleChildWidget> providers = [
      ChangeNotifierProvider<SignUpProvider>(
          create: (context) => SignUpProvider()),
      ChangeNotifierProvider<SignInProvider>(
          create: (context) => SignInProvider()),
      ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider()),
      ChangeNotifierProvider<CourseProvider>(
          create: (context) => CourseProvider()),
      ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider()),
      ChangeNotifierProvider<DashBoardProvider>(
          create: (context) => DashBoardProvider()),
      ChangeNotifierProvider<CommunityProvider>(
          create: (context) => CommunityProvider()),
      ChangeNotifierProvider<HelpCenterProvider>(
          create: (context) => HelpCenterProvider()),
    ];
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Easy Grade',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: AppAsset.defaultFont),
        home: const SplashPage(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: locale,
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}




