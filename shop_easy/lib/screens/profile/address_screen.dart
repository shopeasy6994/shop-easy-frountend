import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/auth_provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch addresses when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the form to add a new address
              context.go('/home/profile/addresses/add');
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (ctx, authData, child) {
          if (authData.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (authData.user == null || authData.user!.addresses.isEmpty) {
            return const Center(
              child: Text(
                'No addresses saved. \nAdd one using the + button.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          final addresses = authData.user!.addresses;
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (ctx, i) {
              final address = addresses[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListTile(
                  title: Text(address.street),
                  subtitle: Text(
                      '${address.city}, ${address.state} ${address.postalCode}\n${address.country}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () {
                          context.go('/home/profile/addresses/edit',
                              extra: address);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show a confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text(
                                  'Do you want to remove this address?'),
                              actions: <Widget>[
                                TextButton(
                                    child: const Text('No'),
                                    onPressed: () => Navigator.of(ctx).pop()),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .removeAddress(address.id);
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
