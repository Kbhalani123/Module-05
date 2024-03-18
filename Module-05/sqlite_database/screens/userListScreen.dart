import 'package:flutter/material.dart';
import 'package:keyur_01/sqlite_database/database/db_helper.dart';
import 'package:keyur_01/sqlite_database/model/user.dart';
import 'package:keyur_01/sqlite_database/screens/userScreen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> userList = [];
  DbHelper _helper = DbHelper();

  void _delete(User user, BuildContext context) {
    _helper.deleteRecord(user.id!).then((result) {
      if (result > 0) {
        setState(() {
          userList.removeWhere((element) => element.id == user.id);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          User user = userList[index];

          return Card(
            elevation: 3,
            child: ListTile(
              onTap: () async {
                User? mUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScreen(
                          user: user,
                        ),
                      ),
                    ) ??
                    null;

                if (mUser != null) {
                  var index =
                      userList.indexWhere((element) => element.id == mUser.id);
                  setState(() {
                    userList[index] = mUser;
                  });
                }
              },
              leading: Icon(
                Icons.account_circle,
                size: 50,
              ),
              title: Text('${user.fName} ${user.lName}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${user.email}\n${user.contact}\n${user.course}'),
              trailing: IconButton(
                onPressed: () {
                  showAlertDialog(context, user);
                },
                icon: Icon(
                  Icons.delete,
                ),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          User? user = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserScreen(),
                ),
              ) ??
              null;

          if (user != null) {
            setState(() {
              userList.insert(0, user);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _fetchUserList() async {
    var tempList = await _helper.getAllRecords();
    setState(() {
      userList = tempList;
    });
  }

  Future<bool> showAlertDialog(BuildContext context, User user) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('Are you sure you want to logout from this application'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
           onPressed: () {
             Navigator.pop(context);
            _delete(user, context);
           },
            child: Text('Delete',style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

