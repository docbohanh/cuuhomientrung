import 'package:chmt/pages/household/household_page.dart';
import 'package:chmt/pages/household/household_vm.dart';
import 'package:chmt/pages/rescuer/rescuer_page.dart';
import 'package:chmt/pages/rescuer/rescuer_vm.dart';
import 'package:chmt/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum HomeScreen { houseHold, importantNews, rescueTeam }

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  var screen = HomeScreen.houseHold;

  HouseHoldPage houseHoldPage;
  RescuerPage rescuerPage;

  var houseHoldCount = '';
  var rescuerCount = '';

  Widget getBody() {
    switch (screen) {
      case HomeScreen.houseHold:
        if (houseHoldPage == null) {
          final viewModel = Provider.of<HouseHoldViewModel>(context);
          viewModel.houseHoldStream.listen((list) {
            setState(() => houseHoldCount = list.length.toString());
          });
          houseHoldPage = HouseHoldPage(viewModel);
        }
        return houseHoldPage;

      case HomeScreen.rescueTeam:
        if (rescuerPage == null) {
          final viewModel = Provider.of<RescuerViewModel>(context);
          viewModel.rescuerStream.listen((list) {
            setState(() => rescuerCount = list.length.toString());
          });

          rescuerPage = RescuerPage(viewModel);
        }

        return rescuerPage;
      default:
        return Container();
    }
  }

  void changeHomeScreenTo(HomeScreen screen) {
    setState(() => this.screen = screen);
    if (_scaffoldKey.currentState.isDrawerOpen) {
      _scaffoldKey.currentState.openEndDrawer();
    }
  }

  String getTitle() {
    if (screen == HomeScreen.houseHold) {
      return houseHoldCount.isNotEmpty ? '$houseHoldCount ' + r'lời kêu cứu' : r'Cứu hộ miền Trung';
    } else if (screen == HomeScreen.rescueTeam) {
      return rescuerCount.isNotEmpty ? '$rescuerCount ' + r'đội cứu hộ' : r'Đội cứu hộ';
    }
    return r'Cứu hộ miền Trung';
  }

  void _refresh() {
    if (screen == HomeScreen.houseHold) {
      houseHoldPage.viewModel.refreshChanged(true);
    } else if (screen == HomeScreen.rescueTeam) {
      rescuerPage.viewModel.refreshChanged(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var menuStyle = GoogleFonts.openSans(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          getTitle(),
          style: GoogleFonts.openSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () {
              Utility.hideKeyboardOf(context);
              _refresh();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Container(
                  child: Text(
                    "CHMT 🌻",
                    style: GoogleFonts.merriweather(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                  children: [
                    InkWell(
                      onTap: () => changeHomeScreenTo(HomeScreen.houseHold),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                icon: Icon(Icons.home_outlined), onPressed: null),
                            Text(r'Các hộ cần ứng cứu', style: menuStyle)
                          ]),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () => changeHomeScreenTo(HomeScreen.rescueTeam),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                icon: Icon(Icons.security),
                                onPressed: null),
                            Text(r'Các đội cứu hộ', style: menuStyle)
                          ]),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () => changeHomeScreenTo(HomeScreen.importantNews),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(icon: Icon(Icons.network_wifi), onPressed: null),
                            Text(r'Tin tức', style: menuStyle)
                          ]),
                    ),
                  ]),
            ),
            GestureDetector(
              onTap: () => Utility.launchURL(context, url: 'https://cuuhomientrung.info/'),
              child: Text(
                r'✍︎ cuuhomientrung.info',
                style: menuStyle.copyWith(color: Colors.blue),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        ),
      ),
      body: getBody(),
    );
  }
}