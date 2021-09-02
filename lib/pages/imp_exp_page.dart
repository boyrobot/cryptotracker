
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImpExpPage extends StatefulWidget {
  @override
  ImpExpPageState createState() => ImpExpPageState();
}

class ImpExpPageState extends State<ImpExpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Import/Export")),
        body: Builder(
            builder: (context) => Container(
                child: Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 15, left: 15),
                    child:
                        ListView(physics: ClampingScrollPhysics(), children: [
                      Card(
                        color: Colors.black12,
                        child: ListTile(
                            title: Text("Export Favorites"),
                            subtitle: Text("To your clipboard"),
                            trailing: Icon(Icons.file_upload),
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: json.encode(_savedCoins)));
                              Scaffold.of(context).removeCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 1000),
                                  content: Text("Copied to clipboard",
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.grey[800]));
                            }),
                        margin: EdgeInsets.zero,
                      ),
                      Container(height: 20),
                      Card(
                        color: Colors.black12,
                        child: ListTile(
                            title: Text("Import Favorites"),
                            subtitle: Text("From your clipboard"),
                            trailing: Icon(Icons.file_download),
                            onTap: () async {
                              String str =
                                  (await Clipboard.getData("text/plain")).text;
                              try {
                                List<String> data =
                                    json.decode(str).cast<String>();
                                for (int i = 0; i < data.length; i++) {
                                  if (_coinData[data[i]] == null) {
                                    data.removeAt(i--);
                                  }
                                }
                                _savedCoins = data;
                                _userData["saved"] = data;
                                _didImport = true;
                                Scaffold.of(context).removeCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1000),
                                    content: Text("Imported",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.grey[800]));
                              } catch (e) {
                                Scaffold.of(context).removeCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1000),
                                    content: Text("Invalid data",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.grey[800]));
                              }
                            }),
                        margin: EdgeInsets.zero,
                      ),
                    ])))));
  }
}
