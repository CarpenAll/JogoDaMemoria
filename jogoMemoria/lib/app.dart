import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class App extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Jogo da Memória',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}