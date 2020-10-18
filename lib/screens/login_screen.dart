import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:madero_reservas/screens/forgot_password_screen.dart';
import 'package:madero_reservas/screens/register_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //permite verificar se os campos já estão validados
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Controladores de cada campo
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  //visibilidade da senha
  bool _visible = true;
  //estado inicial do olho da senha
  FaIcon _iconEye = FaIcon(FontAwesomeIcons.eye);


  //Usei para exibir os snackbar de erro e sucesso
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Caso o cadastro ocorra bem
  VoidCallback onSucess() {
    //Instaciei uma snackbar
    SnackBar snackBar = SnackBar(
      content: Text('Login realizado com sucesso'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      //formato arredondado da snackbar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
    );


    //uso a chave "_scaffoldKey" que criei e coloquei dentro do scaffold para exibir na minha tela
    _scaffoldKey.currentState.showSnackBar(snackBar);

    //Essa função permite fazer o app "dormir" por alguns instantes
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.pop(context);
    });


  }

  //Caso ocorra algum erro no cadastro
  VoidCallback onFail() {
    //Instaciei uma snackbar
    SnackBar snackBar = SnackBar(
      content: Text('Usuário não existe ou senha inválida'),
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
    //Para saber as dimensões da tela atual
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Passo a key que vai chamar os snakcs
      key: _scaffoldKey,
      body: SingleChildScrollView(//permite "scrollar"
        child: Stack(
          children: [
            //todo fundo branco da tela
            Container(
              color: Colors.white,
              height: size.height,
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                  if (model.isLoading == true) {
                    return Center(
                      child: CircularProgressIndicator(//Circulo no centro da tela-- representa que está carregando
                        backgroundColor: Colors.black,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),//Cor laranja que roda dentro do circulo
                      ),
                    );
                  }

                  //Caso o model.isLoading != true
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
                              keyboardType: TextInputType.text,
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
                                          _iconEye =
                                              FaIcon(FontAwesomeIcons.eyeSlash);
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
                            Align(
                                alignment: Alignment.topCenter,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordScreen()));
                                  },
                                  child: Text(
                                    'Esqueceu sua senha?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  highlightColor: Colors.orange,
                                )),
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
                                        'Entrar',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                    onPressed: () {
                                      //Verifica-se o estado dos validadores
                                      if (_formKey.currentState.validate()) {
                                        UserModel.of(context).signIn(
                                            email: _emailController.text,
                                            password: _passwordController.text,
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
                                    'Não tem uma conta?',
                                    style: TextStyle(
                                        color: Color(0xFFD9611E),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            //Como queremos que a parte laranjada fique no top, o widget precisa ser inserido depois
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
                      'Login',
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
