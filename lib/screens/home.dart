import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/config.dart';
import '../db/models.dart';
import '../provider/post_controller.dart';
import 'add_post.dart';
import 'post.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Color addPostBtnColor = Colors.black;
  Color refreshBtnColor = Colors.black;
  bool isFetchingPosts = false;
  late Posts posts;
  late DataBase db;
  late PostController postController;

  @override
  void initState() {
    super.initState();
    db = getDataBase();
    Future.delayed(Duration.zero, () {
      postController.loadPostsFromLocalStorage();
      postController.loadPostsFromServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    postController = Provider.of<PostController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zintlr Task"),
        actions: [
          actionButton(postController.isFetchingPost 
            ? const CircularProgressIndicator()
            : const Text("Refresh"), refreshBtnColor, 
            onTap: () {
              setState(() {
                refreshBtnColor = const Color.fromARGB(255, 61, 61, 61);
              });
              postController.loadPostsFromServer();
            },
            onEnd: () {
              setState(() {
                refreshBtnColor = Colors.black;
              });
            }
          ),
          
          actionButton(const Text("Add Post"), addPostBtnColor, 
            onTap: () {
              setState(() {
                addPostBtnColor = const Color.fromARGB(255, 61, 61, 61);
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPost())
              );
            },
            onEnd: () {
              setState(() {
                addPostBtnColor = Colors.black;
              });
            }
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile())
              );
            },
          )
        ],
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          child: (!postController.isEmpty)
              ? ListView.builder(
                  itemCount: postController.length,
                  itemBuilder: (BuildContext contex, int index) {
                    if (postController.getRaw(index) == "exhausted") {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                        child: Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Image(
                                  image: AssetImage("assets/images/giphy.gif"),
                                  alignment: Alignment.center,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text("No More Posts, No More Fetch!")
                          ]
                        ),
                      );
                    } else {
                      Post post = postController.getPost(index);
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          right: 10, 
                          left: 10,
                          bottom: (postController.length-1 == index) ? 10 : 0
                        ),
                        child: UserPost(post: post),
                      );
                    }
                    
                  }
                ) : const Center(
                  child: Text("Feed Empty",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )
                  )
                )
        )
      ),
    );
  }

  Widget actionButton(Widget label, Color btnColor, {void Function()? onTap, void Function()? onEnd}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          width: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: const BorderRadius.all(Radius.circular(50))
          ),
          onEnd: onEnd,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: label,
          ),
        ),
      ),
    );
  }
}
