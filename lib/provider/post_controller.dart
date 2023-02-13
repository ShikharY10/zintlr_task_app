import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../db/config.dart';
import '../db/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostController with ChangeNotifier {
  final Posts _posts = Posts();
  final DataBase _db = getDataBase();
  bool _isFetchingPosts = false;

  String _oldHash = "";
  String _newHash = "";

  bool isExhosted() {
    var bytes = utf8.encode(_posts.posts.join(".")); // data being hashed

    var digest = sha1.convert(bytes);
    _newHash = digest.toString();
    if (_oldHash == _newHash) {
      _oldHash = _newHash;
      return true;
    } else {
      _oldHash = _newHash;
      return false;
    }
  }

  late http.Response _postFetchResponse;

  bool get isFetchingPost => _isFetchingPosts;
  List<String> get posts => _posts.posts;
  int get length => _posts.posts.length;
  bool get isEmpty => _posts.posts.isEmpty;

  Post getPost(int index) {
    Post post = Post();
    String postName = _posts.posts[index];
    String? savedPost = _db.get("posts", postName);
    if (savedPost != null) {
      post.toObject(savedPost);
    }
    return post;
  }

  String getRaw(int index) {
    return _posts.posts[index];
  }

  loadPostsFromLocalStorage() {
    _isFetchingPosts = true;
    notifyListeners();

    String? savedPosts = _db.get("posts", "posts");
    if (savedPosts != null) {
      _posts.toObject(savedPosts);
    }

    _isFetchingPosts = false;
    notifyListeners();
  }

  loadPostsFromServer() async {
    _isFetchingPosts = true;
    notifyListeners();

    User user = User();
    String? mySavedData = _db.get("settings", "myData");
    if (mySavedData != null) {
      user.toObject(mySavedData);
      Map host = GetIt.I.get<Map>(instanceName: "hosts");
      String url = "http://${host["SERVER_HOST"]}:8000/api/v1/getrandompost?id=${user.id}";
      _postFetchResponse = await http.get(Uri.parse(url));
      dynamic responseBody = json.decode(String.fromCharCodes(_postFetchResponse.bodyBytes));
      if (responseBody != null) {
        if (responseBody.isNotEmpty) {
          responseBody.forEach((element) {
            Post post = Post();
            post.caption = element["caption"];
            post.id = element["_id"];
            post.image = element["image"];
            post.parentId = element["parentId"];
            post.parentImagePublicId = element["parentAvatar"];
            for (var tag in element["tags"]) {
              post.tags.add((tag as String));
            }
            addPost(post);
          });
          if (isExhosted()) {
            _posts.posts.add("exhausted");
            notifyListeners();
            notifyListeners();
          }
          try {
            Future.delayed(const Duration(minutes: 1), () {
              print("Trying to remove");
              int index = _posts.posts.indexOf("exhausted");
              if (index != -1) {
                _posts.posts.removeAt(index);
                notifyListeners();
              }
            });
          } catch (e) {
            return;
          }
        }
      }
    }
    _isFetchingPosts = false;
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    if (!_db.isKeyPresent("posts", post.id!)) {
      if (_posts.posts.length == 20) {
        _posts.posts.removeAt(_posts.posts.length-1);
      }
      if (!_posts.posts.contains(post.id!)) {
        _posts.posts.insert(0, post.id!);
        // _posts.posts.add(post.id!);
        _db.set("posts", "posts", _posts.toString());
        _db.set("posts", post.id!, post.toString());
        notifyListeners();
      } 
    }
  }
}