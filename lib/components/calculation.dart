import 'package:math_expressions/math_expressions.dart';
import '../imports.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}): super(key: key);
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {

  String output = '0';
  double sum = 0;
  List<String> outputs = [];
  List<String> middleOutputs = [];

  void buttonPressed(String buttonText) {
    // クリア
    if (buttonText == 'C') {
      outputs.clear();
      sum = 0;
    // 保存
    } else if (buttonText == 'S') {
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

    List<String> middleOutputs = List<String>.from(outputs);
    output = outputs.join('');
    // 最後の計算
    if (buttonText == '=') {
      sum = _calculateResult(output);
      outputs.clear();
      outputs.add(sum.toString());
    // 途中の計算
    } else if (buttonText == '+' || buttonText == '-' || buttonText == '/' || buttonText == '*') {
      if (middleOutputs.last == '+' || middleOutputs.last == '-' || middleOutputs.last == '/' || middleOutputs.last == '*') {
        middleOutputs.removeLast();
      }
      sum = _calculateResult(middleOutputs.join(''));
    // 率の計算
    } else if (buttonText == '%') {
      sum = _calculateResult(output) / 100;
      outputs.clear();
      outputs.add(sum.toString());
    } else {
      if (outputs.length <= 1) {
        sum = _calculateResult(output);
      } else {
        _calculateResult(output);
      }
    }
    setState(() {
      output = sum == sum.round() ? sum.toInt().toString() : sum.toString();
    });
  }

  double _calculateResult(String output) {
    if (output == '') { return 0; }
    String processedInput = output.replaceAllMapped(RegExp(r'(\d)\('), (Match m) => '${m[1]}*(');
    Parser p = Parser();
    Expression exp = p.parse(processedInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    return eval;
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
      body: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 30, 30, 30),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 11.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Column(children: [
                Text(outputs.join(' '), style: const TextStyle(fontSize: 12.0)),
              ])
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.fromLTRB(4, 4, 4, 8),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Column(children: [
                Text(output, style: const TextStyle(fontSize: 50.0)),
              ])
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