import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridTileWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final Function getServices;

  const GridTileWidget(
      {@required this.imageUrl,
      @required this.name,
      @required this.getServices});

//  void displayDialog(context) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) => new AlertDialog(
//        content: new Text("Точно удалить?"),
//        actions: [
//          FlatButton(
//            onPressed: () {},
//            child: Text('Удалить'),
//          ),
//          FlatButton(
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//            child: Text('Отмена'),
//          ),
//        ],
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: getServices,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            height: 80,
            child: Center(
              child: ListTile(
                leading: Container(
                  height: 60,
                  width: 60,
                  child: Image.network(
                    imageUrl,
                    height: 60,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    '$name',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 16,
                    ),
                  ),
                ),
//                trailing: GestureDetector(
//                  onTap: () {},
//                  child: Padding(
//                    padding: const EdgeInsets.only(right: 30),
//                    child: IconButton(
//                      icon: Icon(Icons.delete),
//                      onPressed: () {
//                        displayDialog(context);
//                      },
//                    ),
//                  ),
//                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
