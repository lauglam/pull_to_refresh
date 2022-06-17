import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
   there two example implements two level,
   the first is common,when twoRefreshing,header will follow the list to scrollDown,when closing,still follow
   list move up,
   the second example use Navigator and keep offset when twoLevel trigger,
   header can use ClassicalHeader to implments twoLevel,it provide outerBuilder(1.4.7)
   important point:
   1. open enableTwiceRefresh bool ,default is false
   2. _refreshController.twiceRefreshComplete() can closing the two level
*/
class TwoLevelExample extends StatefulWidget {
  const TwoLevelExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TwoLevelExampleState();
  }
}

class _TwoLevelExampleState extends State<TwoLevelExample> {
  final RefreshController _refreshController1 = RefreshController();
  final RefreshController _refreshController2 = RefreshController();
  int _tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _refreshController1.headerMode?.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshController1.position?.jumpTo(0);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshConfiguration.copyAncestor(
      context: context,
      enableScrollWhenTwoLevel: true,
      maxOverScrollExtent: 120,
      child: Scaffold(
        bottomNavigationBar: !_refreshController1.isTwoLevel
            ? BottomNavigationBar(
                currentIndex: _tabIndex,
                onTap: (index) {
                  _tabIndex = index;
                  if (mounted) setState(() {});
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.add), label: '二级刷新例子1'),
                  BottomNavigationBarItem(icon: Icon(Icons.border_clear), label: '二级刷新例子2')
                ],
              )
            : null,
        body: Stack(
          children: <Widget>[
            Offstage(
              offstage: _tabIndex != 0,
              child: LayoutBuilder(
                builder: (_, c) {
                  return SmartRefresher(
                    header: const TwoLevelHeader(
                      textStyle: TextStyle(color: Colors.white),
                      displayAlignment: TwoLevelDisplayAlignment.fromTop,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/secondfloor.jpg"),
                            fit: BoxFit.cover,
                            // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果
                            alignment: Alignment.topCenter),
                      ),
                      twoLevelWidget: TwoLevelWidget(),
                    ),
                    controller: _refreshController1,
                    enableTwoLevel: true,
                    enablePullDown: true,
                    enablePullUp: true,
                    onLoading: () async {
                      await Future.delayed(const Duration(milliseconds: 2000));
                      _refreshController1.loadComplete();
                    },
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 2000));
                      _refreshController1.refreshCompleted();
                    },
                    onTwoLevel: () {
                      if (kDebugMode) {
                        print("twoLevel opening");
                      }
                    },
                    child: CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 500.0,
                            child: Scaffold(
                              appBar: AppBar(),
                              body: Column(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("点击这里返回上一页!"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _refreshController1.requestTwoLevel();
                                    },
                                    child: const Text("点击这里打开二楼!"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Offstage(
              offstage: _tabIndex != 1,
              child: SmartRefresher(
                header: const ClassicHeader(),
                controller: _refreshController2,
                enableTwoLevel: true,
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 2000));
                  _refreshController2.refreshCompleted();
                },
                onTwoLevel: () {
                  if (kDebugMode) {
                    print("Asd");
                  }
                  _refreshController2.position?.hold(() {});
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (c) => Scaffold(
                                appBar: AppBar(),
                                body: const Text("二楼刷新"),
                              )))
                      .whenComplete(() {
                    _refreshController2.twoLevelComplete(duration: const Duration(microseconds: 1));
                  });
                },
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.red,
                        height: 680.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("点击这里返回上一页!"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TwoLevelWidget extends StatelessWidget {
  const TwoLevelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/secondfloor.jpg"),
            // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果,关联到TwoLevelHeader,如果背景一致的情况,请设置相同
            alignment: Alignment.topCenter,
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Wrap(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("登陆"),
                ),
              ],
            ),
          ),
          Container(
            height: 60.0,
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onTap: () {
                SmartRefresher.of(context)?.controller.twoLevelComplete();
              },
            ),
          ),
        ],
      ),
    );
  }
}
