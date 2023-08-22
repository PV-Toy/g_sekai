import 'package:flutter/material.dart';
import 'package:g_sekai/logic/common/app/constant.dart';
import 'package:g_sekai/widgets/custom_carousel.dart';
import 'package:g_sekai/widgets/media_widget.dart';
import 'package:g_sekai/widgets/music_player.dart';

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
    "https://i0.hdslb.com/bfs/manga-static/42b2143b5694835ae35763bea634cdfc36392801.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/87e22d652eb4c456fe251e15b57bbb25da39925a.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/3f01609c36d4816eb227c95ac31471710fa706e6.jpg@300w.jpg",
    "https://i0.hdslb.com/bfs/manga-static/5482454680757477d728dae82f80a280a9cc97a2.jpg@300w.jpg",
  ];
  ValueNotifier<SearchFilter> selectedFilter =
      ValueNotifier(SearchFilter.pupular);

  int currentIndex = 0;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   final s = await fetchYouTubeData();
    //   print(s);
    // });

    super.initState();
  }

  final testc = Container(
    width: 57,
    height: 57,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        // foregroundColor: Colors.transparent,
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
            const Text("G.SEKAI"),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: SizedBox(
              // padding: const EdgeInsets.fromLTRB(70, 22, 70, 25),
              height: 150,
              child: Stack(
                children: [
                  const MusicPlayer(),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(70, 22, 70, 25),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(70, 11, 14, 20),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
  }
}
