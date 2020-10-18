import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Controlador do campo nome
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _visible = true;
  FaIcon _iconEye = FaIcon(FontAwesomeIcons.eye);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VoidCallback onSucess() {
    SnackBar snackBar = SnackBar(
      content:
          Text('Cadastrado Com Sucesso.'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

  VoidCallback onFail() {
    SnackBar snackBar = SnackBar(
      content:
          Text('Conta já existente! Volte a página e tente realizar login.'),
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      )),
      duration: Duration(seconds: 3),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
    Future.delayed(Duration(seconds: 3)).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: ScopedModelDescendant<UserModel>(
                builder: (contex, child, model) {
                  if (model.isLoading == true) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
                      ),
                    );
                  } else {
                    return Form(
                      key: _formKey,
                      child: Material(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 320,
                              ),
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Nome',
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    hintText: 'Insira seu nome completo',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD9611E),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD9611E),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    prefixIcon: Icon(Icons.person)),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                validator: (text) {
                                  if (text.isEmpty) return 'Insira seu nome!';
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    hintText: 'user@dominio.com',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD9611E),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD9611E),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    prefixIcon: Icon(Icons.email)),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                validator: (text) {
                                  if (text.isEmpty || !text.contains('@'))
                                    return 'Insira um email válido!';
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _visible,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Senha',
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    hintText: 'Insira uma senha',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD9611E),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD9611E),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    prefixIcon: Icon(Icons.vpn_key),
                                    suffixIcon: IconButton(
                                      highlightColor: Colors.orange,
                                      icon: _iconEye,
                                      onPressed: () {
                                        setState(() {
                                          _visible = !_visible;
                                          if (_visible)
                                            _iconEye =
                                                FaIcon(FontAwesomeIcons.eye);
                                          else
                                            _iconEye = FaIcon(
                                                FontAwesomeIcons.eyeSlash);
                                        });
                                      },
                                    )),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                validator: (text) {
                                  if (text.isEmpty) return 'Insira uma senha!';
                                },
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              Container(
                                  height: 55,
                                  width: 250,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18))),
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18)),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.orange,
                                                Color(0xFFD9611E)
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Cadastrar',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          Map<String, dynamic> userData = {
                                            'email': _emailController.text,
                                            'name': _nameController.text
                                          };

                                          UserModel.of(context).signUp(
                                              userData: userData,
                                              password:
                                                  _passwordController.text,
                                              onSucess: onSucess,
                                              onFail: onFail);
                                        }
                                      })),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FlatButton(
                                    highlightColor: Colors.black,
                                    child: Text(
                                      'Já possui conta?',
                                      style: TextStyle(
                                          color: Color(0xFFD9611E),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              height: 240,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.orange, Color(0xFFD9611E)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100))),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/brand/brand.png',
                      fit: BoxFit.cover,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    child: Text(
                      'Casdastro',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 30,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400),
                    ),
                    bottom: 25,
                    right: 20,
                  ),
                  Positioned(
                      top: 30,
                      left: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
