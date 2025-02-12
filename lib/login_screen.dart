// import 'package:caritas_hospital/user/login/components/sos.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:laundry_app/components/button_content.dart';
import 'package:laundry_app/config.dart';
// import 'package:caritas_hospital/common/widgets.dart';

import 'package:laundry_app/usercubit/user_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Box box = Hive.box('laundry');
  final CarouselController controller = CarouselController(initialItem: 1);
  // late TextEditingController _phoneNumberController;
  // late TextEditingController _passwordController;
  // final TextEditingController _emailController = TextEditingController();

  // final _formKey2 = GlobalKey<FormState>();
  late bool isPhone;
  // late bool _passwordVisible;
  // late bool checked;
  bool forgotPasswordBool = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // _phoneNumberController =
    //     TextEditingController(text: box.get('phoneNumber') as String?);
    // _passwordController =
    // //     TextEditingController(text: box.get('password') as String?);

    String? phoneNumber = box.get('phoneNumber');
    String? email = box.get('email');
    String? address = box.get('address');
    isPhone = phoneNumber == null ? false : true;

    context.read<UserCubit>().initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scaffold = scaffoldKey.currentState;
      if (scaffold != null) {
        scaffold.showBottomSheet((BuildContext context) {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragEnd: (details) {},
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SingleChildScrollView(
                        child: OnboardContent(
                      email: email,
                      phoneNumber: phoneNumber,
                      address: address,
                    )),
                  ],
                ),
              ),
            ),
          );
        });
      }
    });

    super.initState();
    // _passwordVisible = true;
  }

  int backButtonPressCount = 0;

  DateTime lastBackPressedTime = DateTime.now();

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (now.difference(lastBackPressedTime) >
        const Duration(milliseconds: 500)) {
      setState(() {
        backButtonPressCount = 0;
        lastBackPressedTime = now;
      });
    }

    setState(() {
      backButtonPressCount++;
    });

    if (backButtonPressCount == 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text("Press twice to exit",
                style: TextStyle(color: Colors.black))),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ));
      return false;
    } else if (backButtonPressCount == 2) {
      SystemNavigator.pop();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // if ((state.userRole == UserType.adminUser.getUserName) ||
          //     (state.userRole == UserType.nurse.getUserName) ||
          //     (state.userRole == UserType.doctor.getUserName)) {
          // Navigator.of(context).pushNamed(state.welcomeUrl!);
        } else if (state is LogoutUser) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          // appBar: const AppBarWidget(title: 'Symphony MQMH', actions: []),
          body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OrientationBuilder(
                          builder: (context, orientation) {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.landscape) {
                              // no landscape allowed
                              // return landscapeMode();
                              return portraitMode();
                            } else {
                              return portraitMode();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // body: OrientationBuilder(
          //   builder: (context, orientation) {
          //     if (MediaQuery.of(context).orientation ==
          //         Orientation.landscape) {
          //       // no landscape allowed
          //       // return landscapeMode();
          //       return portraitMode();
          //     } else {
          //       return portraitMode();
          //     }
          //   },
          // ),
        );
      },
    );
  }

  Widget loginImage(String imagePath) {
    return Transform.scale(
      scale: scaleFactor,
      child: FractionallySizedBox(
        heightFactor: 1.5,
        widthFactor: 2,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Image.asset(
              imagePath,
            ),
          ),
        ),
      ),
    );
  }

  Widget portraitMode() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            child: Stack(children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * .668,
                  child: loginImage(
                    'assets/Laundry and dry cleaning.gif',
                  )),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    // color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal:
                                  BorderSide(color: secondaryColor, width: 3),
                              vertical:
                                  BorderSide(color: secondaryColor, width: 3))),
                      child: Text(
                        'The \nLaundry \nApp',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 35,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
