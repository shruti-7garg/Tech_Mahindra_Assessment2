import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      home: CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'CLR') {
        input = '';
        result = '';
      } else if (value == 'ANS') {
        try {
          final res = _evaluateExpression(input);
          result = res.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  double _evaluateExpression(String expr) {
    // Replace % with /100 for percentage handling
    expr = expr.replaceAll('%', '/100');
    // Use Dart's built-in expression evaluator with safety
    Parser parser = Parser(expr);
    return parser.evaluate();
  }

  Widget buildButton(String text, {bool isOperator = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator ? Colors.pinkAccent : Colors.teal,
            padding: EdgeInsets.all(18),
          ),
          onPressed: () => buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALCULATOR APP'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black87,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  input,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    buildButton('7'),
                    buildButton('8'),
                    buildButton('9'),
                    buildButton('/', isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4'),
                    buildButton('5'),
                    buildButton('6'),
                    buildButton('*', isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1'),
                    buildButton('2'),
                    buildButton('3'),
                    buildButton('-', isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    buildButton('0'),
                    buildButton('.'),
                    buildButton('%', isOperator: true),
                    buildButton('+', isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    buildButton('CLR', isOperator: true),
                    buildButton('ANS', isOperator: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A simple parser to evaluate expressions (limited support)
class Parser {
  final String expression;
  int _pos = 0;

  Parser(this.expression);

  double evaluate() {
    _pos = 0;
    return _parseExpression();
  }

  double _parseExpression() {
    double left = _parseTerm();
    while (_pos < expression.length) {
      String op = expression[_pos];
      if (op == '+' || op == '-') {
        _pos++;
        double right = _parseTerm();
        if (op == '+') left += right;
        if (op == '-') left -= right;
      } else {
        break;
      }
    }
    return left;
  }

  double _parseTerm() {
    double left = _parseFactor();
    while (_pos < expression.length) {
      String op = expression[_pos];
      if (op == '*' || op == '/' || op == '%') {
        _pos++;
        double right = _parseFactor();
        if (op == '*') left *= right;
        if (op == '/') left /= right;
        if (op == '%') left %= right;
      } else {
        break;
      }
    }
    return left;
  }

  double _parseFactor() {
    StringBuffer sb = StringBuffer();
    while (_pos < expression.length &&
        (isDigit(expression[_pos]) || expression[_pos] == '.')) {
      sb.write(expression[_pos]);
      _pos++;
    }
    return double.tryParse(sb.toString()) ?? 0.0;
  }

  bool isDigit(String ch) => RegExp(r'\d').hasMatch(ch);
}
