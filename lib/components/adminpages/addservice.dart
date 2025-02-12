import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key, this.onServiceAdded});
  final Function? onServiceAdded; // Callback function

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _materialTypeController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: txtColor),
        title: Text(
          'Add New Service',
          style: TextStyle(color: txtColor),
        ), actions: [
          IconButton.filledTonal(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _materialTypeController,
                decoration: InputDecoration(
                  labelText: 'Material Type',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    'Add Service',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      NewApiService().addService(
        serviceName: _serviceNameController.text,
        materialType: _materialTypeController.text,
        price: double.tryParse(_priceController.text) ?? 0,
      );

      _serviceNameController.clear();
      _materialTypeController.clear();
      _priceController.clear();
      widget.onServiceAdded!();
      // Add success handling
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _materialTypeController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
