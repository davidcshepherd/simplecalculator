import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Simple Calculator',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const CalculatorPage(),
  );
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  String history = '';
  double? first;
  String? operation;
  bool fresh = false;

  String format(double value) {
    if (!value.isFinite) return 'Error';
    if (value == 0) return '0';
    final text = value.toString();
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  double calculate(double a, double b, String op) => switch (op) {
    '+' => a + b,
    '−' => a - b,
    '×' => a * b,
    '÷' => a / b,
    _ => b,
  };

  void press(String key) {
    setState(() {
      if (key == 'AC') {
        display = '0';
        history = '';
        first = null;
        operation = null;
        fresh = false;
      } else if (key == '⌫') {
        if (fresh || display == 'Error') return;
        display =
            display.length <= 1 ||
                (display.length == 2 && display.startsWith('-'))
            ? '0'
            : display.substring(0, display.length - 1);
      } else if (key == '+/−') {
        if (display == '0' || display == 'Error') return;
        display = display.startsWith('-') ? display.substring(1) : '-$display';
      } else if (key == '.') {
        if (fresh || display == 'Error') {
          display = '0.';
          fresh = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
      } else if (int.tryParse(key) != null) {
        if (fresh || display == '0' || display == 'Error') {
          display = key;
          fresh = false;
        } else if (display.length < 16) {
          display += key;
        }
      } else if (key == '=') {
        if (first == null || operation == null) return;
        final second = double.tryParse(display) ?? 0;
        history = '${format(first!)} $operation ${format(second)} =';
        display = format(calculate(first!, second, operation!));
        first = null;
        operation = null;
        fresh = true;
      } else {
        final current = double.tryParse(display);
        if (current == null) return;
        if (first != null && operation != null && !fresh) {
          display = format(calculate(first!, current, operation!));
        }
        first = double.tryParse(display);
        operation = key;
        history = '$display $key';
        fresh = true;
      }
    });
  }

  Widget button(String label, {int flex = 1}) {
    final operator = ['+', '−', '×', '÷'].contains(label);
    final utility = ['AC', '⌫', '+/−'].contains(label);
    final color = label == '='
        ? const Color(0xFFB8F478)
        : operator
        ? const Color(0xFF303B2D)
        : utility
        ? const Color(0xFF34363D)
        : const Color(0xFF24262D);
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: AspectRatio(
          aspectRatio: flex.toDouble(),
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => press(label),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: label == '='
                        ? const Color(0xFF17200D)
                        : operator
                        ? const Color(0xFFB8F478)
                        : Colors.white,
                    fontSize: utility ? 24 : 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF101116),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'CALCULATOR',
                    style: TextStyle(
                      color: Color(0xFFB8F478),
                      letterSpacing: 3,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          history,
                          style: const TextStyle(
                            color: Color(0xFF92949F),
                            fontSize: 21,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            display,
                            key: const Key('display'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 76,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 394,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              button('AC'),
                              button('⌫'),
                              button('+/−'),
                              button('÷'),
                            ],
                          ),
                          Row(
                            children: [
                              button('7'),
                              button('8'),
                              button('9'),
                              button('×'),
                            ],
                          ),
                          Row(
                            children: [
                              button('4'),
                              button('5'),
                              button('6'),
                              button('−'),
                            ],
                          ),
                          Row(
                            children: [
                              button('1'),
                              button('2'),
                              button('3'),
                              button('+'),
                            ],
                          ),
                          Row(
                            children: [
                              button('0', flex: 2),
                              button('.'),
                              button('='),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
