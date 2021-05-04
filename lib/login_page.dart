import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appentus_task/database_helper.dart';
import 'package:flutter_appentus_task/home_page.dart';
import 'package:flutter_appentus_task/utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class GradiantBtn extends StatelessWidget {
  var txt, dO, width, height, txtClr;
  var clr;

  GradiantBtn({
    @required this.txt,
    @required this.width,
    @required this.height,
    @required this.dO,
    @required this.clr,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: RaisedButton(
        onPressed: dO,
        padding: const EdgeInsets.all(0.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(54, 58, 113, 1),
                  Color.fromRGBO(68, 76, 140, 1),
                  Color.fromRGBO(71, 79, 156, 1),
                  Color.fromRGBO(68, 76, 140, 1),
                  Color.fromRGBO(54, 58, 113, 1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            txt,
            style: TextStyle(
              color: clr,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

cDialog(BuildContext context, Icon iC, String headerTxt, String content,
    double containerH, Color hClr, Color dClr) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Color.fromRGBO(208, 216, 239, 1),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
    content: Container(
      height: containerH,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                iC,
                Text(
                  headerTxt,
                  style: TextStyle(fontWeight: FontWeight.bold, color: hClr),
                )
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              content,
              style: TextStyle(fontWeight: FontWeight.w300, color: dClr),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GradiantBtn(
                  txt: "Ok",
                  width: 80.0,
                  height: 40.0,
                  dO: () => Navigator.of(context).pop(),
                  clr: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );

  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(seconds: 1),
      transitionBuilder: (BuildContext context, Animation<double> a1,
              Animation<double> a2, Widget child) =>
          SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(a1),
              child: alert),
      pageBuilder: (context, anim1, anim2) {
        return Transform.rotate(
          angle: anim1.value,
        );
      });
}

class TextFieldCustomValidation extends StatelessWidget {
  TextEditingController teController;
  String errorTxt, hintText;
  var ic,
      textDirection,
      isEnabled,
      txtObscured,
      customValidation,
      line,
      onChangeDo;

  TextFieldCustomValidation({
    @required this.textDirection,
    @required this.teController,
    @required this.errorTxt,
    @required this.hintText,
    @required this.ic,
    @required this.isEnabled,
    @required this.txtObscured,
    @required this.customValidation,
    @required this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: new Directionality(
        textDirection: textDirection,
        child: TextFormField(
          maxLines: line,
          obscureText: txtObscured,
          enabled: isEnabled,
          controller: teController,
          validator: customValidation,
          onChanged: onChangeDo,
          decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
              filled: true,
              hintStyle: new TextStyle(color: Colors.grey[800]),
              hintText: "$hintText",
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  height: (line > 1) ? 120 : 35,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(54, 58, 113, 1),
                          Color.fromRGBO(68, 76, 140, 1),
                          Color.fromRGBO(71, 79, 156, 1),
                          Color.fromRGBO(68, 76, 140, 1),
                          Color.fromRGBO(54, 58, 113, 1),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(0.0),
                      )),
                  child: ic,
                ),
              ),
              fillColor: Colors.white70),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTFCtrl = new TextEditingController();
  TextEditingController userPassTFCtrl = new TextEditingController();
  bool loading = false;

  final dbhelper = DBHelper.instance;

  Future<List> fetchDataFromDatabase(String email, String passcode) async {
    var allrows = await dbhelper.querySpecific(email, passcode);
    return allrows;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        "WELCOME",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(208, 216, 239, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0, // soften the shadow
                                spreadRadius: 2.0, //extend the shadow
                                offset: Offset(
                                  2.0, // Move to right 10  horizontally
                                  2.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            TextFieldCustomValidation(
                                textDirection: TextDirection.ltr,
                                teController: emailTFCtrl,
                                errorTxt: "Please Insert Your Email",
                                hintText: "Email",
                                ic: Icon(
                                  Icons.alternate_email,
                                  color: Colors.white,
                                ),
                                isEnabled: true,
                                txtObscured: false,
                                customValidation: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Your email!';
                                  }
                                },
                                line: 1),
                            SizedBox(
                              height: 6,
                            ),
                            TextFieldCustomValidation(
                                textDirection: TextDirection.ltr,
                                teController: userPassTFCtrl,
                                errorTxt: "Please Insert Your Password",
                                hintText: "Password",
                                ic: Icon(
                                  Icons.security,
                                  color: Colors.white,
                                ),
                                isEnabled: true,
                                txtObscured: true,
                                customValidation: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Your Password!';
                                  }
                                },
                                line: 1),
                            SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  var result = await fetchDataFromDatabase(
                                      emailTFCtrl.text, userPassTFCtrl.text);
                                  print(result);
                                  if (result.isNotEmpty) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                name: result[0]['name'],
                                                photo: result[0]['photo'])));
                                  } else {
                                    cDialog(
                                        context,
                                        Icon(Icons.warning_amber_rounded,
                                            color:
                                                Color.fromRGBO(68, 76, 140, 1)),
                                        " Information Missing!",
                                        "Either Email or password is wrong!",
                                        135,
                                        Color.fromRGBO(68, 76, 140, 1),
                                        Color.fromRGBO(68, 76, 140, 1));
                                  }
                                } else {
                                  cDialog(
                                      context,
                                      Icon(Icons.warning_amber_rounded,
                                          color:
                                              Color.fromRGBO(68, 76, 140, 1)),
                                      " Information Missing!",
                                      "Please Enter Your Email And Password To Login!",
                                      135,
                                      Color.fromRGBO(68, 76, 140, 1),
                                      Color.fromRGBO(68, 76, 140, 1));
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(54, 58, 113, 1),
                                            Color.fromRGBO(68, 76, 140, 1),
                                            Color.fromRGBO(71, 79, 156, 1),
                                            Color.fromRGBO(68, 76, 140, 1),
                                            Color.fromRGBO(54, 58, 113, 1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Center(
                                      child: Text(
                                        'LOGIN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Not A Member Yet? ",
                                  style: TextStyle(
                                      color: Color.fromRGBO(68, 76, 140, 1)),
                                ),
                                FlatButton(
                                  child: Text(
                                    "SIGNUP",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  String imgString;
  File userImage;

  TextEditingController userNameTFCtrl = new TextEditingController();
  TextEditingController emailTFCtrl = new TextEditingController();
  TextEditingController userPassWTFCtrl = new TextEditingController();
  TextEditingController userNumberTFCtrl = new TextEditingController();

  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final dbhelper = DBHelper.instance;

  void insertDataIntoDatabase(String name, String email, String passcode,
      int number, String photo) async {
    Map<String, dynamic> row = {
      DBHelper.columnName: name,
      DBHelper.columnEmail: email,
      DBHelper.columnPasscode: passcode,
      DBHelper.columnNumber: number,
      DBHelper.columnPhoto: photo,
    };

    final id = await dbhelper.insert(row);
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(208, 216, 239, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 2.0, // soften the shadow
                              spreadRadius: 2.0, //extend the shadow
                              offset: Offset(
                                2.0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          TextFieldCustomValidation(
                              textDirection: TextDirection.ltr,
                              teController: userNameTFCtrl,
                              errorTxt: "Please Insert Your Name",
                              hintText: "Name",
                              ic: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              isEnabled: true,
                              txtObscured: false,
                              customValidation: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Name!';
                                }
                              },
                              line: 1),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldCustomValidation(
                              textDirection: TextDirection.ltr,
                              teController: emailTFCtrl,
                              errorTxt: "Please Insert Your Email",
                              hintText: "Email",
                              ic: Icon(
                                Icons.alternate_email,
                                color: Colors.white,
                              ),
                              isEnabled: true,
                              txtObscured: false,
                              customValidation: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Email!';
                                } else {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!emailValid) {
                                    return 'Please Enter A Real Email Format!';
                                  }
                                }
                              },
                              line: 1),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldCustomValidation(
                              textDirection: TextDirection.ltr,
                              teController: userPassWTFCtrl,
                              errorTxt: "Please Insert Your Password",
                              hintText: "Password",
                              ic: Icon(
                                Icons.security,
                                color: Colors.white,
                              ),
                              isEnabled: true,
                              txtObscured: true,
                              customValidation: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Password!';
                                }
                              },
                              line: 1),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldCustomValidation(
                              textDirection: TextDirection.ltr,
                              teController: userNumberTFCtrl,
                              errorTxt: "Please Enter Your Number",
                              hintText: "Number",
                              ic: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              isEnabled: true,
                              txtObscured: false,
                              customValidation: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Number!';
                                } else {
                                  try {
                                    int.parse(value);
                                  } catch (e) {
                                    return 'Please Enter Your Number!';
                                  }
                                }
                              },
                              line: 1),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: OutlineButton(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 2.5),
                                onPressed: () async {
                                  // ignore: deprecated_member_use, missing_return
                                  ImagePicker.pickImage(
                                          source: ImageSource.gallery)
                                      .then((imgFile) {
                                    imgString = Utility.base64String(
                                        imgFile.readAsBytesSync());
                                    setState(() => userImage = imgFile);
                                  });
                                },
                                child: _displayImage(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Provide Your Image'),
                          SizedBox(
                            height: 25,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                print(userNameTFCtrl.text);
                                print(userNumberTFCtrl.text);
                                print(emailTFCtrl.text);
                                print(userPassWTFCtrl.text);
                                if (userImage != null) {
                                  setState(() {
                                    loading = true;
                                    insertDataIntoDatabase(
                                        userNameTFCtrl.text,
                                        emailTFCtrl.text,
                                        userPassWTFCtrl.text,
                                        int.parse(userNumberTFCtrl.text),
                                        imgString);
                                    Fluttertoast.showToast(
                                            msg: "Signed Up Successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromRGBO(68, 76, 140, 1),
                                            textColor: Colors.white,
                                            fontSize: 16.0)
                                        .then((value) {
                                      userNameTFCtrl.clear();
                                      emailTFCtrl.clear();
                                      userPassWTFCtrl.clear();
                                      userNumberTFCtrl.clear();
                                      imgString = '';
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    });
                                  });
                                } else
                                  print('image not supplied');
                              } else {
                                cDialog(
                                    context,
                                    Icon(Icons.warning_amber_rounded,
                                        color: Color.fromRGBO(68, 76, 140, 1)),
                                    " Missing Information!",
                                    "Please Fill All The Informations!",
                                    140,
                                    Color.fromRGBO(68, 76, 140, 1),
                                    Color.fromRGBO(68, 76, 140, 1));
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color.fromRGBO(54, 58, 113, 1),
                                          Color.fromRGBO(68, 76, 140, 1),
                                          Color.fromRGBO(71, 79, 156, 1),
                                          Color.fromRGBO(68, 76, 140, 1),
                                          Color.fromRGBO(54, 58, 113, 1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Center(
                                    child: Text(
                                      'SIGNUP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.white70,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Have An Account ? ",
                                style: TextStyle(color: Colors.white),
                              ),
                              FlatButton(
                                child: Text(
                                  "SIGNIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _displayImage() {
    if (userImage == null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 30.0),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.blueAccent,
          ),
        ),
      );
    } else {
      return Image.file(userImage, fit: BoxFit.cover, width: double.infinity);
    }
  }
}
