//  Map service123 = Map.fromEntries([MapEntry(_controllerName.text,_controllerPrice.text)]);
import 'dart:html';
import 'dart:math';
import 'package:broadmin/screens/sub_category.dart';
import 'package:broadmin/services/firestore.dart';
import 'package:broadmin/widgets/my_form.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';

class AddSubItem extends StatefulWidget {

  final dataServices;

  const AddSubItem({Key key, @required this.dataServices}) : super(key: key);

  @override
  _AddSubItemState createState() => _AddSubItemState();
}

class _AddSubItemState extends State<AddSubItem> {
  List<MyFormField> myForms = [];

  String categoryName;
  Uri imageUrl;
  static int orderNumber = 99;

  String name;
  String price;

  Map<String, dynamic> services = {};

  List<Map> mapList = [];

  Map resultServices = {};

  Future<Uri> uploadImageFile(image, imageName) async {
    fb.StorageReference storageRef =
        fb.storage().ref('${imageName + Random().nextInt(100).toString()}');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(image).future;
    Uri url = await uploadTaskSnapshot.ref.getDownloadURL();
    return url;
  }

  uploadImage() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
      (changeEvent) {
        final file = uploadInput.files.first;
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen(
          (loadEndEvent) async {
            uploadImageFile(file, file.name).then(
              (value) {
                setState(() {
                  imageUrl = value;
                });
              },
            );
          },
        );
      },
    );
  }

  Future<void> orderDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextFormField(
            decoration: InputDecoration(
              labelText: "Введите номер в очереди",
            ),
            onChanged: (val) {
              setState(() {
                orderNumber = int.parse(val);
              });
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                print(orderNumber);
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text('Создать подкатегорию'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'Введите название категории'),
                      onChanged: (val) {
                        categoryName = val;
                      },
                    ),
                  ),
                ),
//                if(imageUrl != null)
                if (imageUrl != null)
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network('$imageUrl')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        uploadImage();
                      });
                    },
                    child: Text('Загрузить фото'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        orderDialog(context);
                      });
                    },
                    child: Text('Номер в очереди'),
                  ),
                )
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Список услуг в категории',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Введите наименование услуги'),
                      onSaved: (String value) {
                        name = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Введите стоимость услуги'),
                      onSaved: (String value) {
                        price = value;
                        services = Map.fromEntries([MapEntry(name, price)]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RaisedButton(
                      onPressed: () {
                        _formKey.currentState.save();

                        if (name != '' && price != '') {
                          mapList.add(services);
                        } else {
                          print('Empty text fealds');
                        }

                        _formKey.currentState.reset();
                        print(mapList);
                        setState(() {});
                      },
                      child: Text('Добавить услугу'),
                    ),
                  ),
                  Column(
                    children: mapList
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$e',
                                style: TextStyle(fontSize: 16),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(children: myForms.toList()),
            ),
            RaisedButton(
              onPressed: () async {
                mapList.forEach((element) {
                  resultServices.addAll(element);

                  print(resultServices);
                });

                print(orderNumber);
                if (categoryName != '' && imageUrl != null) {
                  try {
                    final result = await DataBase()
                        .fireStore
                        .collection('fixitemcollection')
                        .document('${widget.dataServices.documentID}')
                        .collection('models')
                        .document('$categoryName')
                        .setData({
                      'set': true,
                      'order': orderNumber,
                      'image': imageUrl.toString(),
                      'services': resultServices
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e.toString());
                  }
                } else {
                  print('Заполните все поля');
                }
              },
              child: Text('Добавить подкатегорию'),
            ),
          ],
        ),
      ),
    );
  }
}
