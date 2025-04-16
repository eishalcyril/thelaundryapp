import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/common/line_dash_generator.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/enums/user_type_enum.dart';
import 'package:lottie/lottie.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<Map<String, dynamic>>>? _ordersFuture;
  final ScrollController _scrollController = ScrollController();
  @override
   void initState() {
    _ordersFuture = NewApiService().getCustomerOrders();
    super.initState();
  }

  Future<void> _refreshOrders() async {
    // Fetch existing order before refreshing

    setState(() {
      _ordersFuture = NewApiService().getCustomerOrders();
    });
    await _ordersFuture;
  }

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
                child: RefreshIndicator(
                  onRefresh: _refreshOrders,
                  child: FutureBuilder(
                    future: _ordersFuture,
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
                                  height:
                                      MediaQuery.of(context).size.height * .5,
                                  width:
                                      MediaQuery.of(context).size.width * .5),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order['orderId'].toString().substring(0, 8),
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
                                style: TextStyle(color: Colors.blueGrey[600]),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    children: List.generate(
                                        order['items'].length, (itemIndex) {
                                      final item = order['items'][itemIndex];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Table(
                                              columnWidths: const {
                                                0: FixedColumnWidth(80),
                                                1: FixedColumnWidth(20),
                                                2: FlexColumnWidth(),
                                              },
                                              children: [
                                                _buildTableRow('Service',
                                                    item['serviceName'] ?? ''),
                                                _buildTableRow(
                                                    'Quantity',
                                                    item['quantity']
                                                        .toString()),
                                              ],
                                            ),
                                          ),
                                          if (order['status'] != 3 &&
                                              order['status'] != 4 &&
                                              order['status'] != 2)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.blueGrey),
                                                  onPressed: () {
                                                    _showEditItemDialog(
                                                        context, order, item);
                                                  },
                                                ),
                                              ],
                                            ),
                                          if (itemIndex <
                                              order['items'].length - 1)
                                            Divider(
                                              color: Colors.blueGrey,
                                              thickness: 1,
                                            ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    'Additional Description: ${order['additionalDescription'] ?? ''}',
                                    style:
                                        TextStyle(color: Colors.blueGrey[600]),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (order['status'] != 3 &&
                                          order['status'] != 4 &&
                                          order['status'] != 2) ...[
                                        Text('Edit order'),
                                        IconButton(
                                          icon: Icon(Icons.edit_calendar,
                                              color: Colors.blueGrey),
                                          onPressed: () {
                                            _showEditDialog(context, order);
                                          },
                                        ),
                                      ],
                                      if (order['status'] == 0 ||
                                          order['status'] == 1)
                                        IconButton(
                                          icon: Icon(Icons.cancel,
                                              color: Colors.red.shade700),
                                          onPressed: () async {
                                            await NewApiService().cancelOrder(
                                              orderId: order['orderId'],
                                            ).then((value) => NewApiService().sendPushNotification(title: "Order Cancelled", body: "Your order has been cancelled",userType:UserType.customer ));
                                            setState(() {});
                                          },
                                        ),
                                      if (order['status'] == 3 &&
                                          !order['reviewSubmitted'])
                                        IconButton(
                                          icon: Icon(Icons.rate_review,
                                              color: Colors.green),
                                          onPressed: () {
                                            _showReviewDialog(context, order);
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
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(label, style: TextStyle(color: secondaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(':', style: TextStyle(color: Colors.black)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(value, style: TextStyle(color: sectxtColor)),
        ),
      ],
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
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

  void _showEditItemDialog(BuildContext context, Map<String, dynamic> order,
      Map<String, dynamic> item) {
    final quantityController =
        TextEditingController(text: item['quantity'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Edit Item',
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                // Update the quantity in the item
                item['quantity'] = int.parse(quantityController.text);

                // Prepare the updated order data
                final updatedOrderData = {
                  "items": order['items'].map((item) {
                    return {
                      "serviceId": item['serviceId'],
                      "quantity": item['quantity'],
                    };
                  }).toList(),
                  "expectedDeliveryDate": order['expectedDeliveryDate'],
                  "additionalDescription": order['additionalDescription'],
                };

                // Call the API with the updated order data
                await NewApiService().updateCustomerOrder(
                  orderId: order['orderId'],
                  orderData: updatedOrderData,
                );
                    NewApiService().sendPushNotification(title: "Order Updated", body: "Your order has been updated", userType: UserType.customer);

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

  void _showEditDialog(BuildContext context, Map<String, dynamic> order) {
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
            children: [
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
                order['additionalDescription'] = descriptionController.text;
                order['expectedDeliveryDate'] =
                    selectedDateTime?.toIso8601String() ??
                        order['expectedDeliveryDate'];


                await NewApiService().updateCustomerOrder(
                  orderId: order['orderId'],
                  orderData: order,
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

  void _showReviewDialog(BuildContext context, Map<String, dynamic> order) {
    final reviewController = TextEditingController();
    int rating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Review Order',
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  labelText: 'Review',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      rating = index + 1;
                    },
                  );
                }),
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
                final reviewData = {
                  "content": reviewController.text,
                  "rating": rating,
                };

                final response = await NewApiService().submitOrderReview(

                  orderId: order['orderId'],
                  reviewData: reviewData,
                );

                if (response['type'] == 'SUCCESS') {
                  order['reviewSubmitted'] = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Review submitted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not submit review.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                setState(() {});
                Navigator.pop(context);
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.blueGrey[800]),
              ),
            ),
          ],
        );
      },
    );
  }
}
