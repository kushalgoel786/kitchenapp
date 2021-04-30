import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:kitchenapp/secondpage.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return ListTile(
                  leading: Image.network(
                    data[i]['imageUrl'],
                    height: 50,
                    width: 50,
                  ),
                  title: Text(data[i]['name'], style: GoogleFonts.montserrat()),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => ProductDetails(
                                productId: int.tryParse(data[i]["productId"]),
                              ))),
                );
              },
              itemCount: data.length - 3,
            ),
    );
  }
}
