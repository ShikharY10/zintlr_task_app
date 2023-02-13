
import 'package:flutter/material.dart';

class ShowTags extends StatelessWidget {
  final List<String> tags;
  final double width;
  const ShowTags({super.key, required this.tags, required this.width});

  @override
  Widget build(BuildContext context) {
    return (tags.isNotEmpty) ? Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: width,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (int i=0; i< tags.length; i++)
              Container(
                width: calcTextSize(tags[i], const TextStyle(fontSize: 14)).width + 20,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(tags[i],
                    style: const TextStyle(
                      color: Colors.white
                    )
                  ),
                )
              )
          ]
        )
      ),
    ) : const SizedBox();
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