import 'package:flutter/material.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                color: Colors.white,
                height: size.height,
                child: ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    if (model.isLoading == true) {
                      return CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
                      );
                    }
                    return Form(
                      key: _formKey,
                      child: Material(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 380,
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
                                height: 40,
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
                                          'Recuperar',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          SnackBar snackBar = SnackBar(
                                            content: Text(
                                                'Mandamos um link de recuperação para seu e-mail :)'),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.0),
                                              ),
                                            ),
                                          );
                                          UserModel.of(context).recoverPassword(
                                              email: _emailController.text);
                                          _scaffoldKey.currentState
                                              .showSnackBar(snackBar);
                                          Future.delayed(Duration(seconds: 3))
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        }
                                      })),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
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
                      'Recuperação',
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
