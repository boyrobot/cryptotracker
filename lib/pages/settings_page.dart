import 'package:flutter/material.dart';

/// 设置页面
class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Settings",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.black54),
        body: Padding(
            padding: EdgeInsets.only(top: 20.0, right: 15, left: 15),
            child: ListView(physics: ClampingScrollPhysics(), children: [
              Card(
                color: Colors.black12,
                child: ListTile(
                    title: Text("Disable 7 day graphs"),
                    subtitle: Text("More compact cards"),
                    trailing: Switch(
                        value: _settings["disableGraphs"],
                        onChanged: (disp) {
                          context
                              .findAncestorStateOfType<_AppState>()
                              .setState(() {
                            _settings["disableGraphs"] =
                                !_settings["disableGraphs"];
                          });
                          _userData["settings/disableGraphs"] =
                              _settings["disableGraphs"];
                        }),
                    onTap: () {
                      context.findAncestorStateOfType<_AppState>().setState(() {
                        _settings["disableGraphs"] =
                            !_settings["disableGraphs"];
                      });
                      _userData["settings/disableGraphs"] =
                          _settings["disableGraphs"];
                    }),
                margin: EdgeInsets.zero,
              ),
              Container(height: 20),
              Card(
                color: Colors.black12,
                child: ListTile(
                    title: Text("Change Currency"),
                    subtitle: Text("33 fiat currency options"),
                    trailing: Padding(
                        child: Container(
                            color: Colors.white12,
                            padding: EdgeInsets.only(right: 7.0, left: 7.0),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    value: _settings["currency"],
                                    onChanged: (s) {
                                      _settings["currency"] = s;
                                      _changeCurrency(s);
                                      _userData["settings/currency"] = s;
                                      context
                                          .findAncestorStateOfType<_AppState>()
                                          .setState(() {});
                                    },
                                    items: _supportedCurrencies
                                        .map((s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(
                                                "$s ${_conversionMap[s]["symbol"]}")))
                                        .toList()))),
                        padding: EdgeInsets.only(right: 10.0))),
                margin: EdgeInsets.zero,
              )
            ])));
  }
}
