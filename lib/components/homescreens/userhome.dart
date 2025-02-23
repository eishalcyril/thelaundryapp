import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/usercubit/user_cubit.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
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
                        Text(
                          'Hello, ${state.userData!['firstName'].toString()}!',
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
                        future: NewApiService().getCustomerServices(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Lottie.asset('assets/loading-washing.json',
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
                          final services = snapshot.data ?? [];
                          return ListView.builder(
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              final service = services[index];
                              return _buildServiceCard(
                                service['serviceName'],
                                '\Rs. ${service['price']}',
                                service['materialType'],
                                icons[Random().nextInt(icons.length)],
                                onTap: () {
                                  _showOrderSheet(context, service);
                                },
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

  void _showOrderSheet(BuildContext context, Map<String, dynamic> service) {
    final formKey = GlobalKey<FormState>();
    final quantityController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDateTime;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Place Order - ${service['serviceName']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Quantity must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Additional Description (Optional)',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final now = DateTime.now();
                        final date = await showDatePicker(
                          context: context,
                          initialDate: now.add(const Duration(days: 1)),
                          firstDate: now.add(const Duration(days: 1)),
                          lastDate: now.add(const Duration(days: 30)),
                        );

                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          if (!formKey.currentState!.validate() ||
                              selectedDateTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please fill all required fields and select delivery date & time'),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          final uuid = Uuid();
                          final orderData = {
                            "id": uuid.v4(),
                            "customerId": NewApiService.userId,
                            "serviceId": service['id'],
                            "quantity": int.parse(quantityController.text),
                            "expectedDeliveryDate":
                                selectedDateTime!.toIso8601String(),
                            "additionalDescription":
                                descriptionController.text.isEmpty
                                    ? ''
                                    : descriptionController.text,
                            "status": 0,
                            "dateCreated": DateTime.now().toIso8601String()
                          };

                          await NewApiService()
                              .placeOrder(orderData: orderData)
                              .then((response) async {
                            if (!mounted) return;
                            setState(() {
                              isLoading = false;
                            });
                            if (response['type'] == 'SUCCESS') {
                              Navigator.pop(context); // Close the bottom sheet
                              // Show "Ready to Pay" dialog
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.blueGrey[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: Text(
                                    'Ready to Pay?',
                                    style: TextStyle(
                                      color: Colors.blueGrey[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'Please confirm your payment to proceed.',
                                    style: TextStyle(
                                      color: Colors.blueGrey[600],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                        // Show success animation
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Lottie.asset(
                                                    'assets/payment-success.json',
                                                    height: 200,
                                                    width: 200,
                                                    repeat: false,
                                                    onLoaded: (composition) {
                                                      Future.delayed(
                                                        Duration(
                                                            milliseconds:
                                                                composition
                                                                    .duration
                                                                    .inMilliseconds),
                                                        () {
                                                          Navigator.pop(
                                                              context);
                                                          widget.onPlaced!();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                const Text(
                                                  'Payment Successful!',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Pay',
                                        style: TextStyle(
                                          color: Colors.blueGrey[800],
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.blueGrey[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              dev.log(response.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ??
                                      'Failed to place order'),
                                  backgroundColor: Colors.red,
                                ),
                              );

                              setState(() {
                                widget.onPlaced!();
                              });
                            }
                          });
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Place Order',
                                style: TextStyle(fontSize: 16, color: txtColor),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServiceCard(
    String title,
    String price,
    String description,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey[100],
          child: Icon(icon, color: Colors.blueGrey),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              price,
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(description),
        ),
      ),
    );
  }
}
