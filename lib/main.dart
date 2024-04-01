import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _backgroundColor = Colors.red; // Начальный цвет фона
  bool _showColorPicker = false; // Состояние видимости ColorPicker

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  void _toggleColorPicker() {
    setState(() {
      _showColorPicker = !_showColorPicker;
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      _backgroundColor = color;

      // _showColorPicker = false; // Скрываем ColorPicker после выбора цвета
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _backgroundColor,
        body: GestureDetector(
          onTapUp: (TapUpDetails details) {
            _toggleColorPicker();
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              Center(
                child: _showColorPicker
                    ? SizedBox(
                        width: 320,
                        height: 500,
                        child: ColorPicker(
                          pickerColor: _backgroundColor,
                          onColorChanged: _onColorChanged,
                          pickerAreaHeightPercent: 1,
                          paletteType: PaletteType.hueWheel,
                          portraitOnly: true,
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }
}
