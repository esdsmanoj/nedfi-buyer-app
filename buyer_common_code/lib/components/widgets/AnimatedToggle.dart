import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;
  int? initialPosition;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    required this.initialPosition,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.borderColor = const Color(0xFFe7e7e8),
  });
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool initialPosition = false;

  @override
  void initState() {
    super.initState();
    initialPosition=widget.initialPosition==0?true:false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.6,
      height: Get.width * 0.13,
      margin: EdgeInsets.only(left: 20,top: 10,bottom: 10),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: 140,
              height: Get.width * 0.13,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                  border: Border.all(color: widget.borderColor),
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  widget.values.length,
                      (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                        fontFamily: 'Graphik',
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xAA000000),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
            initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 75,
              height: Get.width * 0.13,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  fontFamily: 'Graphik',
                  fontSize: Get.width * 0.045,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}