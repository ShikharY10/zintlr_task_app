import 'package:flutter/material.dart';
import '../db/config.dart';
import '../db/models.dart';
import 'post.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  late DataBase db;
  late Posts posts;

  @override
  void initState() {
    super.initState();
    db = getDataBase();

    posts = Posts();
    String? savedPosts = db.get("settings", "myPosts");
    if (savedPosts != null) {
      posts.toObject(savedPosts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Posts")),
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
        child: (posts.posts.isEmpty) 
          ? const Center(child: Text("You have not posted content yet"))
          : ListView.builder(
            itemCount: posts.posts.length,
            itemBuilder: (context, index) {
              Post post = Post();
              String? savedPost = db.get("settings", posts.posts[index]);
              if (savedPost != null) {
                post.toObject(savedPost);
                return Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    right: 10, 
                    left: 10,
                    bottom: (posts.posts.length-1 == index) ? 10 : 0
                  ),
                  child: UserPost(post: post),
                );
              } 
            }
          )
      )
    );
  }
}