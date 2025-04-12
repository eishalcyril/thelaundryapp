import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/components/model/cart_model.dart';
import 'package:laundry_app/config.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Function onCartChanged;
  CartScreen({required this.cart, required this.onCartChanged});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isInstruction = false;
  DateTime? selectedDateTime;
  final descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cart.fold(0,
        (sum, item) => sum + item.totalPrice + (item.includeIroning ? 50 : 0));

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: txtColor, size: 30),
        centerTitle: true,
        title: Text(
          'Cart',
          style: TextStyle(color: txtColor, fontWeight: FontWeight.w700),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final item = widget.cart[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    color: Colors.blueGrey[50],
                    child: ListTile(
                      title: Text(item.service['serviceName'],
                          style: TextStyle(color: primaryColor)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: \Rs. ${item.service['price']}',
                              style: TextStyle(color: primaryColor)),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: primaryColor),
                                onPressed: () {
                                  final scrollOffset = _scrollController.offset;
                                  setState(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    } else {
                                      widget.cart.remove(item);
                                      if (widget.cart.isEmpty) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  });
                                  widget.onCartChanged();
                                  _scrollController.jumpTo(scrollOffset);
                                },
                              ),
                              Text('${item.quantity}',
                                  style: TextStyle(color: primaryColor)),
                              IconButton(
                                icon: Icon(Icons.add, color: primaryColor),
                                onPressed: () {
                                  final scrollOffset = _scrollController.offset;
                                  setState(() {
                                    item.quantity++;
                                  });
                                  widget.onCartChanged();
                                  _scrollController.jumpTo(scrollOffset);
                                },
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Include Ironing',
                                style: TextStyle(color: primaryColor)),
                            value: item.includeIroning,
                            onChanged: (value) {
                              setState(() {
                                item.includeIroning = value!;
                              });
                              widget.onCartChanged();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!isInstruction)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        isInstruction = true;
                      });
                    },
                    child: Text(
                      'Want to include instructions ?',
                      style: TextStyle(decoration: TextDecoration.underline),
                    )),
              ),
            if (isInstruction)
              TextField(
                controller: descriptionController,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      isInstruction = false;
                    });
                  }
                },
                onSubmitted: (value) {},
                decoration: InputDecoration(
                  labelText: 'Additional Instructions',
                  labelStyle: TextStyle(color: Colors.blueGrey[200]),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Text('Total Amount: \Rs. $totalAmount',
                style: TextStyle(color: primaryColor)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: () async {
                  if (selectedDateTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select delivery date & time'),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  final orderData = {
                    "items": widget.cart.map((item) {
                      return {
                        "serviceId": item.service['id'],
                        "quantity": item.quantity,
                      };
                    }).toList(),
                    "expectedDeliveryDate": selectedDateTime!.toIso8601String(),
                    "additionalDescription": descriptionController.text.isEmpty
                        ? ''
                        : descriptionController.text,
                  };

                  await NewApiService()
                      .placeOrder(orderData: orderData)
                      .then((response) async {
                    setState(() {
                      isLoading = false;
                    });
                    if (response['type'] == 'SUCCESS') {
                      Navigator.pop(context);
                      widget.onCartChanged();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order placed successfully!'),
                        ),
                      );

                      // Show success animation
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Lottie.asset(
                                  'assets/payment-success.json',
                                  height: 200,
                                  width: 200,
                                  repeat: false,
                                  onLoaded: (composition) async {
                                    await Future.delayed(
                                      Duration(
                                          milliseconds: composition
                                              .duration.inMilliseconds),
                                      () {
                                        if (!mounted)
                                          return; // Check again before popping
                                        Navigator.pop(context);
                                        widget.onCartChanged();
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
                      widget.cart.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to place order.'),
                        ),
                      );
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
                                    borderRadius: BorderRadius.circular(12)),
                                child: Lottie.asset(
                                  'assets/payment-failed.json',
                                  height: 200,
                                  width: 200,
                                  repeat: false,
                                  onLoaded: (composition) {
                                    Future.delayed(
                                      Duration(
                                          milliseconds: composition
                                              .duration.inMilliseconds),
                                      () {
                                        if (!mounted)
                                          return; // Check again before popping
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Payment Failed!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  });
                },
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Place Order',
                        style: TextStyle(
                            color: txtColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
