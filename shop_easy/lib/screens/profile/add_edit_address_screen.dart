import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/models/address.dart';
import 'package:shop_easyy/providers/auth_provider.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  // CORRECTED: State class is now public
  AddEditAddressScreenState createState() => AddEditAddressScreenState();
}

// CORRECTED: State class is now public
class AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _street, _city, _state, _postalCode, _country;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _street = widget.address!.street;
      _city = widget.address!.city;
      _state = widget.address!.state;
      _postalCode = widget.address!.postalCode;
      _country = widget.address!.country;
    } else {
      _street = '';
      _city = '';
      _state = '';
      _postalCode = '';
      _country = '';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final newAddress = Address(
        id: widget.address?.id ?? DateTime.now().toString(),
        street: _street,
        city: _city,
        state: _state,
        postalCode: _postalCode,
        country: _country,
      );

      if (widget.address == null) {
        authProvider.addAddress(newAddress);
      } else {
        authProvider.updateAddress(newAddress);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _street,
                decoration: const InputDecoration(labelText: 'Street Address'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a street address' : null,
                onSaved: (value) => _street = value!,
              ),
              TextFormField(
                initialValue: _city,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a city' : null,
                onSaved: (value) => _city = value!,
              ),
              TextFormField(
                initialValue: _state,
                decoration:
                    const InputDecoration(labelText: 'State / Province'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a state' : null,
                onSaved: (value) => _state = value!,
              ),
              TextFormField(
                initialValue: _postalCode,
                decoration: const InputDecoration(labelText: 'Postal Code'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a postal code' : null,
                onSaved: (value) => _postalCode = value!,
              ),
              TextFormField(
                initialValue: _country,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a country' : null,
                onSaved: (value) => _country = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
