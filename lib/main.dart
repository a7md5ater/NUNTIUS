import 'dart:io';

import 'package:chat/services/agora/agora_server.dart';
import 'package:chat/cubit/login/login_cubit.dart';
import 'package:chat/services/notifications/api.dart';
import 'package:chat/screens/home/home_screen.dart';
import 'package:chat/screens/login/login_screen.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/themes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'cubit/app/app_cubit.dart';
import 'cubit/app/app_states.dart';
import 'cubit/app/bloc_observer.dart';
import 'firebase_options.dart';
import 'services/notifications/local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // Get.to(()=>const ContactsScreen());
  debugPrint("Handling a background message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  DioHelper.init();
  AgoraServer.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  final String defaultLocale = Platform.localeName.substring(0, 2);
  defaultLang = defaultLocale;
  lang = GetStorage().read('lang') ?? (defaultLang == 'ar' ? 'ar' : 'en');
  uId = GetStorage().read('uId') ?? "";
  contactsPermission = GetStorage().read('contactsPermission') ?? false;
  Widget? homeWidget;
  debugPrint("============>${uId!}");
  if (uId!.isNotEmpty) {
    homeWidget = const HomeScreen();
  } else {
    homeWidget = const LoginScreen();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("======>$token");

  NotificationsHelper.init();

  BlocOverrides.runZoned(
    () {
      runApp(MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) => AppCubit()
                ..getContacts()
                ..getUserData(isOpening: true, updateInCall: true),
            ),
            BlocProvider(
              create: (BuildContext context) => LoginCubit(),
            ),
          ],
          child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MyApp(
                homeWidget: homeWidget!,
                cubit: AppCubit.get(context),
              );
            },
          )));
    },
    blocObserver: MyBlocObserver(),
  );

  // runApp(DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(homeWidget: homeWidget!,), // Wrap your app
  //   ));
}

class MyApp extends StatefulWidget {
  final Widget homeWidget;
  final AppCubit cubit;
  const MyApp({Key? key, required this.homeWidget, required this.cubit})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationsHelper.configureDidReceiveLocalNotificationSubject(context);
    NotificationsHelper.configureSelectNotificationSubject(widget.cubit);
  }

  @override
  void dispose() {
    NotificationsHelper.didReceiveLocalNotificationSubject.close();
    NotificationsHelper.selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          builder: DevicePreview.appBuilder,
          theme: darkTheme,
          home: Sizer(
            builder: (context, orientation, screenType) {
              return widget.homeWidget;
              return LoginScreen();
            },
          ),
        );
      },
    );
  }
}
