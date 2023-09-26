import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final httpClient = http.Client();

// Create storage
// final storage = new FlutterSecureStorage();
// final String ipAddress = "192.168.98.42:8080";
const String ipAddress = "3.212.251.223:8080/EMRA";
const String pythonAddress = "3.212.251.223";
final LocalStorage storage = new LocalStorage('localstorage_app');
var loginheaders = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'Authorization': 'Basic Y2xpZW50OnNlY3JldA==',
};

Future GetReading(var image) async {
  var returnVal = "000000";
  try {
    File file = new File(image.path);
    String fileName = basename(file.path);

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://' + pythonAddress + ':5000/im_size'));
    request.fields.addAll({'filename': fileName});
    print(image.path);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var returnMessage = await response.stream.bytesToString();
      returnVal = returnMessage;
    } else {
      print(response.reasonPhrase);
    }
  } catch (e) {
    print('error caught: $e');
  }
  return returnVal;
}

// Post login details
Future<String> login() async {
  final Uri restAPIURL = Uri.parse("http://" + ipAddress + "/oauth/token");

  var request = http.Request('POST', restAPIURL);
  request.bodyFields = {
    'grant_type': 'password',
    'username': 'admin',
    'password': 'admin'
  };
  request.headers.addAll(loginheaders);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var serverResponse = await response.stream.bytesToString();
    Map valueMap = json.decode(serverResponse);
    String token = valueMap["access_token"];
    print(token); // [Hello, world!];
    await storage.ready;
    print("storage is ready");
    await storage.setItem("token", token);
    print(storage.getItem('token'));
    // await storage.write(key: 'Token', value: token);
    return token;
  } else {
    print(response.reasonPhrase);
    return "";
  }
}

Future optimaCheckin(var image) async {
  var ready = await storage.ready;
  String token = storage.getItem('token');
  var headers = {
    'Authorization': 'Bearer ' + token,
    // 'Authorization': 'Bearer 49o4YcTpG5tzAJsuHctlZUegRlQ',
  };
  File file = new File(image.path);
  String fileName = basename(file.path);
  var url = "http://" + ipAddress + "/rest/files?name=" + fileName;

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('file', image.path));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("response.statusCode:");
  print(response.statusCode);
  var responseVal = "";

  if (response.statusCode == 200 || response.statusCode == 201) {
    responseVal = await response.stream.bytesToString();

    print(responseVal);
  } else {
    print(response.reasonPhrase);
  }
  return responseVal;
}

Future UpdateReadings(
    var fileShare, String facility, String meter, String meterReading) async {
  var ready = await storage.ready;
  String token = storage.getItem('token');

  var headers = {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json',
  };
  var request = http.Request(
      'POST',
      Uri.parse("http://" +
          ipAddress +
          "/rest/services/energymeterreadingautomation_ReadingBean/GetDataToImage"));
  request.body = json.encode({
    "energyMeters": meter,
    "facilities": facility,
    "mobile": "9845976790",
    // "photo":
    //     "fs://2022/12/01/95a20f63-f14c-cc07-6533-23acabf5374a.jpg?name=enerymeter1.jpg"
    "photo": fileShare,
    "meterReading": meterReading
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 204) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
