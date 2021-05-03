import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:kitchenapp/secondpage.dart';

import 'config/size_config.dart';

class KitchenProducts extends StatefulWidget {
  @override
  _KitchenProductsState createState() => _KitchenProductsState();
}

class _KitchenProductsState extends State<KitchenProducts> {
  bool isLoading;
  var data;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("http://13.233.85.98/Troop/Common/GetAllProducts.php");
    var response = await http.get(url);
    data = json.decode(response.body);
    print(data[0]);
    setState(() {
      isLoading = false;
      data.removeAt(12);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Kitchen Products",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: GridView.builder(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data == null ? 0 : data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GridTile(

                                  /// wrapping whole thing in InkWell to make it clickAble
                                  child: InkWell(
                                onTap: () {
                                  /// Navigating to screen 2 onTap
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ProductDetails(
                                      productId: int.tryParse(
                                          data[index]["productId"]),
                                    );
                                  }));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(5)),
                                  height: getProportionateScreenHeight(25),
                                  width: getProportionateScreenWidth(25),
                                  child: Column(
                                    children: [
                                      // FlutterLogo(),
                                      Image.network(
                                          data[index]["imageUrl"].toString(),
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover),

                                      Text(
                                        data[index]['name'].toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 5.0,
                              crossAxisSpacing: 5.0,
                            ),
                          ),
                        ),
                      ])),
            )
          ],
        ))));
  }
}
