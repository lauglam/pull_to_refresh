import 'package:example/other/refresh_glowindicator.dart';
import 'package:example/ui/main_activity.dart';
import 'package:example/ui/second_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'ui/indicator/base/indicator_activity.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => const MaterialClassicHeader(),
      footerBuilder: () => const ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      child: MaterialApp(
        title: 'Pulltorefresh Demo',
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: RefreshScrollBehavior(),
            child: child!,
          );
        },
        theme: ThemeData(
            // This is the theme of your application.
            //s
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
            // counter didn't reset back to zero; the application is not restarted.
            primarySwatch: Colors.blue,
            primaryColor: Colors.greenAccent),
        localizationsDelegates: const [
          RefreshLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh'),
          Locale('ja'),
          Locale('uk'),
          Locale('it'),
          Locale('ru'),
          Locale('fr'),
          Locale('es'),
          Locale('nl'),
          Locale('sv'),
          Locale('pt'),
          Locale('ko'),
        ],
        locale: const Locale('zh'),
        localeResolutionCallback: (locale, supportedLocales) {
          //print("change language");
          return locale;
        },
        home: const MainActivity(title: 'Pulltorefresh'),
        routes: {
          "sec": (BuildContext context) {
            return const SecondActivity(
              title: "SecondAct",
            );
          },
          "indicator": (BuildContext context) {
            return const IndicatorActivity(title: 'indicator');
          }
        },
      ),
    );
  }
}
