import 'dart:math';

import 'package:flutter/material.dart';
import 'package:g_sekai/logic/common/app/constant.dart';

const _height = 350.0;
const _maxItemExtent = 340.0;
const _itemGap = 16;
const _itemPeek = 8; //화면 모서리에 보여지는 이전,다음 카드의 영역너비
const _itemPadding = EdgeInsets.symmetric(horizontal: _itemGap / 2);

class CustomCarousel extends StatefulWidget {
  const CustomCarousel(
      {super.key, required this.children, this.onPageChnage, this.onTap});
  final List<Widget> children;
  final Function(int)? onPageChnage;
  final Function()? onTap;

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final currentIndex = ValueNotifier(0);
  late PageController ctrl;
  late Size size;
  late double itemDimension;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    itemDimension = min(size.width - _itemGap - _itemPeek * 2, _maxItemExtent);
    ctrl = PageController(
      viewportFraction: itemDimension / size.width,
      initialPage: children.length == 1
          ? 0
          : 11024 * children.length + currentIndex.value,
    );
    super.didChangeDependencies();
  }

  List<Widget> get children => widget.children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap?.call,
      child: SizedBox(
        height: _height,
        child: OverflowBox(
          maxWidth: size.width,
          minWidth: size.width,
          child: children.isEmpty
              ? blank
              : PageView.custom(
                  onPageChanged: (value) {
                    currentIndex.value = value % children.length;
                    widget.onPageChnage?.call(currentIndex.value);
                  },
                  controller: ctrl,
                  scrollDirection: Axis.horizontal,
                  childrenDelegate: SliverChildBuilderDelegate(
                      childCount: children.length == 1 ? 1 : null,
                      (context, index) {
                    return Container(
                        // width: itemDimension,
                        padding: _itemPadding,
                        child: children[index % children.length]);
                  }, addSemanticIndexes: false),
                ),
        ),
      ),
    );
  }
}
