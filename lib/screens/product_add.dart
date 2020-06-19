import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dailynotes/data/dbHelper.dart';
import 'package:dailynotes/models/product.dart';

class ProductAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductAddState();
  }
}

class ProductAddState extends State<ProductAdd> {
  var dbHelper = DbHelper();
  var txtName = TextEditingController();
  var txtDescription = TextEditingController();
  var txtDate = TextEditingController();
  var validate = true;

  @override
  void initState() {
    var dt = DateTime.now();
    txtDate.text = "${dt.year}-${dt.month}-${dt.day}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add notes of day"),
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[buildNameField(), buildDescriptionField(), buildDateField(), buildSaveButton()],
          ),
        ));
  }

  Widget buildNameField() {
    return TextField(
      decoration: InputDecoration(hintText: "Title", errorText: !validate ? "Required!" : null),
      controller: txtName,
    );
  }

  Widget buildDescriptionField() {
    return TextField(
      decoration: InputDecoration(hintText: "Description"),
      controller: txtDescription,
    );
  }

  Widget buildDateField() {
    return TextField(
      decoration: InputDecoration(hintText: ""),
      controller: txtDate,
      enabled: false,
    );
  }

  buildSaveButton() {
    return RaisedButton(
      child: Text("Save"),
      onPressed: () {
        addProduct();
      },
    );
  }

  void addProduct() async {
    setState(() {
      txtName.text.isEmpty ? validate = false : validate = true;
    });

    if (validate) {
      await dbHelper.add(Product(name: txtName.text, description: txtDescription.text, date: txtDate.text, done: 0, active: 1));
      Navigator.pop(context, true);
    }
  }
}
