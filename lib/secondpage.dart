import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchenapp/firstpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  final int productId;
  ProductDetails({this.productId});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
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
    var url = Uri.parse(
        "http://13.233.85.98/Troop/Common/GetProductInfoByProductId.php?productId=${widget.productId}");
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
          "Products Details",
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
                  title: Text(data[i]['question'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.info),
                  subtitle: adaptiveWidget(data[i]),
                );
              },
              itemCount: data.length,
            ),
    );
    SizedBox(height: 40);
    RaisedButton(child: Text('SUBMIT'), onPressed: () {});
  }

  Widget adaptiveWidget(var data) {
    if (data["type"] == "text") {
      var nameController = TextEditingController();
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: new TextFormField(
          controller: nameController,
          decoration: new InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
          ),
        ),
      );
    } else if (data["type"] == "int") {
      var intController = TextEditingController();
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: new TextFormField(
          controller: intController,
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
          ),
        ),
      );
    } else if (data["type"] == "image") {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: TextButton(
          onPressed: () {},
          child: Text("Click to upload Image"),
        ),
      );
    } else if (data["type"] == "year") {
      return Container(
        height: 200,
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (newTime) {},
          maximumYear: int.tryParse(data["maxLength"]),
          minimumYear: int.tryParse(data["minLength"]),
          mode: CupertinoDatePickerMode.date,
        ),
      );
    } else if (data["type"] == "radio") {
      var radioItem = 0;
      var result = data["answer"].split(",");
      return Column(children: <Widget>[
        RadioListTile(
          groupValue: radioItem,
          title: Text(result[0]),
          value: 0,
          activeColor: Colors.black,
          onChanged: (value) {
            setState(() {
              radioItem = value;
            });
          },
        ),
        RadioListTile(
            groupValue: radioItem,
            title: Text(result[1]),
            value: 1,
            activeColor: Colors.black,
            onChanged: (value) {
              setState(() {
                radioItem = value;
              });
            })
      ]);
    }
  }
}


