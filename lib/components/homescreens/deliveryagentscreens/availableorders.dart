import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart'; // Import your config file for colors

class AvailableOrdersPage extends StatefulWidget {
  const AvailableOrdersPage({super.key});

  @override
  State<AvailableOrdersPage> createState() => _AvailableOrdersPageState();
}

class _AvailableOrdersPageState extends State<AvailableOrdersPage> {
  Future<List<Map<String, dynamic>>>? _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = NewApiService().getAvailableOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _servicesFuture = NewApiService().getAvailableOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Orders'),
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
        onRefresh: _refreshOrders,
        child: FutureBuilder(
          future: _servicesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final orders = snapshot.data ?? [];
            if (orders.isEmpty) {
              return const Center(child: Text('No available orders.'));
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      'Order ID: ${order['id'].toString().substring(0, 8)}',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Total Amount: Rs. ${order['totalAmount']}',
                      style: TextStyle(color: primaryColor),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer ID: ${order['customerId'].toString().substring(0, 8)}',
                              style: TextStyle(color: sectxtColor),
                            ),
                            Text(
                              'Expected Delivery: ${order['expectedDeliveryDate']}',
                              style: TextStyle(color: sectxtColor),
                            ),
                            Text(
                              'Status: ${_getStatusText(order['status'])}',
                              style: TextStyle(color: sectxtColor),
                            ),
                            const Divider(),
                            ...order['items'].map<Widget>((item) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: secondaryColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Service: ${item['serviceName']}',
                                        style:
                                            TextStyle(color: secondaryColor)),
                                    Text(
                                        'Material Type: ${item['materialType']}',
                                        style:
                                            TextStyle(color: secondaryColor)),
                                    Text('Quantity: ${item['quantity']}',
                                        style:
                                            TextStyle(color: secondaryColor)),
                                    Text('Price: Rs. ${item['price']}',
                                        style:
                                            TextStyle(color: secondaryColor)),
                                    Text('Total: Rs. ${item['total']}',
                                        style:
                                            TextStyle(color: secondaryColor)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor, // Set the button color
                        ),
                        onPressed: () async {
                          await NewApiService().takeOrder(orderId: order['id']);
                          await _refreshOrders();
                        },
                        child: Text('Claim Order',
                            style: TextStyle(
                                color:
                                    txtColor)), // Use txtColor for button text
                      ),
                    ],
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
        return 'Pending';
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
