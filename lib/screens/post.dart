import 'package:flutter/material.dart';

import '../db/models.dart';

class UserPost extends StatelessWidget {
  final Post post;
  const UserPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(post.parentImagePublicId!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("ID : ${post.parentId}",
                    style: const TextStyle(
                      color: Colors.white
                    )
                  ),
                )
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image(
                image: NetworkImage(post.image!),
                alignment: Alignment.center,
                height: 280,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(post.caption!,
                style: TextStyle(color: Colors.white)
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5),
              child: Row(
                children: [
                  for (int i=0; i<post.tags.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Container(
                        width: calcTextSize(post.tags[i], const TextStyle(fontSize: 14)).width + 20,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(post.tags[i],
                            style: const TextStyle(
                              color: Colors.white
                            )
                          ),
                        )
                      ),
                    )
                ]
              ),
            )
          )

        ]
      )
    );
  }

  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

}