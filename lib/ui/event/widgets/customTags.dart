import 'dart:async';

import 'package:assessment/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AppTagsCustom extends StatefulWidget {
  String tag;
  Function() onDeleted;

  AppTagsCustom({required this.tag, required this.onDeleted});

  @override
  State<AppTagsCustom> createState() => _AppTagsCustomState();
}

class _AppTagsCustomState extends State<AppTagsCustom>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    print(widget.tag);
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    doSomething();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Timer? _timer;
  int _pos = 0;
  late AnimationController _animationController;
  List<Color> arrColors = [AppConfig.colors.blue,AppConfig.colors.themeColor];

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
          padding: const EdgeInsets.only(right: 4, top: 2, bottom: 6),
          child: Chip(
              backgroundColor: arrColors[_pos],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              label: Text(
                widget.tag,
                style: TextStyle(color: _pos == 0 ? AppConfig.colors.grey : Colors.white),
              ),
              deleteIcon: Icon(
                Icons.clear,
                size: 16,
                color: _pos == 0 ? AppConfig.colors.grey : Colors.white,
              ),
              onDeleted: widget.onDeleted)),
    );
  }

  Future<void> doSomething() async {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (t.tick > 1) {
        setState(() {
          _animationController.forward();
          _timer?.cancel();
          _pos = 1;
        });
      }
    });
  }
}
