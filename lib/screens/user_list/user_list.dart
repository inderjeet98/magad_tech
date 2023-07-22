import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../services/service.dart';
import '../../widgets/designconfig.dart';
import '../google_maps/google_maps.dart';
import '../user_list/create_user.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key, this.token}) : super(key: key);
  final String? token;
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Future? initApiCall;
  List<dynamic> userList = [];

  @override
  void initState() {
    super.initState();
    initApiCall = getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getUserData() async {
    userList = [];
    var userListResponse = await ApiService().getUserList(widget.token!);
    userList.add(userListResponse);
    print(userList);
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        elevation: 1,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateUserScreen()));
              },
              child: const Icon(
                Icons.add_box_rounded,
              ),
            ),
          ),
        ],
      ),
      body: usersListView(),
    );
  }

  Widget usersListView() {
    return FutureBuilder(
        future: initApiCall,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: userList[0]['users'].length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleMapsScreen(
                                  userId: userList[0]['users'][index]['_id'],
                                  userName: userList[0]['users'][index]['name'],
                                  userPhone: userList[0]['users'][index]['phone'],
                                  lat: userList[0]['users'][index]['location']['latitude'].toDouble(),
                                  long: userList[0]['users'][index]['location']['longitude'].toDouble(),
                                  userEmail: userList[0]['users'][index]['email'])));
                    },
                    child: DesignConfig.displayUserList(userList[0]['users'][index]['name'], userList[0]['users'][index]['name'].substring(0, 1), userList[0]['users'][index]['email'],
                        userList[0]['users'][index]['phone'], MediaQuery.of(context).size.width * 0.7),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }
        });
  }
}
