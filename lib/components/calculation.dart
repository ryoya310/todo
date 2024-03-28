import '../imports.dart';

class Calculator extends StatefulWidget {
  final Function(String) saved;
  const Calculator({Key? key, required this.saved}): super(key: key);
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {

  bool showText = false;
  String output = '0';
  double sum = 0;
  List<dynamic> outputs = [];
  List<dynamic> middleOutputs = [];

  void buttonPressed(String buttonText) {
    // クリア
    if (buttonText == 'C') {
      outputs.clear();
      sum = 0;
    // 保存
    } else if (buttonText == 'S') {
      widget.saved(output);
      return;
    // パーセント
    } else if (buttonText == '%') {
      // 最初の入力が演算子の場合は無視
      if (outputs.isEmpty) {
        return;
      }
    // 四則計算または等号
    } else if (buttonText == '+' || buttonText == '-' || buttonText == '/' || buttonText == '*' || buttonText == '=') {
      // 最初の入力が演算子の場合は無視
      if (outputs.isEmpty && buttonText != '=') {
        return;
      }
      // 連続した演算子の入力を避ける
      if (outputs.isNotEmpty && (outputs.last == '+' || outputs.last == '-' || outputs.last == '/' || outputs.last == '*')) {
        outputs.removeLast();
      }
      // 等号ではない場合に演算子を追加
      if (buttonText != '=') {
        outputs.add(buttonText);
      }
    // 小数点
    } else if (buttonText == '.') {
      if (outputs.isEmpty || outputs.last.contains('.') || !RegExp(r'^\d+$').hasMatch(outputs.last)) {
        return;
      }
      outputs.last += buttonText;
    // 数値
    } else {
      // 配列が空でない、かつ最後の要素が数値であるかどうかをチェック
      if (outputs.isNotEmpty && RegExp(r'^\d+\.?\d*$').hasMatch(outputs.last)) {
        // 最後の要素が数値であれば、現在のボタンのテキストを連結
        outputs.last += buttonText;
      } else {
        // 配列が空、または最後の要素が数値でない場合は、新しい要素として追加
        outputs.add(buttonText);
      }
    }

    // 途中の式をディープコピー
    List<dynamic> middleOutputs = List<dynamic>.from(outputs);
    // 最後の計算
    if (buttonText == '=') {
      sum = _calculateResult(outputs);
      outputs.clear();
      outputs.add(sum.toString());
    // 途中の計算
    } else if (buttonText == '+' || buttonText == '-' || buttonText == '/' || buttonText == '*') {
      if (middleOutputs.last == '+' || middleOutputs.last == '-' || middleOutputs.last == '/' || middleOutputs.last == '*') {
        middleOutputs.removeLast();
      }
      sum = _calculateResult(middleOutputs);
    // 率の計算
    } else if (buttonText == '%') {
      sum = _calculateResult(outputs) / 100;
      outputs.clear();
      outputs.add(sum.toString());
    }
    setState(() {
      output = sum == sum.round() ? sum.toInt().toString() : sum.toString();
    });
  }

  double _calculateResult(List<dynamic> expr) {
    // 中置記法から逆ポーランド記法への変換
    List<String> rpn = _toReversePolishNotation(expr);
    // 逆ポーランド記法の式を計算
    return _evaluateRPN(rpn);
  }

  List<String> _toReversePolishNotation(List<dynamic> expr) {
    List<String> outputQueue = [];
    List<String> operatorStack = [];
    Map<String, int> precedence = {'+': 1, '-': 1, '*': 2, '/': 2};
    for (var token in expr) {
      if (double.tryParse(token) != null) {
        outputQueue.add(token.toString());
      } else if (precedence.containsKey(token)) {
        while (operatorStack.isNotEmpty && precedence[operatorStack.last]! >= precedence[token]!) {
          outputQueue.add(operatorStack.removeLast());
        }
        operatorStack.add(token);
      }
    }
    while (operatorStack.isNotEmpty) {
      outputQueue.add(operatorStack.removeLast());
    }
    return outputQueue;
  }

  double _evaluateRPN(List<String> rpn) {
    List<double> stack = [];
    for (String token in rpn) {
      if (double.tryParse(token) != null) {
        stack.add(double.parse(token));
      } else {
        if (stack.isNotEmpty) {
          double right = stack.removeLast();
          double left = stack.isNotEmpty ? stack.removeLast() : 0;
          switch (token) {
            case '+':
              stack.add(left + right);
              break;
            case '-':
              stack.add(left - right);
              break;
            case '*':
              stack.add(left * right);
              break;
            case '/':
              stack.add(left / right);
              break;
          }
        }
      }
    }
    if (stack.isNotEmpty) {
      return stack.first;
    }
    return 0;
  }

  Widget buildButton(String buttonText) {
    double fontSize = 25.0;
    Widget buttonContent = Text(
      buttonText,
      style: TextStyle(fontSize: fontSize),
    );
    Color buttonColor = Colors.grey;
    Color textColor = Colors.white;
    if (buttonText == 'S') {
      buttonColor = Colors.blue;
      buttonContent = Icon(
        LineIcons.saveAlt,
        size: fontSize
      );
    }
    if (buttonText == 'C' || buttonText == '%') {
      buttonColor = const Color.fromARGB(255, 205, 205, 205);
      textColor = Colors.black87;
      if (buttonText == 'C') {
        buttonContent = Icon(
          LineIcons.reply,
          size: fontSize
        );
      }
    }
    if (buttonText == '+' || buttonText == '-' || buttonText == '/' || buttonText == '*' || buttonText == '=') {
      buttonColor = Colors.orange;
      if (buttonText == '+') {
        buttonContent = Icon(
          LineIcons.plus,
          size: fontSize
        );
      }
      if (buttonText == '-') {
        buttonContent = Icon(
          LineIcons.minus,
          size: fontSize
        );
      }
      if (buttonText == '/') {
        buttonContent = Icon(
          LineIcons.divide,
          size: fontSize
        );
      }
      if (buttonText == '*') {
        buttonContent = Icon(
          LineIcons.times,
          size: fontSize
        );
      }
      if (buttonText == '=') {
        buttonContent = Icon(
          LineIcons.equals,
          size: fontSize
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 60,
        height: 60,
        child: OutlinedButton(
          onPressed: () => buttonPressed(buttonText),
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: buttonColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(0),
            elevation: 0,
            side: BorderSide.none,
          ).copyWith(
            alignment: Alignment.center,
          ),
          child: buttonContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 30, 30, 30),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 11.0),
              height: 24,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Column(children: [
                Text(
                  outputs.join(' '),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black87
                  )
                ),
              ])
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: output)).then((_) {
                  setState(() {
                    showText = true;
                  });
                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      showText = false;
                    });
                  });
                });
              },
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                height: 72,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Stack(children: [
                  if (showText)
                    const Positioned(
                      top: 1,
                      right: 3,
                      child: Text(
                        'copy!!',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.only(top: 4.0),
                    width: double.infinity,
                    child: Text(
                      formatNumber(double.parse(output)),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 48.0,
                        color: Colors.black87,
                      ),
                    ),
                  )
                ])
              ),
            ),
            Column(children: [
              Row(
                children: [buildButton('S'), buildButton('C'), buildButton('%'), buildButton('/')]
              ),
              Row(
                children: [buildButton('7'),buildButton('8'),buildButton('9'),buildButton('*')]
              ),
              Row(
                children: [buildButton('4'),buildButton('5'),buildButton('6'),buildButton('-')]
              ),
              Row(
                children: [buildButton('1'),buildButton('2'),buildButton('3'),buildButton('+')]
              ),
              Row(
                children: [buildButton('0'),buildButton('00'),buildButton('.'),buildButton('=')]
              ),
            ])
          ],
        ),
      ),
    );
  }
}