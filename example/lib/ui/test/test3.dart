import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Test3 extends StatefulWidget {
  const Test3({Key? key}) : super(key: key);

  @override
  Test3State createState() => Test3State();
}

class Test3State extends State<Test3> with TickerProviderStateMixin {
//  RefreshMode  refreshing = RefreshMode.idle;
//  LoadMode loading = LoadMode.idle;
  ValueNotifier<double> topOffsetLis = ValueNotifier(0.0);
  ValueNotifier<double> bottomOffsetLis = ValueNotifier(0.0);
  RefreshController _refreshController = RefreshController();

  List<Widget> data = [];

  void _getData() {
    data.add(Row(
      children: <Widget>[
        TextButton(
            onPressed: () async {
              await _refreshController.requestRefresh()?.then((value) async {
                if (kDebugMode) {
                  print("requestRefresh");
                }
                await Future.delayed(const Duration(milliseconds: 5000));
                _refreshController.refreshCompleted();
              });
            },
            child: const Text("请求刷新")),
        TextButton(
            onPressed: () {
              _refreshController.requestLoading()?.then((value) async {
                if (kDebugMode) {
                  print("requestLoading");
                }
                await Future.delayed(const Duration(milliseconds: 5000));
                _refreshController.loadComplete();
              });
            },
            child: const Text("请求加载数据"))
      ],
    ));
    for (int i = 0; i < 1; i++) {
      data.add(GestureDetector(
        child: Container(
          color: const Color.fromARGB(255, 250, 250, 250),
          child: Card(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
            child: Center(
              child: Text('Data $i'),
            ),
          ),
        ),
        onTap: () {
          _refreshController.requestRefresh();
        },
      ));
    }
  }

  void enterRefresh() {
    _refreshController.requestLoading();
  }

  @override
  void initState() {
    // TODO: implement initState
    // for test #68 true-> false ->true
//    Future.delayed(Duration(milliseconds: 3000), () {
//      _enablePullDown = false;
//      _enablePullUp = false;
//      if (mounted) setState(() {});
//    });
//    Future.delayed(Duration(milliseconds: 6000), () {
//      _enablePullDown = true;
//      _enablePullUp = true;
//      if (mounted) setState(() {});
//    });

//    // for test #68 false-> true ->false
//    Future.delayed(Duration(milliseconds: 3000),(){
//      _enablePullDown = false;
//      _enablePullUp = true;
//    if(mounted)
//      setState(() {
//
//      });
//    });
//    Future.delayed(Duration(milliseconds: 6000),(){
//      _enablePullDown = true;
//      _enablePullUp = false;
//    if(mounted)
//      setState(() {
//
//      });
//    });
//    Future.delayed(Duration(milliseconds: 3000),(){
//      _enablePullDown = true;
//      _enablePullUp = false;
//    if(mounted)
//      setState(() {
//
//      });
//    });
//    Future.delayed(Duration(milliseconds: 6000),(){
//      _enablePullDown = false;
//      _enablePullUp = true;
//    if(mounted)
//      setState(() {
//
//      });
//    });
    _getData();
    _refreshController =
        RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.noMore);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration.copyAncestor(
      context: context,
      footerTriggerDistance: -80,
      maxUnderScrollExtent: 60,
      enableLoadingWhenNoData: true,
      dragSpeedRatio: 0.9,
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        footer: const ClassicFooter(
          height: 60,
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        header: TwoLevelHeader(
          twoLevelWidget: Center(
            child: Container(
              color: Colors.green,
              width: double.infinity,
              height: 60,
              child: const Text("twoLevel"),
            ),
          ),
        ),
        onRefresh: () async {
          if (kDebugMode) {
            print("onRefresh");
          }
          await Future.delayed(const Duration(milliseconds: 3000));
          data.add(const SizedBox(
            height: 100.0,
            child: Card(),
          ));
          if (mounted) setState(() {});
          _refreshController.refreshCompleted();
//        Future.delayed(const Duration(milliseconds: 2009)).then((val) {
//          data.add(Card());
//
//        });
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillViewport(
                delegate: SliverChildListDelegate(
                    [data[0], data[1], const Text("第一页"), const Text("第一页")]))
          ],
          physics: const PageScrollPhysics(),
        ),
        onLoading: () async {
          await Future.delayed(const Duration(milliseconds: 1000));
          if (kDebugMode) {
            print("onLoading");
          }
          _refreshController.loadNoData();
        },
      ),
    );
  }
}

class CirclePainter extends CustomClipper<Path> {
  final double offset;
  final bool up;

  CirclePainter({required this.offset, required this.up});

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    final path = Path();
    if (!up) path.moveTo(0.0, size.height);
    path.cubicTo(0.0, up ? 0.0 : size.height, size.width / 2,
        up ? offset * 2.3 : size.height - offset * 2.3, size.width, up ? 0.0 : size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return oldClipper != this;
  }
}
