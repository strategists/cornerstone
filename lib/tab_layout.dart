library cornerstone;

import 'package:flutter/material.dart';

class TabLayout extends StatefulWidget {
  final Position position;

  final List<Widget> tabItems;

  final List<Widget> tabViews;

  final Color backgroundColor;

  final Color indicatorColor;

  final Widget title;

  final Widget drawer;

  final Widget floatingActionButton;

  final PersistentFooter footerButton;

  final ValueChanged<int> onPageChanged;

  TabLayout({
    Key key,
    this.position = Position.bottom,
    this.tabItems,
    this.tabViews,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.drawer,
    this.floatingActionButton,
    this.footerButton,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _TabLayoutState createState() {
    return _TabLayoutState();
  }
}

enum Position { top, bottom }

class _TabLayoutState extends State<TabLayout>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.tabItems.length);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTopTabBar() {
      return new Scaffold(
        floatingActionButton: widget.floatingActionButton,
        persistentFooterButtons:
            widget.footerButton == null ? [] : widget.footerButton.footerButton,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: widget.title,
          bottom: new TabBar(
              controller: _tabController,
              tabs: widget.tabItems,
              indicatorColor: widget.indicatorColor,
              onTap: (index) {
                widget.onPageChanged?.call(index);
                _pageController
                    .jumpTo(MediaQuery.of(context).size.width * index);
              }),
        ),
        body: new PageView(
          controller: _pageController,
          children: widget.tabViews,
          onPageChanged: (index) {
            _tabController.animateTo(index);
            widget.onPageChanged?.call(index);
          },
        ),
      );
    }

    Widget _buildBottomTabBar() {
      ///底部tab bar
      return new Scaffold(
          drawer: widget.drawer,
          appBar: new AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: widget.title,
          ),
          body: new PageView(
            controller: _pageController,
            children: widget.tabViews,
            onPageChanged: (index) {
              _tabController.animateTo(index);
              widget.onPageChanged?.call(index);
            },
          ),
          bottomNavigationBar: new Material(
            //为了适配主题风格，包一层Material实现风格套用
            color: Theme.of(context).primaryColor, //底部导航栏主题颜色
            child: new TabBar(
              //TabBar导航标签，底部导航放到Scaffold的bottomNavigationBar中
              controller: _tabController, //配置控制器
              tabs: widget.tabItems,
              indicatorColor: widget.indicatorColor,
              onTap: (index) {
                widget.onPageChanged?.call(index);
                _pageController
                    .jumpTo(MediaQuery.of(context).size.width * index);
              }, //tab标签的下划线颜色
            ),
          ));
    }

    if (widget.position == Position.top) {
      return _buildTopTabBar();
    } else if (widget.position == Position.bottom) {
      return _buildBottomTabBar();
    } else {
      throw FlutterError('TabLayout 的 position 属性必须是 top 或 bottom');
    }
  }
}

class PersistentFooter {
  List<Widget> footerButton = [];
}
