import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';  // Importing the user.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  // Fetch users from API
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        users = jsonResponse.map((data) => User.fromJson(data)).toList();
        filteredUsers = users;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Filter users based on search input
  void filterUsers(String query) {
    final filtered = users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsers = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          // Add a search icon that triggers the search
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate(filterUsers));
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchUsers,
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("https://placekitten.com/150/150"),
                      onBackgroundImageError: (exception, stackTrace) {
                        print("Error loading image: $exception");
                        // You can provide a fallback image here
                      },
                    ),
                    title: Text(filteredUsers[index].name),
                    subtitle: Text(filteredUsers[index].email),
                  );
                },
              ),
            ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final Function(String) filterUsers;

  CustomSearchDelegate(this.filterUsers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          filterUsers(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filterUsers(query);
    return Container();
  }
}
