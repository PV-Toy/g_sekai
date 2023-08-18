import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_sekai/logic/common/app/constant.dart';
import 'package:g_sekai/widgets/custom_carousel.dart';
import 'package:g_sekai/widgets/media_widget.dart';
import 'package:palette_generator/palette_generator.dart';

enum SearchFilter { pupular, newest, recommanded }

extension on SearchFilter {
  String get chipLabel => name.toCapitalized();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> imageUrlList = [
    "https://gsekai.s3.ap-northeast-2.amazonaws.com/images/dislight_main.jpeg",
    "https://gsekai.s3.ap-northeast-2.amazonaws.com/images/nikke_main.jpeg",
    "https://i0.hdslb.com/bfs/manga-static/3f01609c36d4816eb227c95ac31471710fa706e6.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/5482454680757477d728dae82f80a280a9cc97a2.jpg@300w.jpg",
  ];
  ValueNotifier<SearchFilter> selectedFilter =
      ValueNotifier(SearchFilter.pupular);

  int currentIndex = 0;

  // @override
  // void initState() {
  //   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //   //   final s = await fetchYouTubeData();
  //   //   print(s);
  //   // });

  //   super.initState();
  // }

  final testc = Container(
    width: 57,
    height: 57,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
  );

  ValueNotifier<Color> dominantColor = ValueNotifier<Color>(Colors.transparent);

  // Helper function to get the dominant color from the generated palette
  Future<Color> getDominantColor(String imageUrl) async {
    final imageProvider = NetworkImage(imageUrl);
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color ?? Colors.transparent;
  }

  @override
  void initState() {
    super.initState();

    updateDominantColor(imageUrlList[0]);
  }

  Color overlayColor50 = Colors.black.withOpacity(0.5);
  Color overlayColor80 = Colors.black.withOpacity(0.8);

  void updateDominantColor(String imageUrl) {
    getDominantColor(imageUrl).then((Color color) {
      int red = color.red;
      int green = color.green;
      int blue = color.blue;

      int blackOffset = 50;

      int newRed = (red - blackOffset).clamp(0, 255);
      int newGreen = (green - blackOffset).clamp(0, 255);
      int newBlue = (blue - blackOffset).clamp(0, 255);

      Color modifiedColor = Color.fromARGB(255, newRed, newGreen, newBlue);

      // dominantColor.value = modifiedColor;
      dominantColor.value = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: dominantColor,
        builder: (context, color, _) {
          return Scaffold(
            backgroundColor: Color.alphaBlend(overlayColor50, color),
            appBar: AppBar(
              backgroundColor: Color.alphaBlend(overlayColor50, color),
              shadowColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  Image.asset(
                    "assets/icons/main_logo.png",
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "G.SEKAI",
                    style: TextStyle(
                      color: Colors.white, // Set the color to white
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        Container(
                            color: Color.alphaBlend(overlayColor80, color),
                            height: 150,
                            padding: const EdgeInsets.fromLTRB(30, 22, 30, 90),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                Container(
                                  child: const Text(
                                    '노래 제목!~~~',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            )),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(70, 22, 70, 25),
                              decoration: BoxDecoration(
                                color: Color.alphaBlend(
                                    overlayColor80, color.withOpacity(0.5)),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    Icon(
                                      Icons.home,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    Icon(
                                      Icons.person_2_outlined,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ]),
                            ))
                      ],
                    )

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       width: 57,
                    //       height: 57,
                    //       decoration: const BoxDecoration(
                    //         gradient: LinearGradient(
                    //           colors: [
                    //             Color(0xFFF83F56),
                    //             Color(0xFFA11538),
                    //           ],
                    //           stops: [0.0, 0.7136],
                    //           begin: Alignment.topCenter,
                    //           end: Alignment.bottomCenter,
                    //           transform:
                    //               GradientRotation(3.14159), // 180 degrees in radians
                    //         ),
                    //         shape: BoxShape.circle,
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Color(0xFFF87D9F),
                    //             offset: Offset(0, 4),
                    //             blurRadius: 13.0,
                    //             spreadRadius: -6.0,
                    //           ),
                    //         ],
                    //       ),
                    //       padding: const EdgeInsets.all(7),
                    //       child: Row(),
                    //     ),
                    //     const Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Icon(Icons.favorite),
                    //           Icon(Icons.home),
                    //           Icon(Icons.person_2_outlined),
                    //         ]),
                    //   ],
                    // )
                    )),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: selectedFilter,
                        builder: (context, $filter, _) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (final filter in SearchFilter.values)
                                  FilterChip(
                                      selected: filter == $filter,
                                      label: Text(filter.chipLabel),
                                      onSelected: (v) {
                                        selectedFilter.value = filter;
                                      }),
                                const Icon(Icons.search)
                              ]);
                        }),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("VALORANT"),
                              Row(
                                children: [
                                  Icon(Icons.favorite_outline),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.volume_off),
                                ],
                              )
                            ],
                          ),
                        ),
                        CustomCarousel(
                          onPageChange: (index) =>
                              updateDominantColor(imageUrlList[index]),
                          key: const Key("GAME_PICTURES"),
                          children: List<Widget>.generate(
                              imageUrlList.length,
                              (index) => Material(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: MediaWidget(
                                          imageUrl: imageUrlList[index])))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
