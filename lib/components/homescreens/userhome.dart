import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/components/homescreens/cart.dart';
import 'package:laundry_app/components/model/cart_model.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/usercubit/user_cubit.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onPlaced});
  final Function? onPlaced;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<IconData> icons = [
    Icons.local_laundry_service,
    Icons.cleaning_services,
    Icons.local_offer,
    Icons.room_service,
    Icons.business_center,
  ];
  final List<CartItem> cart = [];
  List<Map<String, dynamic>> services = []; // Declare services list
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController
  Future<List<Map<String, dynamic>>>? _servicesFuture; // Cache the future
  @override
  void initState() {
    // TODO: implement initState
    _servicesFuture = _fetchServices();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchServices() async {
    if (services.isEmpty) {
      services = await NewApiService().getCustomerServices();
    }
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          return Scaffold(
              // appBar: AppBar(
              //   title: Text('Hello, ${state.userData!['firstName']}!'),
              //   actions: [
              //     IconButton(
              //       icon: Icon(Icons.logout),
              //       onPressed: () {
              //         Navigator.of(context)
              //             .pushNamedAndRemoveUntil('/', (route) => false);
              //       },
              //     ),
              //   ],
              // ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hello, ${state.userData!['firstName'].toString()}!',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', (route) => false);
                            },
                            icon: Icon(Icons.logout),
                            color: Colors.white,
                          )
                        ],
                      ),
                      const Text(
                        'What can we clean for you today?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Our Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: FutureBuilder(
                          future: _servicesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Lottie.asset(
                                    'assets/loading-washing.json',
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    width:
                                        MediaQuery.of(context).size.width * .5),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            services = snapshot.data ?? [];
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                final service = services[index];
                                return _buildServiceCard(
                                    service['serviceName'],
                                    '\Rs. ${service['price']}',
                                    service['materialType'],
                                    // icons[Random().nextInt(icons.length)],
                                    ++index);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: cart.isNotEmpty
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(
                              cart: cart,
                              onCartChanged: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 60,
                        height: 50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.shopping_cart),
                            if (cart.isNotEmpty)
                              Positioned(
                                right: 5,
                                top: 5,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red.shade700,
                                  child: Text(
                                    '${cart.length}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : null);
        } else {
          return Center(
            child: Lottie.asset('assets/loading-washing.json',
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width * .5),
          );
        }
      },
    );
  }

  void _addToCart(String serviceName) {
    final scrollOffset = _scrollController.offset; // Capture scroll position
    setState(() {
      final existingItem = cart.firstWhere(
        (item) => item.service['serviceName'] == serviceName,
        orElse: () => CartItem(service: {}, quantity: 0),
      );

      if (existingItem.quantity > 0) {
        existingItem.quantity++;
      } else {
        final service = services.firstWhere(
          (service) => service['serviceName'] == serviceName,
        );
        cart.add(CartItem(service: service, quantity: 1));
      }
    });
    _scrollController.jumpTo(scrollOffset); // Restore scroll position
  }

  Widget _buildServiceCard(
    String title,
    String price,
    String description,
    int index,
  ) {
    final existingItem = cart.firstWhere(
      (item) => item.service['serviceName'] == title,
      orElse: () => CartItem(service: {}, quantity: 0),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: ListTile(
        tileColor: Colors.blueGrey[10],
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey[100],
          maxRadius: 15,
          child: Text(index.toString(),
              style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.bold)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.red.shade900),
            ),
            Text(
              price,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                description,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blueGrey[400]),
              ),
            ),
            if (existingItem.quantity > 0)
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .445),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (existingItem.quantity > 1) {
                            existingItem.quantity--;
                          } else {
                            cart.remove(existingItem);
                          }
                        });
                      },
                    ),
                    Text('${existingItem.quantity}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          existingItem.quantity++;
                        });
                      },
                    ),
                  ],
                ),
              )
            else
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .445),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8)),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      _addToCart(title);
                    },
                    child: Text(
                      'ADD',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
