import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/common/line_dash_generator.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:lottie/lottie.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Orders',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    icon: Icon(Icons.logout),
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future: NewApiService().getCustomerOrders(),
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
                    if (orders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Lottie.asset('assets/loading-2.json',
                                height: MediaQuery.of(context).size.height * .5,
                                width: MediaQuery.of(context).size.width * .5),
                            Text(
                              'No Orders Yet',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            LineDash(length: 30, color: primaryColor)
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.blueGrey, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.white,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order['id'].toString().substring(0, 8),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  _getStatusText(order['status']),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: context
                                          .textTheme.bodyMedium!.fontSize!,
                                      color: _getStatusColor(order['status']),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${DateTime.parse(order['expectedDeliveryDate']).toLocal().toString().split(' ')[0]} ${DateFormat.jm().format(DateTime.parse(order['expectedDeliveryDate']).toLocal())}',
                              style: TextStyle(
                                  color: Colors.blueGrey[
                                      600]), // Blue-grey accent for text
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Table(
                                  columnWidths: const {
                                    0: FixedColumnWidth(80),
                                    1: FixedColumnWidth(20),
                                    2: FlexColumnWidth(),
                                  },
                                  children: [
                                    _buildTableRow(
                                        'Service', order['serviceName'] ?? ''),
                                    _buildTableRow('Quantity',
                                        order['quantity'].toString()),
                                    _buildTableRow('Additional Description',
                                        order['additionalDescription']),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (order['status'] != 3 &&
                                        order['status'] != 4)
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blueGrey),
                                        onPressed: () {
                                          _showEditDialog(context, order);
                                        },
                                      ),
                                    if (order['status'] == 0 ||
                                        order['status'] == 1)
                                      IconButton(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.red.shade700),
                                        onPressed: () async {
                                          await NewApiService().cancelOrder(
                                            orderId: order['id'],
                                          );
                                          setState(() {});
                                        },
                                      ),
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
              style: TextStyle(color: Colors.black)), // Colon in its own column
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical space
          child: Text(value, style: TextStyle(color: sectxtColor)),
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
        return Colors.red.shade700;
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> order) {
    final quantityController =
        TextEditingController(text: order['quantity'].toString());
    final descriptionController =
        TextEditingController(text: order['additionalDescription']);
    DateTime? selectedDateTime = DateTime.parse(order['expectedDeliveryDate']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Edit Order',
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: MediaQuery.of(context).size.height * .01,
            children: [
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[700]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Additional Description',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[700]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDateTime ?? now,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 30)),
                  );

                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(selectedDateTime ?? now),
                    );

                    if (time != null) {
                      setState(() {
                        selectedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDateTime != null
                            ? '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}'
                            : 'Select Date & Time',
                        style: TextStyle(
                          color: selectedDateTime != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Delivery Date: ${DateTime.parse(order['expectedDeliveryDate']).toLocal()}',
                style: TextStyle(color: Colors.blueGrey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blueGrey[800]),
              ),
            ),
            TextButton(
              onPressed: () async {
                final updatedOrder = {
                  "id": order['id'],
                  "customerId": order['customerId'],
                  "serviceId": order['serviceId'],
                  "quantity": int.parse(quantityController.text),
                  "expectedDeliveryDate": selectedDateTime?.toIso8601String() ??
                      order['expectedDeliveryDate'],
                  "additionalDescription": descriptionController.text,
                  "status": order['status'],
                  "dateCreated": order['dateCreated']
                };

                await NewApiService().updateCustomerOrder(
                  orderId: order['id'],
                  orderData: updatedOrder,
                );

                setState(() {});
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.blueGrey[800]),
              ),
            ),
          ],
        );
      },
    );
  }
}
