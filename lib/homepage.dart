import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/main.dart';
import 'api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formkey = GlobalKey<FormState>();

  //Image Picker
  //
  File? image;
  Future pickImage(ImageSource source) async {
    final image = await ImagePicker()
        .pickImage(source: source, maxHeight: 1200, maxWidth: 1200);
    if (image == null) return;
    print("***********Image Length******************");
    print(await image.length());
    final imageTemporary = File(image.path);
    //final file = await compressFile(image.path);
    final imagePermanent = await saveImagePermanently(imageTemporary.path);
    setState(() {
      this.image = imagePermanent;
    });
  }

  Future<File> compressFile(String path) async {
    File compressedFile = await FlutterNativeImage.compressImage(path,
        quality: 20, percentage: 60);
    return compressedFile;
  }

  //
  //To save image permanently
  //
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  final TextEditingController _imageValue = TextEditingController();
  var facility = "-1";
  var meter = "-1";

  var imageValue = '000000';
  void clickfunction() async {
    var reading = await GetReading(image);
    setState(() {
      imageValue = reading;
    });
  }

  final _value = "-1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/homebackground.png'),
                  fit: BoxFit.fill)),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 95,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    )),
                value: _value,
                items: const [
                  DropdownMenuItem(
                    value: "-1",
                    child: Text("Select Facility"),
                  ),
                  DropdownMenuItem(
                    value: "Conzerv",
                    child: Text("Conzerv"),
                  ),
                  DropdownMenuItem(
                    value: "Salarpuria Supreme",
                    child: Text("Salarpuria Supreme"),
                  ),
                  DropdownMenuItem(
                    value: "Intuitive.co",
                    child: Text("Intuitive.co"),
                  ),
                  DropdownMenuItem(
                    value: "ITPL",
                    child: Text("ITPL"),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    facility = v.toString();
                    print(facility);
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 95,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    )),
                value: _value,
                items: const [
                  DropdownMenuItem(
                    value: "-1",
                    child: Text("Select Energy Meter"),
                  ),
                  DropdownMenuItem(
                    value: "FLORA CEI",
                    child: Text("FLORA CEI"),
                  ),
                  DropdownMenuItem(
                    value: "L&T",
                    child: Text("L&T"),
                  ),
                  DropdownMenuItem(
                    value: "EM976",
                    child: Text("EM976"),
                  ),
                  DropdownMenuItem(
                    value: "Schneider Electric",
                    child: Text("Schneider Electric"),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    meter = v.toString();

                    print(meter);
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 250,
            width: 350,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: image != null
                  ? Image.file(
                      image!,
                      width: 350,
                      height: 350,
                      fit: BoxFit.cover,
                    )
                  : const Image(
                      image: AssetImage('assets/logo-icon.png'),
                      width: 350,
                      height: 350,
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ElevatedButton(
              //     onPressed: () {
              //       pickImage(ImageSource.gallery);
              //     },
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const <Widget>[
              //         Icon(
              //           Icons.image_outlined,
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text('Import From Gallery'),
              //         SizedBox(
              //           height: 5,
              //         )
              //       ],
              //     )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff006590),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        // Icon(
                        //   Icons.camera_alt_outlined,
                        // ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Take Reading'),
                        SizedBox(
                          height: 0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                child: SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: clickfunction,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff006590),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        // Icon(
                        //   Icons.camera_alt_outlined,
                        // ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Get value'),
                        SizedBox(
                          height: 0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
              key: formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      margin: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          IntrinsicWidth(
                            child: TextField(
                              controller: _imageValue,
                              decoration: InputDecoration(
                                hintText: imageValue,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              autocorrect: false,
                            ),
                          ),
                          Text(
                            ' W',
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 45,
                    width: 170,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff006590),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            // Icon(
                            //   Icons.camera_alt_outlined,
                            // ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Change'),
                            SizedBox(
                              height: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 85,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (facility == "-1") {
                    const text = 'Please select facility';

                    const snackBar = SnackBar(content: Text(text));

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  if (meter == "-1") {
                    const text = 'Please select meter';

                    const snackBar = SnackBar(content: Text(text));

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    var fileRefPath = await optimaCheckin(image);
                    const JsonCodec json = JsonCodec();
                    Map valueMap = json.decode(fileRefPath);
                    String fileRef = valueMap["fileRef"];
                    String fileName = valueMap["name"];
                    await UpdateReadings(
                        fileRef, facility, meter, _imageValue.text);
                    const text = 'Upload successful';
                    const snackBar = SnackBar(content: Text(text));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff006590),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    // Icon(
                    //   Icons.camera_alt_outlined,
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload'),
                    SizedBox(
                      height: 0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 85,
                width: 140,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(MaterialPageRoute(
                          builder: ((context) => const Meter())));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff006590),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        // Icon(
                        //   Icons.camera_alt_outlined,
                        // ),

                        Text('Logout'),
                        SizedBox(
                          height: 0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
