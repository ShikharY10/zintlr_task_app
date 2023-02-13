import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../db/config.dart';

class DeleteAccount extends StatefulWidget {
  final String id;
  const DeleteAccount({super.key, required this.id});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      icon: const Icon(Icons.delete, color: Colors.white),
      title: const Text("Delete Account?",
        style: TextStyle(
          color: Colors.white,
        )
      ),
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: const Text("Cancel")
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: const Text("Delete")
                ),
                onTap: () async {
                  print("Delete Button Working");
                  Map host = GetIt.I.get<Map>(instanceName: "hosts");
                  String path = "http://${host["SERVER_HOST"]}:8000/api/v1/delete?id=${widget.id}";
                  http.Response response = await http.get(Uri.parse(path));
                  if (response.statusCode == 200) {
                    DataBase db = getDataBase();
                    db.clearBox("settings");
                    db.clearBox("posts");
                    Phoenix.rebirth(context);
                    Phoenix.rebirth(context);
                  } else {
                    return;
                  }
                  
                },
              )
            ),
          ]
        ),
      ),
    );
  }
}