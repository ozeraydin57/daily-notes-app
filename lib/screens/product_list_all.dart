import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dailynotes/data/dbHelper.dart';
import 'package:dailynotes/models/product.dart';

class ProductListAll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductListAllState();
  }
}

class _ProductListAllState extends State<ProductListAll> {
  var dbHelper = DbHelper();
  List<Product> products;
  int productCount = 0;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All notes"),
      ),
      body: buildProductListAll(),
    );
  }

  Widget buildProductListAll() {
    return ListView.builder(
        itemCount: productCount,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: getCardColorForDone(this.products[position].done),
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(this.products[position].name),
                  subtitle: Text(this.products[position].description),
                  trailing: Column(
                    children: <Widget>[],
                  ),
                  //Text(this.products[position].date.toString()),
                ),
                ButtonBar(
                  children: <Widget>[
                    Text(this.products[position].date),
                    IconButton(
                      icon: getIconForDone(this.products[position].done),
                      tooltip: "Mark as done",
                      onPressed: () {
                        updateProductDone(this.products[position]);
                        finalSnackBar(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.update),
                      tooltip: "Update date",
                      onPressed: () {
                        updateProductDate(this.products[position]);
                        finalSnackBar(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: "Delete forever",
                      onPressed: () {
                        deleteProduct(this.products[position].id);
                        finalSnackBar(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void getProducts() async {
    var productsFuture = dbHelper.getProducts(isOnlyToday: false);
    productsFuture.then((data) {
      setState(() {
        this.products = data;
        this.productCount = data.length;
      });
    });
  }

  void deleteProduct(int id) async {
    await dbHelper.delete(id);
    getProducts();
  }

  void updateProductDate(Product product) async {
    var dt = DateTime.now();
    product.date = "${dt.year}-${dt.month}-${dt.day}";
    await dbHelper.update(product);
    setState(() {});
  }

  void updateProductDone(Product product) async {
    if (product.done == 1)
      product.done = 0;
    else
      product.done = 1;
    await dbHelper.update(product);
    setState(() {});
  }

  getCardColorForDone(int done) {
    if (done == 1)
      return Colors.white10;
    else
      return Colors.amberAccent;
  }

  Widget getIconForDone(int done) {
    if (done == 1)
      return Icon(Icons.remove_circle);
    else
      return Icon(Icons.done);
  }

  void finalSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Operation is done'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
