import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/usercubit/user_cubit.dart';
import 'package:lottie/lottie.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  String address = '';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          if (address.isEmpty) {
            address = state.userData!['address'];
          }

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
                          'Your Addresses',
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
                      child: ListView(
                        children: [
                          _buildAddressCard(
                            'Home',
                            address.toString().split(',')[0],
                            address
                                .toString()
                                .split(',')
                                .skip(1)
                                .join(',')
                                .trim(),
                            Icons.home_rounded,
                            isDefault: true,
                          ),
                          // _buildAddressCard(
                          //   'Office',
                          //   '456 Business Ave',
                          //   'New York, NY 10002',
                          //   Icons.business_rounded,
                          // ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: ElevatedButton.icon(
                    //       onPressed: () {
                    //         // Add new address logic
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.blueGrey,
                    //         padding: const EdgeInsets.all(16),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //       ),
                    //       icon: const Icon(Icons.add),
                    //       label: const Text(
                    //         'Add New Address',
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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

  Widget _buildAddressCard(
    String title,
    String addressLine1,
    String addressLine2,
    IconData icon, {
    bool isDefault = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey[100],
                  child: Icon(icon, color: Colors.blueGrey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addressLine1,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        addressLine2,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    // Edit address logic
                    _showEditAddressDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAddressDialog() {
    final TextEditingController addressController =
        TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: const Text('Edit Address'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: TextField(
              controller: addressController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'New Address',
                labelStyle: TextStyle(color: primaryColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newAddress = addressController.text;
                if (newAddress.isNotEmpty) {
                  final response = await NewApiService().updateAddress(
                    newAddress: newAddress,
                  );
                  if (response['type'] == 'SUCCESS') {
                    // Handle success (e.g., show a success message, refresh data)
                    setState(() {
                      address = addressController.text;
                    });
                  } else {
                    // Handle error (e.g., show an error message)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
