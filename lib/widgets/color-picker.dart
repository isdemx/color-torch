// Вставьте этот код вместо предыдущего определения ColorPicker

import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Function(Color) onSelectColor;

  const ColorPicker({Key? key, required this.onSelectColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Предположим, что мы каким-то образом вычисляем цвет при нажатии:
    // Здесь должна быть ваша логика для выбора цвета
    return GestureDetector(
      onTap: () => onSelectColor(Colors.red), // Пример выбора цвета
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red, // Примерный цвет для демонстрации
        ),
      ),
    );
  }
}
