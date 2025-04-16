import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/enums/user_type_enum.dart';
import 'package:lottie/lottie.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  bool _isUpdating = false;
  Future<List<Map<String, dynamic>>>? _ordersFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ordersFuture = NewApiService().getAdminOrders();
  }

  Future<void> _refreshOrders() async {
    final currentPosition =
        _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() {
      _ordersFuture = NewApiService().getAdminOrders();
    });
    await _ordersFuture;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(currentPosition);
      }
    });
  }

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
      body: RefreshIndicator(
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
            return ListView.builder(
              controller: _scrollController,
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
                                '#${order['orderId'].toString().substring(0, 8)}',
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FixedColumnWidth(120),
                                1: FixedColumnWidth(20),
                                2: FlexColumnWidth(),
                              },
                              children: [
                                _buildTableRow(
                                    'Customer ID',
                                    order['customerId']
                                        .toString()
                                        .substring(0, 8)),
                                _buildTableRow('Additional Description',
                                    order['additionalDescription']),
                                _buildTableRowwithColor(
                                    'Status',
                                    _getStatusText(order['status']),
                                    _getStatusColor(order['status'])),
                                _buildTableRow(
                                    'Delivery',
                                    DateFormat('yyyy-MM-dd HH:mm').format(
                                        DateTime.parse(
                                                order['expectedDeliveryDate'])
                                            .toLocal())),
                                _buildTableRow('Total Amount',
                                    order['totalAmount'].toString()),
                              ],
                            ),
                            Divider(
                              color: primaryColor,
                            ),
                            ...order['items'].map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 6),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.all(4),
                                  child: Table(
                                    columnWidths: const {
                                      0: FixedColumnWidth(120),
                                      1: FixedColumnWidth(20),
                                      2: FlexColumnWidth(),
                                    },
                                    children: [
                                      _buildTableRow(
                                          'Service', item['serviceName']),
                                      _buildTableRow('Material Type',
                                          item['materialType']),
                                      _buildTableRow('Quantity',
                                          item['quantity'].toString()),
                                      _buildTableRow('Price Per Unit',
                                          item['pricePerUnit'].toString()),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
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
                            setState(() {
                              _isUpdating = true;
                            });

                            final newStatus = status - 1;

                            final result =
                                await NewApiService().updateOrderStatus(
                              orderId: order['orderId'],
                              status: newStatus,
                            );

                            if (result['type'] == 'SUCCESS') {
                              // Send notification on successful status update
                              await NewApiService()
                                  .sendPushNotification(
                                userType: UserType.customer,
                                // topic: order['customerId']
                                //     .toString()
                                //     .substring(0, 8),
                                title: 'Order Status Updated',
                                body:
                                    'Your order #${order['orderId'].toString().substring(0, 8)} is now ${_getStatusText(newStatus)}.',
                              )

                                  // Refresh after updating status

                                  .catchError((error) {
                                return error;
                              }).whenComplete(() async {
                                _isUpdating = false;
                                await _refreshOrders();
                              });
                            }
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
}
