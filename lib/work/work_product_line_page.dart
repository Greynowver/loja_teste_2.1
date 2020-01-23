import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school_business/datas/catalog/line_data.dart';
import 'package:school_business/datas/catalog/product_data.dart';
import 'package:school_business/datas/contract/kit/kit_data.dart';
import 'package:school_business/helpers/catalog/line_helper.dart';
import 'package:school_business/helpers/catalog/product_helper.dart';
import 'package:school_business/pages/contract/sections/product_version_page.dart';
import 'package:school_business/pages/responsive.dart';
import 'package:school_business/widgets/appBar_widget.dart';
import 'package:school_business/widgets/colors_widget.dart';
import 'package:school_business/widgets/pattern_text_field_widget.dart';

class ProductLinePage extends StatefulWidget {
  final Kit kit;

  ProductLinePage({this.kit});

  @override
  State<StatefulWidget> createState() => ProductLineState();
}

class ProductLineState extends State<ProductLinePage> {
  var _lineDefault = '_ADD';
  var lineIdDropDown;
  var distinctCategorys = <Product>[];
  var productsByCategory = <Product>[];
  var versionList = <Product>[];
  var category;
  Uint8List productImage;

  Product selectProduct;
  String version;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<int> generateNumbers() => List<int>.generate(versionList.length, (i) => i + 1);
  bool expandFlag = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    loadingLines();
    super.initState();
  }

  Widget build(BuildContext context) {
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
            child: Row(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*1,
                    child: Column(
                        children: <Widget>[
                          PatternTextTitlePage(text: "Produtos"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //PatternSubTitlePage(text: "Linha: "),
                              lineDropDown(),
                            ],
                          ),
                          drawerCategory(),
                          //expandableCategory()
                        ]
                    )
                ),
                Container(
                    padding: EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*1,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(topLeft:  Radius.circular(40)),
                        border: Border.all(width: 3, color: Colors.yellow)
                    ),
                    child: versionList == null ? Container() : layoutRight()
                )
              ],
            )
        )
    );
  }

  Widget layoutRight(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          newLayoutItem(selectProduct),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("VERSÕES",
                      style: TextStyle(
                          fontSize: ResponsiveWidget.getFontSizeSubTitleResponsive(context),
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                Container(
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: (0.5 / 0.15),
                    crossAxisCount: 5,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 15,
                    shrinkWrap: true,
                    children: List.generate(versionList.length, (index) {
                      return newCardItem(index);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.1,
          ),
          FlatButton(
            child: Text(
              "ADICIONAR PRODUTO",
            ),
            textColor: Colors.white,
            color: AppColors.positiveAction,
            onPressed: (){

            },
          )
        ]
    );
  }

  Widget newLayoutItem(Product a){
    return Container(
        child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(a == null ? " " : "${a.category}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: ResponsiveWidget.getFontSizeTitleResponsive(context),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,

                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(a == null ? ' ' : a.name,
                            style: TextStyle(
                                color: Colors.white
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                            child: Text(a == null ? ' ' : a.name,
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
              ),
              productImage == null ? Container() :
              GestureDetector(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 35),
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Colors.black,
                          blurRadius: 30.0,
                          spreadRadius: 3.0,
                        )]
                        ,
                        image: DecorationImage(
                            image: MemoryImage(
                                productImage),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  onTap: (){
                    getProductFromInfo(a);
                  }),
            ]
        )

    );
  }

  void getProductFromInfo(Product a) async{
    Product result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductVersionPage(product: a)));
    if(result != null){
      setState(() {
        productImage = result.image;
        version = result.codVersion;
      });
    }
  }

  Widget newCardItem(int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          version = versionList[index].codVersion;
          selectProduct = versionList[index];
          productImage = selectProduct.image;

        });
        print(version);
      },
      child: Container(
        decoration: BoxDecoration(
          color: versionList[index].codVersion != version ? Colors.yellow : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
            color: versionList[index].codVersion == version ? Colors.yellow : Colors.white,
          ),
        ),
        width: 10.0,
        alignment: Alignment.center,
        child: Text("${versionList[index].codVersion}",
          style: TextStyle(
            color: versionList[index].codVersion == version ? Colors.yellow : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget lineDropDown(){
    return Container(
      width: MediaQuery.of(context).size.width*0.25,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton<String>(
          value: _lineDefault,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          iconSize: 24,
          style: TextStyle(
              color: AppColors.textField
          ),
          underline: Container(
            height: 2,
            color: Colors.transparent,
          ),
          isExpanded: true,
          items: _dropDownMenuItems,
          onChanged: (newValue) {
            setState(() {
              _lineDefault = newValue;
              lineIdDropDown = newValue;
              loadingProductsByLine(int.parse(_lineDefault));
            });
          }
      ),
    );
  }

  void loadingLines() async {
    List<Line> lines = await LineHelper.getAllLines();

    setState(() {
      _dropDownMenuItems = getDropDownMenuItems(lines);
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(List<Line> lines) {
    List<DropdownMenuItem<String>> items = List();

    for (Line line in lines) {

      String textValue = line.line != null ? line.line : "";

      items.add(
          DropdownMenuItem(
              value: line.lineId.toString(),
              child: Text(textValue)
          )
      );
    }

    items.add(
      DropdownMenuItem(value: "_ADD",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Nenhum"),
            ],
          )),
    );

    return items;
  }

  void loadingProductsByLine(int lineId) async {
    List<Product> categoryList = await ProductHelper.getProductsByLine(lineId);
    setState(() {
      distinctCategorys = categoryList;
    });

  }

  Widget drawerCategory(){
    return Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: ListView.builder(
            itemCount: distinctCategorys.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                title: Text(distinctCategorys[index].category),
                key: PageStorageKey<String>(index.toString()),
                children: <Widget>[
                  Column(
                    children: _getProducts(distinctCategorys[index]),
                  )
                ],
              );
            }
        ));
  }

  _getProducts(Product category) {
    List<Widget> list = [];
    list.add(
        GestureDetector(
          onTap: (){
            getInfoProduct(category.codProduct);
          },
          child:
          Text(category.category),
        )
    );

    return list;
  }

  void getAllProductsCategory(String category) async {
    List<Product> allProductsCategory = await ProductHelper.getAllProductsByCategoryAndLine(category, int.parse(lineIdDropDown));
    setState(() {
      productsByCategory = allProductsCategory;
    });
  }

  void getInfoProduct(String codProductSelected) async {
    var versionsProducts = await ProductHelper.getAllVersionsByCodProduct(codProductSelected);
    setState(() {
      versionList = versionsProducts;
    });

  }

}

