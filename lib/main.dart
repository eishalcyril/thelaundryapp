import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_app/Router/app_router.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/global_bloc_observer.dart';
import 'package:laundry_app/theme.dart';
import 'package:laundry_app/usercubit/user_cubit.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<void> main() async {
    await Hive.initFlutter();
  await Hive.openBox('laundry');

  /// For using Custom [BlocObserver] instead of the default BlocObserver.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Bloc.observer = GlobalBlocObserver();
  runApp(MyApp( appRouter: AppRouter(),));
}
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

