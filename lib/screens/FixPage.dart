import 'package:broadmin/services/firestore.dart';
import 'package:broadmin/widgets/fix_price.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FixPage extends StatefulWidget {
  final dataServices;
  final docName;

  FixPage({@required this.dataServices, this.docName});

  @override
  _FixPageState createState() => _FixPageState();
}

class _FixPageState extends State<FixPage> {
  void displayDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        content: new Text("Точно удалить?"),
        actions: [
          FlatButton(
            onPressed: () async {
              try {
                if (widget.dataServices.data['set'] == false) {
                  DataBase()
                      .fireStore
                      .collection('fixitemcollection')
                      .document('${widget.dataServices.documentID}')
                      .delete();
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );
                } else {
                  DataBase()
                      .fireStore
                      .collection('fixitemcollection')
                      .document('${widget.docName}')
                      .collection('models')
                      .document('${widget.dataServices.documentID}')
                      .delete();
                }

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
    Map servicesFromDataServices = widget.dataServices.data['services'];
    String category = widget.dataServices.documentID;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    displayDialog(context);
                  }),
            )
          ],
          title: Text('${widget.dataServices.documentID}',
              style: TextStyle(fontSize: 30)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        body: Padding(
          padding: const EdgeInsets.only(left: 40, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Image.network(
                '${widget.dataServices.data['image']}',
                height: 130,
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView(
                  children: servicesFromDataServices.entries.map((value) {
                    return FixPrice(
                        header: value.key,
                        price: '${value.value} p',
                        category: category);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
