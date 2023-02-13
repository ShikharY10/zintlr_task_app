import 'dart:convert';

class User {
  String? id;
  ImageData? image;
  String? username;
  List<String> tags = [];
  User({this.id, this.image, this.username});

  @override
  String toString() {
    Map<String, dynamic> mapData = {};
    mapData["id"] = id;
    mapData["image"] = base64.encode(image!.toString().codeUnits);
    mapData["username"] = username;
    mapData["tags"] = tags;
    return json.encode(mapData);
  }

  showData() {
    print("Id: $id");
    print("Image: $image");
    print("Username: $username");
    print("tags: $tags");
  }

  toObject(String jsonEncoded) {
    Map<String, dynamic> mapData = json.decode(jsonEncoded);
    id = mapData["id"];
    ImageData imageData = ImageData();
    imageData.toObejct(String.fromCharCodes(base64.decode(mapData["image"])));
    image = imageData;
    username = mapData["username"];
    for (var tag in mapData["tags"]) {
      tags.add((tag as String));
    }
  }
}

class Posts {
  List<String> posts = [];

  @override
  String toString() {
    String jsonEncode = json.encode(posts);
    return jsonEncode;
  }

  toObject(String jsonEncoded) {
    List<dynamic> postNames = json.decode(jsonEncoded);
    postNames.forEach((value) {
      posts.add(value);
    });
  }
}

class Post {
  String? id;
  String? parentId;
  String? parentImagePublicId;
  String? caption;
  String? image;
  List<String> tags = [];

  Post({
    this.id,
    this.parentId,
    this.parentImagePublicId,
    this.caption,
    this.image,
  });

  @override
  String toString() {
    Map<String, dynamic> mapData = {};
    mapData["id"] = id;
    mapData["parentId"] = parentId;
    mapData["parentImagePublicId"] = parentImagePublicId;
    mapData["caption"] = caption;
    mapData["image"] = image;
    mapData["tags"] = tags;
    return json.encode(mapData);
  }

  toObject(String jsonEncoded) {
    Map<String, dynamic> mapData = json.decode(jsonEncoded);
    id = mapData["id"];
    parentId = mapData["parentId"];
    parentImagePublicId = mapData["parentImagePublicId"];
    caption = mapData["caption"];
    image = mapData["image"];
    // tags = mapData["tags"] ?? [];
    for (var tag in mapData["tags"] ?? []) {
      tags.add((tag as String));
    }

  }
}

class ImageData {
  String? publicId;
  String? secureUrl;
  String? localData;

  ImageData(
    {this.publicId,
    this.secureUrl,
    this.localData}
  );

  @override
  String toString() {
    Map<String, dynamic> mapData = {};
    mapData["publicId"] = publicId;
    mapData["secureUrl"] = secureUrl;
    mapData["localData"] = localData;
    return json.encode(mapData);
  }

  toObejct(String jsonData) {
    Map<String, dynamic> mapData = json.decode(jsonData);
    publicId = mapData["publicId"];
    secureUrl = mapData["secureUrl"];
    localData = mapData["localData"];
  }
}