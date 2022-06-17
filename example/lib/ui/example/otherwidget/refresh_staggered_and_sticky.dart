
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

/*
   use refresh with StaggeredGridView or StickyHeader
   the two plugins from letsar
   author page : https://github.com/letsar
 */
class RefreshStaggeredAndSticky extends StatefulWidget {
  const RefreshStaggeredAndSticky({Key? key}) : super(key: key);

  @override
  RefreshStaggeredAndStickyState createState() =>
      RefreshStaggeredAndStickyState();
}

class RefreshStaggeredAndStickyState extends State<RefreshStaggeredAndSticky>
    with TickerProviderStateMixin {
  late RefreshController _refreshController;

  List<Widget> data = [];

  int length = 10;

  void _getDatas() {
    data.add(Row(
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              _refreshController.requestRefresh();
            },
            child: const Text("请求刷新")),
        ElevatedButton(
            onPressed: () {
              _refreshController.requestLoading();
            },
            child: const Text("请求加载数据"))
      ],
    ));
    for (int i = 0; i < 13; i++) {
      data.add(GestureDetector(
        child: Container(
          color: const Color.fromARGB(255, 250, 250, 250),
          child: Card(
            margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
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
    _getDatas();
    _refreshController = RefreshController(initialRefresh: true);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }

  List<bool> expand = [false, false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];
    for (int i = 0; i < expand.length; i++) {
      slivers.add(SliverStickyHeader(
        header: GestureDetector(
          child: Container(
            height: 60.0,
            color: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Header #$i',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          onTap: () {
            expand[i] = !expand[i];
            setState(() {});
          },
        ),
        sliver: expand[i]
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => ListTile(
                    leading: const CircleAvatar(
                      child: Text('0'),
                    ),
                    title: Text('List tile #$i'),
                  ),
                  childCount: 4,
                ),
              )
            : null,
      ));
    }
    slivers.add(SliverStaggeredGrid.countBuilder(
      crossAxisCount: 4,
      itemCount: length,
      itemBuilder: (BuildContext context, int index) => Container(
          color: Colors.green,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('$index'),
            ),
          )),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    ));
    return LayoutBuilder(
      builder: (i, c) {
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: _refreshController,
          header: const MaterialClassicHeader(),
          onRefresh: () async {
            if (kDebugMode) {
              print("onRefresh");
            }
            await Future.delayed(const Duration(milliseconds: 4000));
            if (mounted) setState(() {});
            _refreshController.refreshFailed();
          },
          child: CustomScrollView(
            slivers: slivers,
          ),
          onLoading: () {
            if (kDebugMode) {
              print("onload");
            }
            Future.delayed(const Duration(milliseconds: 2000)).then((val) {
              length += 10;
              if (mounted) setState(() {});
              _refreshController.loadComplete();
            });
          },
        );
      },
    );
  }
}
