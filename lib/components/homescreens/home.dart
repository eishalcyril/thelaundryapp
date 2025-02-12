import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/components/adminpages/addservice.dart';
import 'package:laundry_app/components/adminpages/adminhome.dart';
import 'package:laundry_app/components/adminpages/adminorder.dart';
import 'package:laundry_app/components/homescreens/addresspage.dart';
import 'package:laundry_app/components/homescreens/orderspage.dart';
import 'package:laundry_app/components/homescreens/userhome.dart';
import 'package:laundry_app/usercubit/user_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is LoginSuccess && state.userRole == true) {
          // Admin UI
          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                AdminServicesPage(),
                AdminOrdersPage(),
                AddServicePage(
                  onServiceAdded: () {
                    setState(() {
                      _onNavBarTapped(0);
                    }); // Change to Services page
                  },
                ),
              ],
            ),
            bottomNavigationBar: _buildBottomNav(isAdmin: true),
          );
        } else {
          // User UI
          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                HomePage(
                  onPlaced: () {
                    setState(() {
                      _onNavBarTapped(1);
                    }); // Change to Services page
                  },
                ),
                OrdersPage(),
                AddressesPage(),
              ],
            ),
            bottomNavigationBar: _buildBottomNav(isAdmin: false),
          );
        }
      },
    );
  }

  Widget _buildBottomNav({required bool isAdmin}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.blueGrey[200],
          items: isAdmin
              ? const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.cleaning_services_rounded),
                    activeIcon: Icon(Icons.cleaning_services_rounded, size: 28),
                    label: 'Services',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_rounded),
                    activeIcon: Icon(Icons.receipt_long_rounded, size: 28),
                    label: 'Orders',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle_outline),
                    activeIcon: Icon(Icons.add_circle, size: 28),
                    label: 'Add Service',
                  ),
                ]
              : const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    activeIcon: Icon(Icons.home_rounded, size: 28),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_rounded),
                    activeIcon: Icon(Icons.receipt_long_rounded, size: 28),
                    label: 'Orders',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_on_outlined),
                    activeIcon: Icon(Icons.location_on_rounded, size: 28),
                    label: 'Addresses',
                  ),
                ],
        ),
      ),
    );
  }
}
