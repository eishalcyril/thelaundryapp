import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_app/Router/app_router.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/enums/user_type_enum.dart';
import 'package:laundry_app/global_bloc_observer.dart';
import 'package:laundry_app/theme.dart';
import 'package:laundry_app/usercubit/user_cubit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/firebase_options.dart';
import 'package:laundry_app/enums/consumer_enum.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('laundry');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SystemUiOverlay(
    child: MyApp(
      appRouter: AppRouter(),
    ),
  ));
}

Future<void> initializeApp() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully');

    await NewApiService().requestNotificationPermissions();

    final fcmToken = await NewApiService().getFCMToken();
    log('FCM Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received a message in the foreground: ${message.notification?.title}");
      // Handle the message, e.g., show a local notification or update the UI
    });
  } catch (e) {
    log('Error initializing Firebase: $e');
  }
}

Future<void> initializeAppWithRole(int userRole) async {
  try {
    await initializeApp();
    if (userRole == 1) {
      await NewApiService().subscribeToAdminNotifications();
    } else if (userRole == 0) {
      await NewApiService().subscribeToCustomerNotifications();
    }
  } catch (e) {}
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("Received a message in the background: ${message.notification?.title}");
  // Handle the message in the background if needed
}

class SystemUiOverlay extends StatelessWidget {
  final Widget child;

  const SystemUiOverlay({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey,
      statusBarIconBrightness: Brightness.dark,
    ));

    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.appRouter,
  });
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserCubit()),
        ],
        child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayWidgetBuilder: (_) {
            return Center(
              child: SpinKitCircle(
                color: primaryShadeDark,
                size: 90.0,
              ),
            );
          },
          overlayColor: Colors.transparent,
          duration: const Duration(milliseconds: 1000),
          child: GetMaterialApp(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scaleFactor)),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            theme: myTheme,
            onGenerateRoute: appRouter.onGenerateRoute,
          ),
        ));
  }
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
