import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FixPrice extends StatelessWidget {
  final String header;
  final String price;
  final String category;

  const FixPrice({Key key, this.header, this.price, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            height: 50,
            width: 200,
            child: Center(
              child: Text(

                '$header',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                height: 50,

                child: Center(
                  child: Text(
                    '$price',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
