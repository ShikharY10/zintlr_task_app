import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zintlr_internship_task/utils/widgets/submit_btn.dart';
import '../db/config.dart';
import '../db/models.dart';
import '../provider/image_upload.dart';
import '../provider/post_controller.dart';
import '../utils/widgets/tags.dart';
import '../utils/widgets/text_box.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  late DataBase db;
  late FetchImage imagePicker;
  late CloudImage uploadImage;
  late PostController postController;
  late User user;

  TextEditingController captionController = TextEditingController();
  TextEditingController tagSearchController = TextEditingController();
  List<String> tags = [];

  initializeProviders() {
    imagePicker = Provider.of<FetchImage>(context);
    uploadImage = Provider.of<CloudImage>(context);
    postController = Provider.of<PostController>(context);
  }

  @override
  void initState() {
    db = getDataBase();
    user = User();
    String? mySavedData = db.get("settings", "myData");
    if (mySavedData != null) {
      user.toObject(mySavedData);
    }
    super.initState();
  }

  @override
  void dispose() {
    uploadImage.erase();
    imagePicker.erase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeProviders();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Post"),
        centerTitle:  true,
      ),
      body: Container(
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
        // color: Colors.black,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 58, 58, 58),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: (imagePicker.isFileSelected && uploadImage.isUploadingCompleted)
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: FileImage(File(imagePicker.filePath)),
                        alignment: Alignment.center,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            child: (imagePicker.isFileSelected && !uploadImage.isUploadingCompleted )
                            ? const CircularProgressIndicator()
                            : IconButton(
                              splashRadius: 25,
                              splashColor: Colors.black,
                              icon: const Icon(Icons.photo_size_select_actual_rounded),
                              onPressed: () async {
                                await imagePicker.pickImage();
                                if (imagePicker.isFileSelected) {
                                  await uploadImage.upload(File(imagePicker.filePath));
                                }
                              },
                            ),
                          ),
                        ),
                        Text((imagePicker.isFileSelected && !uploadImage.isUploadingCompleted) 
                          ? "Uploading Image" : "Select Image",
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                      ],
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CustomTextBox(
                    "Caption",
                    MediaQuery.of(context).size.width/1.2,
                    captionController
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
                  label: const Text("Add Post",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    )
                  ),
                  validator: () {
                    if (uploadImage.isUploadingCompleted && captionController.text.isNotEmpty && tags.isNotEmpty) {
                      return true;
                    }
                    return true;
                  },
                  onTap: () => onTap(),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  onTap() async {
    Map host = GetIt.I.get<Map>(instanceName: "hosts");

    String path = "http://${host["SERVER_HOST"]}:8000/api/v1/addpost";
    Map<String, dynamic> body = {
      "parentId": user.id,
      "parentAvatar": user.image!.publicId,
      "caption": captionController.text,
      "tags": tags,
      "image": uploadImage.publicId
    };
    String jsonBody = json.encode(body);
    http.Response response = await http.post(
      Uri.parse(path),
      body: jsonBody
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(String.fromCharCodes(response.bodyBytes));
    
      Posts myPosts = Posts();
      String? mySavedPosts = db.get("settings", "myPosts");
      if (mySavedPosts != null) {
        myPosts.toObject(mySavedPosts);
      }

      Post myPost = Post();
      myPost.id = responseBody["_id"];
      myPost.caption = captionController.text;
      myPost.image = uploadImage.publicId;
      myPost.parentId = user.id;
      myPost.parentImagePublicId = user.image!.publicId;
      myPost.tags = tags;
      db.set("settings", responseBody["_id"], myPost.toString());
      myPosts.posts.insert(0, responseBody["_id"]);
      // myPosts.posts.add(responseBody["_id"]);
      db.set("settings", "myPosts", myPosts.toString());

      postController.addPost(myPost);
      Navigator.pop(context);
    }
  }  
}