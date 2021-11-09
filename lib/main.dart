import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Standard Calculator',
      home: const MyHomePage(title: 'Standard Calculator'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String eqn = "0";
  String ans = "0";
  String expression = "";
  buttonPressed(String buttonText){
    setState(() {
      if(buttonText == "AC"){
        eqn = "0";
        ans = "0";
      } else if(buttonText == "<"){
        eqn = eqn.substring(0,eqn.length-1);
        if(eqn == "")
          eqn = "0";
      } else if(buttonText == "="){
          expression  = eqn;
          expression = expression.replaceAll('⨯', '*');
          expression = expression.replaceAll('÷', '/');
          try{
            Parser p = Parser();
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            ans = '${exp.evaluate(EvaluationType.REAL, cm)}';

          } catch(e){
            ans = "Error";
          }
      } else{
        if(eqn == "0")
          eqn = buttonText;
        else
          eqn = eqn + buttonText;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Standard Calculator'),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 2, child: buildRes(),),
          Expanded(flex: 3, child: BuildButton(),),
        ],
      ),
    );
  }
  Widget BuildButton(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget> [
          buildButtonRow('', 'AC', '<', '÷'),
          buildButtonRow('7', '8', '9', '⨯'),
          buildButtonRow('4', '5', '6', '-'),
          buildButtonRow('1', '2', '3', '+'),
          buildButtonRow('', '0', '.', '='),
        ],
      ),
    );
  }
  Widget buildButtonRow( String first, String second, String third, String fourth){
    final row = [first, second, third, fourth];
    return Row(
      children: row
          .map((text) => Expanded(
        child: Container(
          margin: EdgeInsets.all(1.5),
          child: FlatButton(
            padding: EdgeInsets.all(10),
            onPressed: () => buttonPressed(text),
            child: text == '<'
                ? Icon(Icons.backspace_outlined, color: Colors.white, size: 47,)
                : text == '⨯'
                ? Text(text,style: TextStyle(fontSize: 35),)
                : Text(text,style: TextStyle(fontSize: 40),),
            textColor: Colors.white,
            color: getBGCol(text),
          ),
        ),
      ),)
          .toList(),
    );
  }
  Color getBGCol(String buttonText) {
    switch (buttonText) {
      case '+':
      case '-':
      case '⨯':
      case '÷':
      case 'AC':
      case '<':{
          return Colors.black45;
        }
      case '=':{
          return Colors.blueAccent;
        }
      default:
        {
          return Colors.black87;
        }
    }
  }
  Widget buildRes(){
    return Container(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget> [
          Text(
            eqn,
            overflow: TextOverflow.ellipsis,
            style : TextStyle(color: Colors.grey, fontSize: 25),
          ),
          SizedBox(height: 20),
          Text(
            ans,
            overflow: TextOverflow.ellipsis,
            style : TextStyle(color: Colors.white, fontSize: 50),
          )
        ],
      ),
    );
  }
}
