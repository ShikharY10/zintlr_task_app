import 'dart:async';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zintlr_internship_task/provider/post_controller.dart';
import 'package:yaml/yaml.dart';
import 'db/config.dart';
import 'provider/image_upload.dart';
import 'screens/home.dart';
import 'screens/register.dart';

class ZintlrTaskApp extends StatefulWidget {
  final DataBase db;
  const ZintlrTaskApp({super.key, required this.db});

  @override
  State<ZintlrTaskApp> createState() => _ZintlrTaskAppState();
}

class _ZintlrTaskAppState extends State<ZintlrTaskApp> {

  @override
  Widget build(BuildContext context) {
    bool isRegistered = false;
    String? result = widget.db.get("settings", "registed");
    if (result != null) {
      isRegistered = true;
    }
    return MaterialApp(
      title: "Zintlr",
      debugShowCheckedModeBanner: false,
      home: isRegistered ? const Home() : const Register(),
    );
  }
}

Future<Map> getDynamicRoutes() async {
    try {
      String path = "https://raw.githubusercontent.com/ShikharY10/zintlr_task_server/main/config/config.yaml";
      http.Response response = await http.get(
        Uri.parse(path)
      );
      if (response.statusCode == 200) {
        String fileContent = String.fromCharCodes(response.bodyBytes);
        Map yaml = loadYaml(fileContent);
        print("Config Loading Successful: ${yaml["SERVER_HOST"]}");
        return yaml;
      }
    } catch (e) {
      return {};
    }
    return {};
  }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  // initializing hive database;
  DataBase db = DataBase();
  await db.initilizeHive(directory.path);
  GetIt.I.registerSingleton<DataBase>(db, instanceName: "db");
  Map hosts = await getDynamicRoutes();
  GetIt.I.registerSingleton<Map>(hosts, instanceName: "hosts");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:(_)=> CloudImage(),
        ),
        ChangeNotifierProvider(
          create:(_)=> FetchImage(),
        ),
        ChangeNotifierProvider(
          create:(_)=> PostController(),
        )
      ],
      child: Phoenix(child: ZintlrTaskApp(db: db))
    ),
  );
}


