// void _showOrderSheet(BuildContext context, Map<String, dynamic> service) {
  //   final formKey = GlobalKey<FormState>();
  //   final quantityController = TextEditingController();
  //   final descriptionController = TextEditingController();
  //   DateTime? selectedDateTime;
  //   bool isLoading = false;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //               left: 16,
  //               right: 16,
  //               top: 16,
  //             ),
  //             child: Form(
  //               key: formKey,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Place Order - ${service['serviceName']}',
  //                     style: const TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     controller: quantityController,
  //                     keyboardType: TextInputType.number,
  //                     decoration: InputDecoration(
  //                       labelText: 'Quantity',
  //                       enabledBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: primaryColor)),
  //                       border: OutlineInputBorder(),
  //                     ),
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter quantity';
  //                       }
  //                       if (int.tryParse(value) == null) {
  //                         return 'Please enter a valid number';
  //                       }
  //                       if (int.parse(value) <= 0) {
  //                         return 'Quantity must be greater than 0';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextFormField(
  //                     controller: descriptionController,
  //                     maxLines: 3,
  //                     decoration: InputDecoration(
  //                       labelText: 'Additional Description (Optional)',
  //                       enabledBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: primaryColor)),
  //                       border: OutlineInputBorder(),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   InkWell(
  //                     onTap: () async {
  //                       final now = DateTime.now();
  //                       final date = await showDatePicker(
  //                         context: context,
  //                         initialDate: now.add(const Duration(days: 1)),
  //                         firstDate: now.add(const Duration(days: 1)),
  //                         lastDate: now.add(const Duration(days: 30)),
  //                       );

  //                       if (date != null) {
  //                         final time = await showTimePicker(
  //                           context: context,
  //                           initialTime: TimeOfDay.now(),
  //                         );

  //                         if (time != null) {
  //                           setState(() {
  //                             selectedDateTime = DateTime(
  //                               date.year,
  //                               date.month,
  //                               date.day,
  //                               time.hour,
  //                               time.minute,
  //                             );
  //                           });
  //                         }
  //                       }
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(color: Colors.grey),
  //                         borderRadius: BorderRadius.circular(4),
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             selectedDateTime != null
  //                                 ? '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}'
  //                                 : 'Select Date & Time',
  //                             style: TextStyle(
  //                               color: selectedDateTime != null
  //                                   ? Colors.black
  //                                   : Colors.grey,
  //                             ),
  //                           ),
  //                           const Icon(Icons.calendar_today),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: primaryColor,
  //                         padding: const EdgeInsets.symmetric(vertical: 16),
  //                       ),
  //                       onPressed: () async {
  //                         if (!formKey.currentState!.validate() ||
  //                             selectedDateTime == null) {
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                               content: Text(
  //                                   'Please fill all required fields and select delivery date & time'),
  //                             ),
  //                           );
  //                           return;
  //                         }

  //                         setState(() {
  //                           isLoading = true;
  //                         });

  //                         final uuid = Uuid();
  //                         final orderData = {
  //                           "id": uuid.v4(),
  //                           "customerId": NewApiService.userId,
  //                           "serviceId": service['id'],
  //                           "quantity": int.parse(quantityController.text),
  //                           "expectedDeliveryDate":
  //                               selectedDateTime!.toIso8601String(),
  //                           "additionalDescription":
  //                               descriptionController.text.isEmpty
  //                                   ? ''
  //                                   : descriptionController.text,
  //                           "status": 0,
  //                           "dateCreated": DateTime.now().toIso8601String()
  //                         };

  //                         await NewApiService()
  //                             .placeOrder(orderData: orderData)
  //                             .then((response) async {
  //                           if (!mounted)
  //                             return; // Check if the widget is still mounted
  //                           setState(() {
  //                             isLoading = false;
  //                           });
  //                           if (response['type'] == 'SUCCESS') {
  //                             Navigator.pop(context); // Close the dialog
  //                             // Show success animation
  //                             showDialog(
  //                               context: context,
  //                               barrierDismissible: false,
  //                               builder: (context) => Center(
  //                                 child: Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                           color: Colors.white,
  //                                           borderRadius:
  //                                               BorderRadius.circular(12)),
  //                                       child: Lottie.asset(
  //                                         'assets/payment-success.json',
  //                                         height: 200,
  //                                         width: 200,
  //                                         repeat: false,
  //                                         onLoaded: (composition) {
  //                                           Future.delayed(
  //                                             Duration(
  //                                                 milliseconds: composition
  //                                                     .duration.inMilliseconds),
  //                                             () {
  //                                               if (!mounted)
  //                                                 return; // Check again before popping
  //                                               Navigator.pop(context);
  //                                               widget.onPlaced!();
  //                                             },
  //                                           );
  //                                         },
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 16),
  //                                     const Text(
  //                                       'Payment Successful!',
  //                                       style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontSize: 18,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           } else {
  //                             // Show failure animation
  //                             showDialog(
  //                               context: context,
  //                               barrierDismissible: false,
  //                               builder: (context) => Center(
  //                                 child: Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                           color: Colors.white,
  //                                           borderRadius:
  //                                               BorderRadius.circular(12)),
  //                                       child: Lottie.asset(
  //                                         'assets/payment-failed.json',
  //                                         height: 200,
  //                                         width: 200,
  //                                         repeat: false,
  //                                         onLoaded: (composition) {
  //                                           Future.delayed(
  //                                             Duration(
  //                                                 milliseconds: composition
  //                                                     .duration.inMilliseconds),
  //                                             () {
  //                                               if (!mounted)
  //                                                 return; // Check again before popping
  //                                               Navigator.pop(context);
  //                                             },
  //                                           );
  //                                         },
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 16),
  //                                     const Text(
  //                                       'Payment Failed!',
  //                                       style: TextStyle(
  //                                         color: Colors.red,
  //                                         fontSize: 18,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           }
  //                         });
  //                       },
  //                       child: isLoading
  //                           ? CircularProgressIndicator(
  //                               valueColor:
  //                                   AlwaysStoppedAnimation<Color>(Colors.white),
  //                             )
  //                           : Text(
  //                               'Place Order',
  //                               style: TextStyle(fontSize: 16, color: txtColor),
  //                             ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }