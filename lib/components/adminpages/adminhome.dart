import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';
import 'package:lottie/lottie.dart';

class AdminServicesPage extends StatefulWidget {
  const AdminServicesPage({super.key});

  @override
  State<AdminServicesPage> createState() => _AdminServicesPageState();
}

class _AdminServicesPageState extends State<AdminServicesPage> {
  Future<void> _editService({
    required String id,
    required String newservice,
    required String newmaterial,
    required double newprice,
  }) async {
    // Show a dialog or navigate to an edit page
    // After editing, call the updateService method
    final response = await NewApiService().updateService(
      id: id,
      serviceName: newservice, // Get this from user input
      materialType: newmaterial, // Get this from user input
      price: newprice, // Get this from user input
    );

    if (response['type'] == 'SUCCESS') {
      // Handle success (e.g., show a success message, refresh the list)
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response['data'].toString()}!'),
          backgroundColor: Colors.red,
        ),
      );
      // Handle error
    }
  }

  Future<void> _deleteService(String id) async {
    final response = await NewApiService().deleteService(id);

    if (response['type'] == 'SUCCESS') {
      // Handle success (e.g., show a success message, refresh the list)
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response['data'].toString()}!'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Services',
          style: TextStyle(color: txtColor),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
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
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future: NewApiService().getAdminServices(),
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
                    final services = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service['serviceName'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Material: ${service['materialType']}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\Rs. ${service['price']}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        // Implement edit functionality
                                        _showEditDialog(context, service);
                                      },
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Edit'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blueGrey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        // Implement delete functionality
                                        _showDeleteDialog(
                                            context, service['id']);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('Delete'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const AddServicePage(),
      //       ),
      //     );
      //   },
      //   backgroundColor: Colors.blueGrey,
      //   icon: const Icon(Icons.add),
      //   label: const Text('Add Service'),
      // ),
    );
  }

  Future<void> _showEditDialog(
      BuildContext context, Map<String, dynamic> service) {
    final nameController = TextEditingController(text: service['serviceName']);
    final materialController =
        TextEditingController(text: service['materialType']);
    final priceController =
        TextEditingController(text: service['price'].toString());

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Service'),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close))
          ],
        ),
        insetPadding: EdgeInsets.all(7),
        elevation: 8,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: primaryColor), // Use primaryColor
                  ),
                ),
              ),
              TextField(
                controller: materialController,
                decoration: InputDecoration(
                  labelText: 'Material Type',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: primaryColor), // Use primaryColor
                  ),
                ),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: primaryColor), // Use primaryColor
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              //  await NewApiService().
              _editService(
                  id: service['id'],
                  newmaterial: materialController.text,
                  newprice: double.parse(priceController.text),
                  newservice: nameController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, String serviceId) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteService(serviceId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: Text(
              'Delete',
              style: TextStyle(color: txtColor),
            ),
          ),
        ],
      ),
    );
  }
}
