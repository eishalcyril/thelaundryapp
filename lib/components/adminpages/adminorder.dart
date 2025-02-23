import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:lottie/lottie.dart';

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
        backgroundColor: primaryColor,
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
                child: Stack(
                  children: [
                    ListTile(
                      title: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: secondaryColor)),
                        padding: EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order',
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '#${order['id'].toString().substring(0, 8)}',
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(120),
                          1: FixedColumnWidth(20),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          _buildTableRow('Service', order['serviceName']),
                          _buildTableRow(
                              'Material Type', order['materialType']),
                          _buildTableRow(
                              'Quantity', order['quantity'].toString()),
                          _buildTableRow('Additional Description',
                              order['additionalDescription']),
                          _buildTableRowwithColor(
                              'Status',
                              _getStatusText(order['status']),
                              _getStatusColor(order['status'])),
                          _buildTableRow(
                              'Delivery',
                              DateFormat('yyyy-MM-dd HH:mm').format(
                                  DateTime.parse(order['expectedDeliveryDate'])
                                      .toLocal())),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: MediaQuery.of(context).size.height * .06,
                      child: PopupMenuButton<int>(
                        color: primaryColor,
                        elevation: 8,
                        onSelected: (status) async {
                          if (_isUpdating) return;
                          _isUpdating = true;

                          await NewApiService()
                              .updateOrderStatus(
                                orderId: order['id'],
                                status: status,
                              )
                              .then((_) {
                                setState(() {});
                              })
                              .catchError((error) {})
                              .whenComplete(() {
                                _isUpdating = false;
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
                  ],
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
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(label, style: TextStyle(color: secondaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(':', style: TextStyle(color: secondaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(value, style: TextStyle(color: secondaryColor)),
        ),
      ],
    );
  }

  TableRow _buildTableRowwithColor(String label, String value, Color clr) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(label, style: TextStyle(color: secondaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(':', style: TextStyle(color: secondaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            value,
            style: TextStyle(
              color: clr,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
