import 'package:flutter/material.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/config.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    _usersFuture = NewApiService().getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
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
        title: Text('Manage Users', style: TextStyle(color: txtColor)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text('${user['firstName']} ${user['lastName']}'),
                subtitle: Text('Email: ${user['email']}'),
                trailing: DropdownButton<int>(
                  value: user['userType'],
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Customer')),
                    DropdownMenuItem(value: 1, child: Text('Admin')),
                    DropdownMenuItem(value: 2, child: Text('Delivery Agent')),
                  ],
                  onChanged: (newUserType) async {
                    if (newUserType != null) {
                      await NewApiService().changeUserType(
                        userId: user['id'],
                        newUserType: newUserType,
                      );
                      setState(() {
                        _usersFuture = NewApiService().getAllUsers();
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
