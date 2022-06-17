import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' hide RefreshIndicator;

class Test1 extends StatefulWidget {
  const Test1({Key? key}) : super(key: key);

  @override
  Test1State createState() => Test1State();
}

class Test1State extends State<Test1> {
//  RefreshMode  refreshing = RefreshMode.idle;
//  LoadMode loading = LoadMode.idle;
  RefreshController _refreshController = RefreshController();
  ScrollController _scrollController = ScrollController();
  List<Widget> data = [];

  void _getData() {
    for (int i = 0; i < 4; i++) {
      data.add(Container(
        color: Colors.greenAccent,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Center(
          child: Text('Data $i'),
        ),
      ));
    }
  }

  void scrollTop() {
    _scrollController
        .animateTo(0.0, duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void enterRefresh() {
    _refreshController.requestRefresh();
  }

  void _onOffsetCallback(bool isUp, double offset) {}

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    _scrollController = ScrollController(keepScrollOffset: true);
    _refreshController = RefreshController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
//      _refreshController.requestRefresh(true);
    });
    super.initState();
  }

//  Widget _footerCreate(BuildContext context,int mode){
//    return new ClassicIndicator(mode: mode);
//  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        key: const PageStorageKey("q"),
        controller: _scrollController,
        headerSliverBuilder: (c, s) => [
              SliverAppBar(
                backgroundColor: Colors.greenAccent,
                expandedHeight: 200.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.network(
                      "https://images.unsplash.com/photo-1541701494587-cb58502866ab?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=0c21b1ac3066ae4d354a3b2e0064c8be&auto=format&fit=crop&w=500&q=60",
                      fit: BoxFit.cover,
                    )),
              ),
            ],
        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            header: const WaterDropHeader(),
            enablePullUp: true,
            onRefresh: () {
              Future.delayed(const Duration(milliseconds: 2009)).then((val) {
                data.add(const Card(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Center(
                    child: Text('Data '),
                  ),
                ));
                if (mounted) {
                  setState(() {
                    _refreshController.refreshCompleted();
                  });
                }
              });
            },
            onLoading: () {
              Future.delayed(const Duration(milliseconds: 2009)).then((val) {
                if (mounted) {
                  setState(() {
                    data.add(const Card(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: Center(
                        child: Text('Data '),
                      ),
                    ));
                    _refreshController.loadComplete();
                  });
                }
              });
            },
            child: ListView.builder(
              itemExtent: 100.0,
              itemCount: data.length,
              itemBuilder: (context, index) => const Item(),
            )));
  }
}

class Item extends StatefulWidget {
  const Item({Key? key}) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.red,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: Center(
        child: Text('Data'),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
