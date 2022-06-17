import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> with TickerProviderStateMixin {
  RefreshController _controller = RefreshController();
  int indexPage = 0;
  List<String> data = [];

  void _fetch() {
    http
        .get('https://gank.io/api/v2/data/category/Girl/type/Girl/page/$indexPage/count/10')
        .then((http.Response response) {
      Map map = json.decode(response.body);
      return map["data"];
    }).then((array) {
      for (var item in array) {
        data.add(item["url"]);
      }
      if (mounted) setState(() {});
      _controller.loadFailed();
      indexPage++;
    }).catchError((_) {
      if (kDebugMode) {
        print("error");
      }
      _controller.loadComplete();
    });
  }

  void _onRefresh() {
    Future.delayed(const Duration(milliseconds: 2009)).then((val) {
      _controller.refreshCompleted();
//                refresher.sendStatus(RefreshStatus.completed);
    });
  }

  void _onLoading() {
    Future.delayed(const Duration(milliseconds: 2009)).then((val) {
      _fetch();
    });
  }

  Widget buildImage(context, index) {
    return GestureDetector(
      child: Item(
        url: data[index],
      ),
      onTap: () {
        if (kDebugMode) {
          print("tap");
        }
//        _controller.requestRefresh().then((_){
//          print("request complete");
//        });
        _controller.requestRefresh(needMove: false)?.then((_) {
          if (kDebugMode) {
            print("request complete");
          }
        });
      },
    );
  }

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
    if (isUp) {
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = RefreshController(initialLoadStatus: LoadStatus.failed);
    _fetch();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _controller,
      onRefresh: _onRefresh,
      header: const MaterialClassicHeader(),
      onLoading: _onLoading,
      child: GridView.builder(
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: data.length,
        itemBuilder: buildImage,
      ),
    );
  }
}

class Item extends StatefulWidget {
  final String? url;

  const Item({Key? key, this.url}) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    if (widget.url == null) return Container();
    return FadeInImage(
      placeholder: const AssetImage("images/empty.png"),
      image: NetworkImage(
        widget.url!,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
