//  Map service123 = Map.fromEntries([MapEntry(_controllerName.text,_controllerPrice.text)]);
import 'dart:html';
import 'dart:math';
import 'package:broadmin/services/firestore.dart';
import 'package:broadmin/widgets/my_form.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';

class SubCategory extends StatefulWidget {
  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
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
        title: Text('Создать категорию и подкатегории'),
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
                    await DataBase()
                        .fireStore
                        .collection('fixitemcollection')
                        .document('$categoryName')
                        .setData({
                      'set': true,
                      'order': orderNumber,
                      'image': imageUrl.toString(),
                    }).then(
                      (_) => DataBase()
                          .fireStore
                          .collection('fixitemcollection')
                          .document('$categoryName')
                          .collection('models')
                          .document('blanc')
                          .setData({}),
                    );

                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/'),
                    );
                  } catch (e) {
                    print(e.toString());
                  }
                } else {
                  print('Заполните все поля');
                }
              },
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}
