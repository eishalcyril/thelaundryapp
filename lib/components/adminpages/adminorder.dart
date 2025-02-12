import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:lottie/lottie.dart'; // Import your config file

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  bool _isUpdating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Manage Orders',
          style: TextStyle(color: txtColor),
        ),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
        backgroundColor: primaryColor, // Use primaryColor from config
      ),
      body: FutureBuilder(
        future: NewApiService().getAdminOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(
                        child: Lottie.asset('assets/loading-washing.json',
                            height: MediaQuery.of(context).size.height * .5,
                            width: MediaQuery.of(context).size.width * .5),
                      );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: secondaryColor)),
                    // margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(6),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order',
                          style: TextStyle(
                            color: secondaryColor, // Use txtColor from config
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#${order['id'].toString().substring(0, 8)}',
                          style: TextStyle(
                            color: secondaryColor, // Use txtColor from config
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(120), // Fixed width for labels
                      1: FixedColumnWidth(20), // Fixed width for colons
                      2: FlexColumnWidth(), // Flexible width for values
                    },
                    children: [
                      _buildTableRow('Service', order['serviceName']),
                      _buildTableRow('Material Type', order['materialType']),
                      _buildTableRow('Quantity', order['quantity'].toString()),
                      _buildTableRow('Additional Description',
                          order['additionalDescription']),
                      _buildTableRowwithColor(
                          'Status',
                          _getStatusText(order['status']),
                          _getStatusColor(order['status'])),
                      _buildTableRow('Delivery', order['expectedDeliveryDate']),
                    ],
                  ),
                  trailing: PopupMenuButton<int>(
                    color: primaryColor,
                    elevation: 8,
                    onSelected: (status) async {
                      if (_isUpdating) return;
                      _isUpdating = true; // Set the flag to true

                      await NewApiService()
                          .updateOrderStatus(
                        orderId: order['id'],
                        status: status,
                      )
                          .then((_) {
                        setState(() {});
                      }).catchError((error) {
                        // Handle error if needed
                      }).whenComplete(() {
                        _isUpdating =
                            false; // Reset the flag after the operation
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 1,
                          child: Text(
                            'Processing',
                            style: TextStyle(color: txtColor),
                          )),
                      PopupMenuItem(
                          value: 2,
                          child: Text(
                            'In Progress',
                            style: TextStyle(color: txtColor),
                          )),
                      PopupMenuItem(
                          value: 3,
                          child: Text(
                            'Completed',
                            style: TextStyle(color: txtColor),
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
            padding:
                const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
            child: Text(value,
                style: TextStyle(
                  color: clr,
                  decoration: TextDecoration.underline,
                ))),
      ],
    );
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
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.red.shade700;
      case 3:
        return Colors.green;
      case 4:
        return Colors.brown;
      default:
        return Colors.black;
    }
  }
}
