import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dailynotes/data/dbHelper.dart';
import 'package:dailynotes/models/product.dart';
import 'package:dailynotes/screens/product_add.dart';
import 'package:dailynotes/screens/product_detail.dart';
import 'package:dailynotes/screens/product_list_all.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State<ProductList> {
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
        title: Text("Today's notes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              goToListPage();
            },
          )
        ],
      ),
      body: buildProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToProductAdd();
        },
        child: Icon(Icons.add),
        tooltip: "New note",
      ),
    );
  }

  Widget buildProductList() {
    return ListView.builder(
        itemCount: productCount,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: getCardColorForDone(this.products[position].done),
            semanticContainer: true,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amberAccent,
                child: Text("N"),
              ),
              title: Text(this.products[position].name),
              subtitle: Text(this.products[position].description),
              trailing: IconButton(
                icon: Icon(Icons.details),
                tooltip: "Details",
                color: Colors.redAccent,
                onPressed: (){
                  gotoDetail(this.products[position]);
                },
              ),
            ),
          );
        });
  }

  void getProducts() async {
    var productsFuture = dbHelper.getProducts(isOnlyToday: true);
    productsFuture.then((data) {
      setState(() {
        this.products = data;
        this.productCount = data.length;
      });
    });
  }

  void goToProductAdd() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductAdd()));
    if (result != null) if (result) getProducts();
  }

  void gotoDetail(Product product) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product)));
    if (result != null) if (result) getProducts();
  }

  void goToListPage() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListAll()));
    getProducts();
  }

  getCardColorForDone(int done) {
    if (done == 1)
      return Colors.white10;
    else
      return Colors.amberAccent;
  }
}
