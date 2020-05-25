import 'package:broadmin/screens/FixPage.dart';
import 'package:broadmin/screens/add_item.dart';
import 'package:broadmin/screens/set_screen.dart';
import 'package:broadmin/services/firestore.dart';
import 'package:broadmin/widgets/grid_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixBro Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'FixBro Admin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 45),
            child: IconButton(icon: Icon(Icons.add_circle,), onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddItem()),
              );
            }),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: DataBase()
                  .fireStore
                  .collection('fixitemcollection')
                  .orderBy("order", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return Expanded(
                    child: ListView(
                      children: snapshot.data.documents.map((doc) {
                        return GridTileWidget(
                          imageUrl: doc.data['image'],
                          name: doc.documentID,
                          getServices: () {
                            if (doc.data['set'] == false) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FixPage(dataServices: doc,)),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetChoice(dataServices: doc,)),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  );
                }
                return Text('Загрузка...');
              },
            ),
          ],
        ),
      ),
    );
  }
}
