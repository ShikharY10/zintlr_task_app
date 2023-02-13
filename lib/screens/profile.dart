import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zintlr_internship_task/screens/delete_account.dart';

import '../db/config.dart';
import '../db/models.dart';
import 'my_post.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User user;
  late DataBase db;

  @override
  void initState() {
    super.initState();
    db = getDataBase();
    user = User();
    String? mySavedData = db.get("settings", "myData");
    if (mySavedData != null) {
      user.toObject(mySavedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.2,
              0.5,
              0.8,
            ],
            colors: [
              Color.fromARGB(255, 231, 62, 118),
              Color.fromARGB(255, 195, 0, 255),
              Color.fromARGB(255, 39, 57, 223),
            ],
          )
        ),
        child: Container(
          width: MediaQuery.of(context).size.width/1.1,
          // height: MediaQuery.of(context).size.height/1.5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            border: Border.all(color: Colors.white)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text("PROFILE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                    )
                  ),
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey,
                  backgroundImage: (user.image!.localData!.isNotEmpty) 
                    ? MemoryImage(base64.decode(user.image!.localData!))
                    : Image.network(user.image!.secureUrl!) as ImageProvider
                ),
                ProfileDetailDisplay(
                  name: "Id", 
                  value: user.id!
                ),
                ProfileDetailDisplay(
                  name: "Username",
                  value: user.username!,
                ),
                ProfileDetailDisplay(
                  name: "Tags",
                  value: user.tags.join(", "),
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: InkWell(
                    child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 39, 39, 39),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: Colors.white)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.post_add),
                          Text("My Posts")
                        ]
                      )
                    )
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyPosts()
                        )
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 0, 0),
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.delete),
                          Text("Delete Account")
                        ]
                      )
                    )
                    ),
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) => DeleteAccount(id: user.id!)
                      );
                    },
                  ),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}


class ProfileDetailDisplay extends StatefulWidget {
  final String name;
  final String value;
  final double? height;
  const ProfileDetailDisplay({super.key, required this.name, required this.value, this.height});

  @override
  State<ProfileDetailDisplay> createState() => _ProfileDetailDisplayState();
}

class _ProfileDetailDisplayState extends State<ProfileDetailDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Container(
        height: widget.height ?? 30,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(color: Colors.white) 
        ),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 39, 39, 39),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50)
                  ),
                ),
                child: SelectableText(widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  )
                ),
              )
            ),
            Flexible(
              flex: 6,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Text(widget.value,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              ),
            )
          ]
        )
      )
    );
  }
}