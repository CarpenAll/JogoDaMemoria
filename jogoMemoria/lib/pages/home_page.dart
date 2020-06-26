import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

int level = 8;
class Home extends StatefulWidget{
  final int tamanho;

  const Home({Key key, this.tamanho = 8}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List <GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List<String> data = [];
  int previousIndex = -1;
  bool flip = false;
  int time = 0;
  Timer timer;

    @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.tamanho ; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    for (var i = 0; i < widget.tamanho ~/ 2 ; i++) {
      data.add(i.toString());      
    }
    for (var i = 0; i < widget.tamanho ~/ 2 ; i++) {
      data.add(i.toString());      
    }
    startTimer();
    data.shuffle();
  }

  startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (t) { 
      setState(() {
        time = time + 1;
      });
    });
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget> [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("$time", 
                style: Theme.of(context).textTheme.display2,
                ),
              ),
              Theme(
                data: ThemeData.dark(),
                  child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) => FlipCard(
                      key: cardStateKeys[index],
                      onFlip: (){
                        if(!flip){
                          flip = true;
                          previousIndex = index;
                        }else{
                          flip = false;
                          if(previousIndex != index){
                            if(data[previousIndex] != data[index]){
                              cardStateKeys[previousIndex].currentState.toggleCard();
                              previousIndex = index;
                            }else{
                              cardFlips[previousIndex] = false;
                              cardFlips[index] = false;
                              if(cardFlips.every((t) => t == false)){
                                print("Ganhou");
                                showResult();
                              }
                            }
                          }
                        }
                      },
                      direction: FlipDirection.HORIZONTAL,
                      flipOnTouch: cardFlips[index],
                      front: Container(
                        margin: EdgeInsets.all(4.0),
                        color: Colors.deepPurple.withOpacity(0.3),
                        ),
                      back: Container(
                        margin: EdgeInsets.all(4.0),
                        color: Colors.deepPurple,
                        child: Center(
                          child: Text("${data[index]}",
                          style: Theme.of(context).textTheme.display2,),
                        ),
                        ),
                    ),
                    itemCount: data.length
                  ),
                ),
              )
            ]
          ),
        ))
    );
  }

  showResult(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Ganhou!!"),
        content: Text("Tempo $time", 
                 style: Theme.of(context).textTheme.display2,),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home(
                  tamanho: level,
                ),              
              ),
             );
             level *= 2;
            },
            child: Text("Próximo"),)
        ],
      ),
    );
  }
}