import 'package:broadmin/services/firestore.dart';
import 'package:broadmin/widgets/grid_tile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'FixPage.dart';
import 'add_sub_item.dart';

class SetChoice extends StatelessWidget {
  final dataServices;

  SetChoice({@required this.dataServices});

  void displayDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        content: new Text("Точно удалить?"),
        actions: [
          FlatButton(
            onPressed: () async {
              try {
                DataBase()
                    .fireStore
                    .collection('fixitemcollection')
                    .document('${dataServices.documentID}')
                    .delete();

                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
              } catch (e) {
                print(e.toString());
              }
            },
            child: Text('Удалить'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отмена'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSubItem(
                              dataServices: dataServices,
                            )),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  displayDialog(context);
                }),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: DataBase()
                  .fireStore
                  .collection(
                      'fixitemcollection/${dataServices.documentID}/models')
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FixPage(
                                  dataServices: doc,
                                  docName: dataServices.documentID,
                                ),
                              ),
                            );
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
