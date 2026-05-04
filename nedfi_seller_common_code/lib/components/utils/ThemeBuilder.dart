import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;

  const ThemeBuilder(
      {super.key,
      required this.builder,
      this.defaultBrightness = Brightness.light});

  @override
  ThemeBuilderState createState() => ThemeBuilderState();

  static ThemeBuilderState of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeBuilderState>()!;
  }
}

class ThemeBuilderState extends State<ThemeBuilder> {
  Brightness? _brightness;
  var isDarkMode = false;

  @override
  void initState() {
    _brightness = widget.defaultBrightness;
    if (mounted) {
      setState(() {});
    }
    super.initState();
  }

  void changeTheme() {
    setState(() {
      /*_brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;*/
    });
  }

  Brightness getCurrentTheme() {
    return _brightness!;
  }

  @override
  Widget build(BuildContext context) {
    if (isDarkMode) {
      _brightness = Brightness.light;
      return widget.builder(context, _brightness!);
    } else {
      _brightness = Brightness.light;
      return widget.builder(context, _brightness!);
    }
  }
}
