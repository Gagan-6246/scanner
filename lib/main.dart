import 'package:flutter/material.dart';
import 'package:scanner/homepage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scanner/api.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Meter(),
    ));

class Meter extends StatefulWidget {
  const Meter({super.key});

  @override
  State<Meter> createState() => _MeterState();
}

final formkey = GlobalKey<FormState>();
bool _obscureText = true;

class _MeterState extends State<Meter> {
  //
  //Data for Forms
  //
  String username1 = 'first screen content', password1 = 'null';

  final TextEditingController _usernameControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff2B3136),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/login.png'), fit: BoxFit.fill)),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                const SizedBox(
                    height: 100,
                    child: Image(image: AssetImage('assets/logo.png'))),
                Form(
                    key: formkey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 100,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _usernameControler,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              // prefixIcon: Icon(Icons.supervised_user_circle),

                              label: Text('User Name',
                                  style: TextStyle(color: Colors.white)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            validator: (value) {
                              if (value != null && value.length < 4) {
                                return "Name should contain atleast 4 alphabets";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _passwordControler,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              // prefixIcon: Icon(Icons.supervised_user_circle),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white30,
                                ),
                              ),
                              label: const Text('Password',
                                  style: TextStyle(color: Colors.white)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value != null && value.length < 4) {
                                return "Enter valid password";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final isValidForm =
                                          formkey.currentState!.validate();
                                      // const isValidFor = true;
                                      if (isValidForm) {
                                        var token = await login();
                                        if (token != "") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const Home())));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Invalid credentials")));
                                        }
                                      } else {}
                                      username1 = _usernameControler.text;
                                      password1 = _passwordControler.text;
                                      // print(username1);
                                      // print(password1);

                                      // print('validCity');
                                      // print(image);
                                      // print(city.hashCode);
                                      //
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const <Widget>[
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 300,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
