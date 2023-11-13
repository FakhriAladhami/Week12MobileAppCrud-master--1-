import 'package:crud_app/Repositories/DataService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Models/User.dart';

class UsersView extends StatefulWidget {
  final List<User> inUsers;
  const UsersView({Key? key, required this.inUsers}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState(inUsers);
}

const String BaseUrl = "https://cmsc2204-mobile-api.onrender.com/Auth";
final _dio = Dio(BaseOptions(baseUrl: BaseUrl));
DataService _dataService = DataService();

bool _loading = false;

class _UsersViewState extends State<UsersView> {
  _UsersViewState(users);
  late List<User> users = widget.inUsers;

  Future<void> addUser(String username, String level) async {
    final response = await _dio.post(
      'https://cmsc2204-mobile-api.onrender.com/addUser',
      data: {'name': username, 'level': level.toString()},
    );

    if (response.statusCode == 200) {
      print("success");
    } else {
      print('Error adding user: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(int userId) async {
    final response = await _dio.delete(
      'https://cmsc2204-mobile-api.onrender.com/Auth"$userId',
    );

    if (response.statusCode == 200) {
      // Successful deletion, update UI
      setState(() {
        users.removeWhere((user) => user.Username == userId);
      });

      // Fetch all users again after deletion
      await fetchUsers();
    } else {
      // Handle error
      print('Error deleting user: ${response.statusCode}');
    }
  }

  Future<void> fetchUsers() async {
    final response = await _dio
        .get('https://cmsc2204-mobile-api.onrender.com/Auth/getUsers');

    if (response.statusCode == 200) {
    } else {
      // Handle error
      print('Error fetching users: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("View Users"),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: users.map((user) {
            return Padding(
              padding: EdgeInsets.all(3),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Username: ${user.Username}"),
                      subtitle: Text("Auth Level: ${user.AuthLevel}"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('UPDATE'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                            child: const Text('DELETE'),
                            onPressed: () async {
                              // Show AlertDialog to confirm deletion
                              bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Delete User'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ));
                              if (confirmDelete ?? false) {
                                // User confirmed deletion
                               // await deleteUser(user.Username);
                              }
                            }),

                        // },

                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        )),
      ),
    );
  }
}
