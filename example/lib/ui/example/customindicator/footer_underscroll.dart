// convert footer to header to use ,behaviour almost same with header

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../item.dart';

class ConvertFooter extends StatefulWidget {
  const ConvertFooter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ConvertFooterState();
  }
}

class _ConvertFooterState extends State<ConvertFooter> {
  final RefreshController _refreshController = RefreshController();

  List<String> data = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  Widget buildCtn() {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 5, right: 5),
      itemBuilder: (c, i) => Item(
        title: data[i],
      ),
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: Colors.greenAccent,
        );
      },
      itemCount: data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: RefreshConfiguration.copyAncestor(
        enableBallisticLoad: false,
        footerTriggerDistance: -80,
        maxUnderScrollExtent: 60,
        context: context,
        child: SmartRefresher(
          enablePullUp: true,
          footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
          ),
          onLoading: () async {
            await Future.delayed(const Duration(milliseconds: 1000));
            for (int i = 0; i < 5; i++) {
              data.add("1");
            }

            setState(() {});
            _refreshController.loadFailed();
          },
          controller: _refreshController,
          child: buildCtn(),
        ),
      ),
      appBar: AppBar(),
    );
  }
}
