import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:g_sekai/widgets/custom_carousel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<String> imageUrlList = [
    "https://i0.hdslb.com/bfs/manga-static/42b2143b5694835ae35763bea634cdfc36392801.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/87e22d652eb4c456fe251e15b57bbb25da39925a.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/3f01609c36d4816eb227c95ac31471710fa706e6.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/6b5ab1a7cb883504db182ee46381835e70d6d460.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/5482454680757477d728dae82f80a280a9cc97a2.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/3f01609c36d4816eb227c95ac31471710fa706e6.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/6b5ab1a7cb883504db182ee46381835e70d6d460.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/5482454680757477d728dae82f80a280a9cc97a2.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/87e22d652eb4c456fe251e15b57bbb25da39925a.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/5482454680757477d728dae82f80a280a9cc97a2.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/6b5ab1a7cb883504db182ee46381835e70d6d460.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/5482454680757477d728dae82f80a280a9cc97a2.jpg@300w.jpg",
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: Container(
              padding: const EdgeInsets.fromLTRB(25, 22, 38, 18),
              height: 90,
              color: Color.fromRGBO(39, 11, 14, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 57,
                    height: 57,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF83F56),
                          Color(0xFFA11538),
                        ],
                        stops: [0.0, 0.7136],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        transform:
                            GradientRotation(3.14159), // 180 degrees in radians
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFF87D9F),
                          offset: Offset(0, 4),
                          blurRadius: 13.0,
                          spreadRadius: -6.0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(7),
                    child: Row(),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.home),
                        Icon(Icons.person_2_outlined),
                      ]),
                ],
              ))),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomCarousel(
              key: const Key("GAME_PICTURES"),
              children: List<Widget>.generate(
                  imageUrlList.length,
                  (index) => Material(
                        color: Colors.red,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        // child: MediaWidget(imageUrl: imageUrlList[index])
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgrounBlurView extends StatelessWidget {
  final String imageUrl;
  const BackgrounBlurView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
