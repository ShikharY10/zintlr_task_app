import 'dart:io';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/config.dart';
import '../db/models.dart';
import '../provider/image_upload.dart';
import '../utils/widgets/submit_btn.dart';
import '../utils/widgets/tags.dart';
import '../utils/widgets/text_box.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController tagSearchController = TextEditingController();

  List<String> tags = [];
  bool isRegistering = false;

  late Future<List<dynamic>> futureResult;
  late List<dynamic> searchResult;
  late DataBase db;
  late FetchImage imagePicker;
  late CloudImage uploadImage;

  @override
  void initState() {
    super.initState();
    db = getDataBase();
  }

  initializeProviders() {
    imagePicker = Provider.of<FetchImage>(context);
    uploadImage = Provider.of<CloudImage>(context);
  }

  @override
  Widget build(BuildContext context) {
    initializeProviders();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal:10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text("REGISTRATION",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2
                          )
                        ),
                      ),
                      Badge(
                        padding: const EdgeInsets.all(5),
                        smallSize: 30,
                        largeSize: 40,
                        alignment: AlignmentDirectional.topCenter,
                        label: Material(
                          type: MaterialType.transparency,
                          child: (imagePicker.isFileSelected && !uploadImage.isUploadingCompleted)
                            ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                            : IconButton(
                              splashRadius: 20,
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await imagePicker.pickImage();
                                if (imagePicker.isFileSelected) {
                                  await uploadImage.upload(File(imagePicker.filePath));
                                }
                              },
                            ),
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: imagePicker.isFileSelected ? null : Colors.grey,
                          backgroundImage: imagePicker.isFileSelected ? FileImage(File(imagePicker.filePath)) : null,
                          child: (imagePicker.isFileSelected && !uploadImage.isUploadingCompleted) 
                            ? Container(
                                alignment: Alignment.center,
                                child: Text(
                                  uploadImage.isError
                                   ? "Sometthing Bad Happen!"
                                   : uploadImage.getUploadData)
                              ) 
                            : null,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomTextBox(
                          "username",
                          MediaQuery.of(context).size.width/1.2,
                          usernameController
                        ),
                      ),
                      ShowTags(
                        tags: tags,
                        width: MediaQuery.of(context).size.width/1.2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/1.2,
                          height: 40,
                          child: TextFormField(
                            style: const TextStyle(color: Color.fromARGB(255, 255, 246, 167)),
                            strutStyle: const StrutStyle(
                              height: 1.5,
                            ),
                            controller: tagSearchController,
                            decoration: InputDecoration(
                              // suff
                              suffixIcon: tagSearchController.text.isNotEmpty ? Material(
                                type: MaterialType.transparency,
                                child: IconButton(
                                  splashRadius: 20,
                                  icon: const Icon(Icons.check), 
                                  onPressed: () {
                                    setState(() {
                                      tags.add("#${tagSearchController.text}");
                                    });
                                    tagSearchController.clear();
                                  }
                                ),
                              ) : null,
                              filled: true,
                              fillColor: const Color.fromARGB(255, 58, 58, 58),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                                )
                              ),
                              hintText: "tags",
                              hintStyle: const TextStyle(color: Color.fromARGB(255, 136, 108, 55)),
                            ),
                            onChanged: (tag) => setState(() {}),
                          ),
                        ),
                      ),
                      SubmitButton(
                        width: 200,
                        height: 40,
                        label: isRegistering 
                          ? const CircularProgressIndicator() 
                          : const Text("Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              )
                            ),
                        validator: () => validator(),
                        onTap: () async {
                          onTap();
                        },
                      )
                    ]
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }

  bool validator() {
    if (uploadImage.isUploadingCompleted && usernameController.text.isNotEmpty && tags.isNotEmpty) {
      return true;
    }
    return false;
  }

  onTap() async {
    setState(() {
      isRegistering = true;
    });
    Map host = GetIt.I.get<Map>(instanceName: "hosts");
    String path = "http://${host["SERVER_HOST"]}:8000/api/v1/register";
    Map<String, dynamic> body = {
      "username" : usernameController.text,
      "tags" : tags,
      "avatar" : {
        "secureUrl": uploadImage.secureUrl,
        "publicId": uploadImage.publicId
      }
    };
    String jsonBody = json.encode(body);
    http.Response response = await http.post(
      Uri.parse(path),
      body: jsonBody
    );
    if (response.statusCode == 200) {
      setState(() {
        isRegistering = false;
      });

      Map<String, dynamic> responseBody = json.decode(String.fromCharCodes(response.bodyBytes));

      ImageData avatar = ImageData(
        publicId: uploadImage.publicId,
        secureUrl: uploadImage.secureUrl,
        localData: base64.encode(imagePicker.imageBytes),
      );

      User user = User();
      user.id = responseBody["_id"];
      user.tags = tags;
      user.username = usernameController.text;
      user.image = avatar;
      String saveMyData = user.toString();
      db.set("settings", "myData", saveMyData);
      db.set("settings", "registed", "1");
      imagePicker.erase();
      uploadImage.erase();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home())
      );
    }
  }
}