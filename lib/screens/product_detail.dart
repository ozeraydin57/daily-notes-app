import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dailynotes/data/dbHelper.dart';
import 'package:dailynotes/models/product.dart';

class ProductDetail extends StatefulWidget {
  Product product;
  ProductDetail(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailState(product);
  }
}

enum Options { delete, update }

class _ProductDetailState extends State<ProductDetail> {
  Product product;
  _ProductDetailState(this.product);
  var dbHelper = DbHelper();
  var txtName = TextEditingController();
  var txtDescription = TextEditingController();
  var txtDate = TextEditingController();
  var done, active;

  @override
  void initState() {
    txtName.text = product.name;
    txtDescription.text = product.description;
    txtDate.text = product.date.toString();
    done = product.done;
    active = product.active;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note: ${product.name}"),
        actions: <Widget>[
          PopupMenuButton<Options>(
            onSelected: selectProcess,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
              PopupMenuItem<Options>(
                value: Options.delete,
                child: Text("Delete"),
              ),
              PopupMenuItem<Options>(
                value: Options.update,
                child: Text("Update"),
              ),
            ],
          )
        ],
      ),
      body: buildProductDetail(),
    );
  }

  buildProductDetail() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[buildNameField(), buildDescriptionField(), buildDateField()],
      ),
    );
  }

  Widget buildNameField() {
    return TextField(
      decoration: InputDecoration(hintText: "Title"),
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

  void selectProcess(Options options) async {
    switch (options) {
      case Options.delete:
        await dbHelper.delete(product.id);
        Navigator.pop(context, true);
        break;
      case Options.update:
        await dbHelper.update(
            Product.withId(id: product.id, name: txtName.text, description: txtDescription.text, date: txtDate.text, done: done, active: active));
        Navigator.pop(context, true);
        break;
      default:
    }
  }
}
