import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final double width;
  final double height;
  final Widget label;
  final void Function() onTap;
  final bool Function() validator;
  const SubmitButton({
    super.key,
    required this.width,
    required this.height,
    required this.label,
    required this.onTap,
    required this.validator
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  Color addPostBtnColor = const Color.fromARGB(255, 58, 58, 58);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: AnimatedContainer(
          width: 200,
          height: 40,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: addPostBtnColor,
            borderRadius: const BorderRadius.all(Radius.circular(50))
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: widget.label,
          ),
          onEnd: () {
            setState(() {
              addPostBtnColor = const Color.fromARGB(255, 58, 58, 58);
            });
          },
        ),
        onTap: () {
          if (widget.validator()) {
            setState(() {
              addPostBtnColor = const Color.fromARGB(255, 83, 83, 83);
            });
            widget.onTap();
          }
          
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Home())
          // );
        },
      ),
    );
  }
}