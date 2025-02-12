import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future: NewApiService().getCustomerOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final orders = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order',
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  '#${order['id'].toString().substring(0, 8)}',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            subtitle: Table(
                              columnWidths: const {
                                0: FixedColumnWidth(
                                    80), // Fixed width for labels
                                1: FixedColumnWidth(
                                    20), // Fixed width for colons
                                2: FlexColumnWidth(), // Flexible width for values
                              },
                              children: [
                                _buildTableRow(
                                    'Service', order['serviceName'] ?? ''),
                                _buildTableRowwithColor(
                                    'Status',
                                    _getStatusText(order['status']),
                                    _getStatusColor(order['status'])),
                                _buildTableRow(
                                    'Delivery', order['expectedDeliveryDate']),
                                _buildTableRow(
                                    'Quantity',
                                    order['quantity']
                                        .toString()), // Added Quantity
                                _buildTableRow('Additional Description',
                                    order['additionalDescription']),
                              ],
                            ),
                            trailing:
                                order['status'] == 0 || order['status'] == 1
                                    ? SizedBox(
                                        height: 40,
                                        child: TextButton(
                                          onPressed: () async {
                                            await NewApiService().cancelOrder(
                                              orderId: order['id'],
                                            );
                                            setState(() {});
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      )
                                    : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
          child: Text(label, style: TextStyle(color: secondaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
          child: Text(':',
              style:
                  TextStyle(color: secondaryColor)), // Colon in its own column
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
          child: Text(value, style: TextStyle(color: secondaryColor)),
        ),
      ],
    );
  }

  TableRow _buildTableRowwithColor(String label, String value, Color clr) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
          child: Text(label, style: TextStyle(color: secondaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
          child: Text(':',
              style:
                  TextStyle(color: secondaryColor)), // Colon in its own column
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
          child: Text(value, style: TextStyle(color: clr)),
        ),
      ],
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.green;
      case 4:
        return Colors.brown;
      default:
        return Colors.black;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Processing';
      case 2:
        return 'In Progress';
      case 3:
        return 'Completed';
      case 4:
        return 'Cancelled Successfully';
      default:
        return 'Pending';
    }
  }
}
