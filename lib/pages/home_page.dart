
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final bool savedPage;
  HomePage(this.savedPage) : super(key: ValueKey(savedPage));
  @override
  _HomePageState createState() => _HomePageState();
}

typedef SortType(String s1, String s2);

SortType sortBy(String s) {
  String sortVal = s.substring(0, s.length - 1);
  bool ascending = s.substring(s.length - 1).toLowerCase() == "a";
  return (s1, s2) {
    if (s == "custom") {
      return _savedCoins.indexOf(s1) - _savedCoins.indexOf(s2);
    }
    Map<String, Comparable> m1 = _coinData[ascending ? s1 : s2],
        m2 = _coinData[ascending ? s2 : s1];
    dynamic v1 = m1[sortVal], v2 = m2[sortVal];
    if (sortVal == "name") {
      v1 = v1.toUpperCase();
      v2 = v2.toUpperCase();
    }
    int comp = v1.compareTo(v2);
    if (comp == 0) {
      return sortBy("nameA")(s1, s2) as int;
    }
    return comp;
  };
}

class _HomePageState extends State<HomePage> {
  bool searching = false;

  List<String> sortedKeys;
  String prevSearch = "";

  void reset() {
    if (widget.savedPage) {
      sortedKeys = List.from(_savedCoins)..sort(sortBy(sortingBy));
    } else {
      sortedKeys = List.from(_coinData.keys)..sort(sortBy(sortingBy));
    }
    setState(() {});
  }

  void search(String s) {
    scrollController.jumpTo(0.0);
    reset();
    moving = false;
    moveWith = null;
    for (int i = 0; i < sortedKeys.length; i++) {
      String key = sortedKeys[i];
      String name = _coinData[key]["name"];
      String ticker = _coinData[key]["symbol"];
      if (![name, ticker]
          .any((w) => w.toLowerCase().contains(s.toLowerCase()))) {
        sortedKeys.removeAt(i--);
      }
    }
    prevSearch = s;
    setState(() {});
  }

  void sort(String s) {
    scrollController.jumpTo(0.0);
    moving = false;
    moveWith = null;
    sortingBy = s;
    setState(() {
      sortedKeys.sort(sortBy(s));
    });
  }

  @override
  void initState() {
    super.initState();
    sortingBy = widget.savedPage ? "custom" : "marketCapUsdD";
    reset();
  }

  Timer searchTimer;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem> l = [
      PopupMenuItem<String>(
          child: const Text("Name Ascending"), value: "nameA"),
      PopupMenuItem<String>(
          child: const Text("Name Descending"), value: "nameD"),
      PopupMenuItem<String>(
          child: const Text("Price Ascending"), value: "priceUsdA"),
      PopupMenuItem<String>(
          child: const Text("Price Descending"), value: "priceUsdD"),
      PopupMenuItem<String>(
          child: const Text("Market Cap Ascending"), value: "marketCapUsdA"),
      PopupMenuItem<String>(
          child: const Text("Market Cap Descending"), value: "marketCapUsdD"),
      PopupMenuItem<String>(
          child: const Text("24H Change Ascending"),
          value: "changePercent24HrA"),
      PopupMenuItem<String>(
          child: const Text("24H Change Descending"),
          value: "changePercent24HrD")
    ];
    if (widget.savedPage) {
      l.insert(0,
          PopupMenuItem<String>(child: const Text("Custom"), value: "custom"));
    }
    Widget ret = Scaffold(
        drawer: widget.savedPage
            ? Drawer(
                child: ListView(children: [
                  GestureDetector(
                      child: Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height / 5,
                        child: Image.asset("assets/icon/platypus.png"),
                      ),
                      onTap: () async {
                        String url = "https://platypuslabs.llc";
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.import_export),
                      title: Text("Import/Export Favorites",
                          style: TextStyle(fontSize: 16.0)),
                      onTap: () {
                        if (!_loading) {
                          _didImport = false;
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImpExpPage()))
                              .then((f) {
                            if (_didImport) {
                              _didImport = false;
                              searching = false;
                              reset();
                            }
                            setState(() {});
                          });
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Settings", style: TextStyle(fontSize: 16.0)),
                      onTap: () {
                        if (!_loading) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage()));
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.mail),
                      title:
                          Text("Contact Us", style: TextStyle(fontSize: 16.0)),
                      onTap: () async {
                        String url = Uri.encodeFull(
                            "mailto:support@platypuslabs.llc?subject=GetPass&body=Contact Reason: ");
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.star),
                      title: Text("Rate Us", style: TextStyle(fontSize: 16.0)),
                      onTap: () async {
                        String url = Platform.isIOS
                            ? "https://itunes.apple.com/us/app/platypus-crypto/id1397122793"
                            : "https://play.google.com/store/apps/details?id=land.platypus.cryptotracker";
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      })
                ]),
                key: ValueKey(widget.savedPage))
            : null,
        appBar: AppBar(
          bottom: _loading
              ? PreferredSize(
                  preferredSize: Size(double.infinity, 3.0),
                  child:
                      Container(height: 3.0, child: LinearProgressIndicator()))
              : null,
          title: searching
              ? TextField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none),
                  style: TextStyle(color: Colors.white),
                  onChanged: (s) {
                    searchTimer?.cancel();
                    searchTimer = Timer(Duration(milliseconds: 500), () {
                      search(s);
                    });
                  },
                  onSubmitted: (s) {
                    search(s);
                  })
              : Text(widget.savedPage ? "Favorites" : "All Coins"),
          actions: [
            IconButton(
                icon: Icon(searching ? Icons.close : Icons.search),
                onPressed: () {
                  if (_loading) {
                    return;
                  }
                  setState(() {
                    if (searching) {
                      searching = false;
                      reset();
                    } else {
                      searching = true;
                    }
                  });
                }),
            Container(
                width: 35.0,
                child: PopupMenuButton(
                    itemBuilder: (BuildContext context) => l,
                    child: Icon(Icons.sort),
                    onSelected: (s) {
                      if (_loading) {
                        return;
                      }
                      sort(s);
                    })),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  if (_loading) {
                    return;
                  }
                  searching = false;
                  sortingBy = widget.savedPage ? "custom" : "marketCapUsdD";
                  await context
                      .findAncestorStateOfType<_AppState>()
                      .setUpData();
                  reset();
                })
          ],
        ),
        body: !_loading
            ? Scrollbar(
                child: ListView.builder(
                    itemBuilder: (context, i) =>
                        Crypto(sortedKeys[i], widget.savedPage),
                    itemCount: sortedKeys.length,
                    controller: scrollController))
            : Container(),
        floatingActionButton: widget.savedPage
            ? !_loading
                ? FloatingActionButton(
                    onPressed: () {
                      moving = false;
                      moveWith = null;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(false))).then((d) {
                        sortingBy = "custom";
                        searching = false;
                        reset();
                        scrollController.jumpTo(0.0);
                      });
                    },
                    child: Icon(Icons.add),
                    heroTag: "newPage")
                : null
            : FloatingActionButton(
                onPressed: () {
                  scrollController.jumpTo(0.0);
                },
                child: Icon(Icons.arrow_upward),
                heroTag: "jump"));
    if (!widget.savedPage) {
      ret = WillPopScope(
          child: ret, onWillPop: () => Future<bool>(() => !_loading));
    }
    return ret;
  }
}
