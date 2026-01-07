import 'dart:js';
import 'dart:html';
import 'kalkulator.dart';

String currentInput = '';
String operator = '';
double? firstValue;

void main() {
  // Event listener tombol HTML
  window.onClick.listen((event) {
    final target = event.target;
    if (target is ButtonElement) {
      final label = target.text ?? '';
      if (label == 'C') {
        clearDisplay();
      } else if (label == '=') {
        calculate();
      } else if (['+', '-', '×', '÷'].contains(label)) {
        setOperator(label);
      } else if (label == '⌫') {
        backspace();
      } else {
        input(label);
      }
    }
  });

  // Hubungkan fungsi ke global JS agar bisa dipanggil dari HTML
  context['input'] = input;
  context['setOperator'] = setOperator;
  context['calculate'] = calculate;
  context['clearDisplay'] = clearDisplay;
  context['backspace'] = backspace;

  updateDisplay('0');
}

void input(String value) {
  currentInput += value;

  // Tampilkan ekspresi lengkap jika operator sudah dipilih
  if (operator.isNotEmpty && firstValue != null) {
    updateDisplay('${firstValue!.toString()} $operator $currentInput');
  } else {
    updateDisplay(currentInput);
  }
}

void setOperator(String op) {
  if (currentInput.isEmpty) return;

  firstValue = double.tryParse(currentInput);
  operator = op;

  // Tampilkan ekspresi awal: "18 +"
  updateDisplay('${firstValue!.toString()} $operator');

  currentInput = '';
}

void calculate() {
  if (firstValue == null || currentInput.isEmpty) return;
  double? secondValue = double.tryParse(currentInput);
  if (secondValue == null) return;

  double result;
  try {
    switch (operator) {
      case '+':
        result = tambah(firstValue!, secondValue);
        break;
      case '-':
        result = kurang(firstValue!, secondValue);
        break;
      case '×':
        result = kali(firstValue!, secondValue);
        break;
      case '÷':
        result = bagi(firstValue!, secondValue);
        break;
      default:
        updateDisplay('Operasi tidak dikenali');
        return;
    }

    // Tampilkan ekspresi dan hasil: "18 + 2 = 20"
    updateDisplay('${firstValue!.toString()} $operator ${secondValue.toString()} = $result');

    currentInput = result.toString();
    firstValue = null;
    operator = '';
  } catch (e) {
    updateDisplay('Error');
  }
}

void clearDisplay() {
  currentInput = '';
  operator = '';
  firstValue = null;
  updateDisplay('0');
}

void backspace() {
  if (currentInput.isNotEmpty) {
    currentInput = currentInput.substring(0, currentInput.length - 1);
  } else if (operator.isNotEmpty) {
    operator = '';
  }

  if (operator.isNotEmpty && firstValue != null) {
    updateDisplay('${firstValue!.toString()} $operator $currentInput');
  } else {
    updateDisplay(currentInput.isEmpty ? '0' : currentInput);
  }
}

void updateDisplay(String text) {
  Element? display = querySelector('#display');
  if (display != null) {
    display.text = text;
  } else {
    print('Elemen #display tidak ditemukan');
  }
}