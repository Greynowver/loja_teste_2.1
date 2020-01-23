import 'package:flutter/material.dart';
import 'package:school_business/datas/catalog/product_data.dart';
import 'package:school_business/datas/contract/contract_data.dart';
import 'package:school_business/helpers/catalog/product_helper.dart';
import 'package:school_business/widgets/colors_widget.dart';

import '../../responsive.dart';

class ProductVersionPage extends StatefulWidget {

  final Product product;

  ProductVersionPage({this.product});

  @override
  _ProductVersionPageState createState() => _ProductVersionPageState();
}

class _ProductVersionPageState extends State<ProductVersionPage> {


  @override
  void initState() {
    getInfoProduct(widget.product.codProduct);
    super.initState();
  }

  var versionList = <Product>[];

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.primary,
        ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30.0, left: 20.0, bottom: 20.0),
              height: MediaQuery.of(context).size.height*0.2,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(widget.product.category,
                        style: TextStyle(
                          fontSize: ResponsiveWidget.getFontSizeTitleResponsive(context),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(widget.product.name,
                        style: TextStyle(
                            fontSize: ResponsiveWidget.getFontSizeTxtResponsive(context),
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      border: Border.all(width: 3, color: Colors.yellow)
                  ),
                  child:  GridView.count(
                    childAspectRatio: (itemWidth / itemHeight),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 15,
                    children: List.generate(versionList.length, (index) {
                      return newCardItem(index);
                    }).toList(),
                  ),
                )
            )],
        ),
      ),
    );
  }

  Widget newCardItem(int index){
    return Container(
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context, versionList[index]);
        },
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.17,
              width: MediaQuery.of(context).size.width*0.15,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  )],
                  image: DecorationImage(
                      image: MemoryImage(
                          versionList[index].image),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Container(
              width: 48.0,
              margin: EdgeInsets.only(top: 15.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              alignment: Alignment.center,
              child: Text("${versionList[index].codVersion}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getInfoProduct(String codProductSelected) async {
    var versionsProducts = await ProductHelper.getAllVersionsByCodProduct(codProductSelected);
    setState(() {
      versionList = versionsProducts;
    });

  }

}

