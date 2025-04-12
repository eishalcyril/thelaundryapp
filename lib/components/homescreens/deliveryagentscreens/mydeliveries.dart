import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart'; // Import your config file for colors

class MyDeliveriesPage extends StatefulWidget {
  const MyDeliveriesPage({super.key});

  @override
  State<MyDeliveriesPage> createState() => _MyDeliveriesPageState();
}

class _MyDeliveriesPageState extends State<MyDeliveriesPage> {
  Future<List<Map<String, dynamic>>>? _deliveriesFuture;

  @override
  void initState() {
    super.initState();
    _deliveriesFuture = NewApiService().getMyDeliveries();
  }

  Future<void> _refreshDeliveries() async {
    setState(() {
      _deliveriesFuture = NewApiService().getMyDeliveries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Deliveries'),
        backgroundColor: primaryColor, // Use primaryColor from config
        centerTitle: true,
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            icon: Icon(Icons.logout),
            color: txtColor, // Use txtColor from config
          )
        ],
        titleTextStyle:
            TextStyle(color: txtColor, fontSize: 24), // Use txtColor
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDeliveries,
        child: FutureBuilder(
          future: _deliveriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final orders = snapshot.data ?? [];
            if (orders.isEmpty) {
              return const Center(child: Text('No deliveries.'));
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Order ID: ${order['id'].toString().substring(0, 8)}',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Status: ${_getStatusText(order['status'])}',
                      style: TextStyle(color: secondaryColor),
                    ),
                    trailing: order['status'] !=
                            3 // Check if status is not 'Delivered'
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  primaryColor, // Set the button color
                            ),
                            onPressed: () async {
                              await NewApiService()
                                  .markDelivered(orderId: order['id']);
                              await _refreshDeliveries();
                            },
                            child: Text('Mark Delivered',
                                style: TextStyle(
                                    color:
                                        txtColor)), // Use txtColor for button text
                          )
                        : Text(
                            'Delivered',
                            style: TextStyle(color: secondaryColor),
                          ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Processing';
      case 1:
        return 'In Progress';
      case 2:
        return 'Completed';
      case 4:
        return 'Cancelled';
      case 3:
        return 'Delivered';
      default:
        return 'Pending';
    }
  }
}
