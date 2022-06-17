import 'package:flutter/material.dart';
import 'package:residemenu/residemenu.dart';
import 'example/example_page.dart';
import 'test/test_page.dart';
import 'indicator/indicator_page.dart';

class MainActivity extends StatefulWidget {
  final String title;

  const MainActivity({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainActivityState();
  }
}

class _MainActivityState extends State<MainActivity> with TickerProviderStateMixin {
  List<Widget>? views;
  MenuController? _menuController;
  TabController? _tabController;
  int _tabIndex = 1;
  PageController? _pageController;

  Widget buildItem(String msg, Widget icon, void Function() voidCallBack) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: voidCallBack,
        child: ResideMenuItem(
          title: msg,
          icon: icon,
          right: const Icon(Icons.arrow_forward, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _menuController = MenuController(vsync: this, direction: ScrollDirection.LEFT);
    _pageController = PageController(initialPage: 1);
    views = [
      IndicatorPage(title: "指示器界面"),
      ExamplePage(),
      const TestPage(title: "测试界面"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ResideMenu.scaffold(
      controller: _menuController,
      enable3dRotate: true,
      decoration: const BoxDecoration(color: Colors.purple),
      leftScaffold: MenuScaffold(
        header: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 80.0, maxWidth: 80.0),
          child: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://avatars1.githubusercontent.com/u/19425362?s=400&u=1a30f9fdf71cc9a51e20729b2fa1410c710d0f2f&v=4'),
            radius: 40.0,
          ),
        ),
        children: <Widget>[
          buildItem("各种指示器", const Icon(Icons.apps, size: 18, color: Colors.grey), () {
            setState(() {
              _tabIndex = 0;
            });
            _pageController!.jumpToPage(0);
            _menuController!.closeMenu();
          }),
          buildItem("例子", const Icon(Icons.insert_emoticon, size: 18, color: Colors.grey), () {
            setState(() {
              _tabIndex = 1;
            });
            _pageController!.jumpToPage(1);
            _menuController!.closeMenu();
          }),
          buildItem("测试", const Icon(Icons.airplanemode_active, size: 18, color: Colors.grey), () {
            setState(() {
              _tabIndex = 2;
            });
            _menuController!.closeMenu();
            _pageController!.jumpToPage(2);
          }),
        ],
      ),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(_tabIndex == 0
              ? "指示器界面"
              : _tabIndex == 1
                  ? "例子界面"
                  : _tabIndex == 2
                      ? "测试界面"
                      : _tabIndex == 3
                          ? "样例界面"
                          : "App界面"),
          leading: GestureDetector(
            child: const Icon(Icons.menu),
            onTap: () {
              _menuController!.openMenu(true);
            },
          ),
          backgroundColor: Colors.greenAccent,
          bottom: _tabIndex == 3
              ? TabBar(
                  isScrollable: true,
                  tabs: const [
                    Tab(child: Text("超大数据量性能测试")),
                    Tab(child: Text("SliverAppbar+Sliverheader")),
                    Tab(child: Text("嵌套滚动视图")),
                    Tab(child: Text("动态变化指示器+Navigator")),
                    Tab(child: Text("主动刷新")),
                    Tab(child: Text("四个方向不同风格测试绘制")),
                  ],
                  controller: _tabController,
                )
              : null,
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: views!,
        ),
      ),
    );
  }
}
