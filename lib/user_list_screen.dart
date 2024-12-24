import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: userProvider.loading
          ? Center(child: CircularProgressIndicator())
          : userProvider.errorMessage.isNotEmpty
              ? Center(child: Text(userProvider.errorMessage))
              : ListView.builder(
                  itemCount: userProvider.users.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatarUrl),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Handle image load error by setting a placeholder image
                          print('Error loading image: $exception');
                        },
                        child: Image.asset('assets/images/default_avatar.png'),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userProvider.fetchUsers();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
