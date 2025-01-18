import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _backgroundColor = Colors.red;
  bool _showColorPicker = false;
  int _flashDuration = 10; // Длительность вспышки в миллисекундах
  double _flashDelay =
      1.0; // Измените тип на double и установите начальное значение

  bool _isFlashing = false;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  void _toggleColorPicker() {
    setState(() {
      _showColorPicker = !_showColorPicker;
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }

  Future<void> _triggerFlash() async {
    try {
      if (await TorchLight.isTorchAvailable()) {
        await TorchLight.enableTorch();
        await Future.delayed(Duration(milliseconds: _flashDuration));
        await TorchLight.disableTorch();
      }
    } catch (e) {
      debugPrint("Error controlling torch: $e");
    }
  }

  void _manageFlashingTimer() {
    if (_isFlashing) {
      _flashTimer?.cancel();
      setState(() {
        _isFlashing = false;
      });
    } else {
      setState(() {
        _isFlashing = true;
      });
      _flashTimer = Timer.periodic(
        Duration(
            milliseconds:
                (_flashDelay * 1000).round()), // Преобразование double в int
        (timer) {
          _triggerFlash();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _backgroundColor,
        body: GestureDetector(
          onTap: _toggleColorPicker,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              Center(
                child: _showColorPicker
                    ? Column(
                        children: [
                          Expanded(
                            flex:
                                2, // Этот flex делит секцию на 2 части: верхнюю и нижнюю
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4, // Верхняя четверть экрана
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.black.withOpacity(
                                        0.1), // Фон для визуального разделения (опционально)
                                    child: MaterialButton(
                                      onPressed: _triggerFlash,
                                      color: Colors.black.withOpacity(0.5),
                                      child: Icon(Icons.flash_on,
                                          color: Colors.white, size: 40),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3, // Остальные три четверти
                                  child: Column(
                                    children: [
                                      MaterialButton(
                                        onPressed: _manageFlashingTimer,
                                        color: _isFlashing
                                            ? Colors.red
                                            : Colors.green,
                                        child: Text(
                                            _isFlashing ? 'Stop' : 'Cycle'),
                                        minWidth:
                                            MediaQuery.of(context).size.width -
                                                20,
                                      ),
                                      const SizedBox(height: 20),
                                      Slider(
                                        value: _flashDuration.toDouble(),
                                        min: 10,
                                        max: 1000,
                                        divisions: 99,
                                        label: '${_flashDuration}ms',
                                        onChanged: (value) {
                                          setState(() {
                                            _flashDuration = value.round();
                                          });
                                        },
                                      ),
                                      Slider(
                                        value: _flashDelay
                                            .toDouble(), // Преобразуем значение в double
                                        min: 0.2, // Минимальное значение
                                        max: 10.0, // Максимальное значение
                                        divisions:
                                            98, // Количество делений: (10.0 - 0.2) / 0.1 = 98
                                        label:
                                            '${_flashDelay.toStringAsFixed(1)}s', // Отображаем значение с одним десятичным знаком
                                        onChanged: (value) {
                                          setState(() {
                                            _flashDelay = double.parse(
                                                value.toStringAsFixed(
                                                    1)); // Округляем до 1 знака
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ColorPicker(
                              pickerColor: _backgroundColor,
                              onColorChanged: _onColorChanged,
                              pickerAreaHeightPercent: 1,
                              paletteType: PaletteType.hueWheel,
                              portraitOnly: true,
                            ),
                          ),
                        ],
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
    WakelockPlus.disable();
    _flashTimer?.cancel();
    super.dispose();
  }
}
