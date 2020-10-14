import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  //Firebase user, guarda o usuário quando está logado
  User user;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Dados do usuário que serão utilizado no decorrer do app
  Map<String, dynamic> userData;

  //Diz ao aplicativo quando ele deve aguardar alguma coisa ser executada no background
  bool isLoading = false;

  bool isLoggedIn() {
    return user != null;
  }

  //Uma forma faci
  // litada para acessar uma classe
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  //Sobrescrevi esse método para que ao iniciar a aplicação o app carregue o usuário atual e seus respectivos dados
  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    await _loadUser();
    notifyListeners();
  } //entrar com email e senha

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    //Avisa os listeners que o app tá carregando alguma coisa
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      //Guardo o user que o firebase retornou
      this.user = user.user;
      //Carrega user atual pro sistema
      await _loadUser();
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    //Avisa os listeners que o app tá carregando alguma coisa
    isLoading = true;
    notifyListeners();

    //Realiza tentativa de cadastro
    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: password)
        .then((user) async {
      //Guardo o user que o firebase retornou
      this.user = user.user;
      //salva os dados do usuário no firebase e localmente
      await _saveData(userData);
      //Carrega user atual pro sistema
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  //Sai do app
  void signOut() {
    //Sai da conta do usuário no firebase
    _auth.signOut();
    //reseta os campos locais que representam o estado de login do usuário
    user = null;
    userData = Map();
    //atualiza as telas
    notifyListeners();
  }

  //Recuperação de senha
  void recoverPassword({@required String email}) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> getUserData() async {
    DocumentSnapshot docUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    print(docUser.data());
    notifyListeners();
    userData = docUser.data();
  }

  //Carrega quem é o usuário logado, seja quando for feito o login ou quando o app inicializar
  Future<Null> _loadUser() async {
    notifyListeners();
    //variável user é nula?
    if (user == null) {
      //caso seja, realiza-se a tentativa de verificação se o _auth possui algum id
      user = _auth.currentUser;
    }
    //Agora verifica-se se o _auth tinha algo, caso não tenha faz a solicitação dos dados ao firebase
    if (user != null) {
      // Se não for nulo e os dados estiverem vazios, buscamos os dados no firebase
      if (userData == null || userData.isEmpty) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        print(docUser.data());
        notifyListeners();
        userData = docUser.data();
        // print('Pronto ${userData['name']} carregado!');
      }
    }
    notifyListeners();
  }

  //Salva-se os dados no firebase
  Future<Null> _saveData(Map<String, dynamic> userData) async {
    this.userData = userData;
    //Salva-se os dados no firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(userData);
    //Salvo os dados localmente

    notifyListeners();
  }

  //Finaliza e salva pedido de reserva no firebase, tanto na coleção do restaurante como na do usuário
  Future<String> endOrder(Map<String, dynamic> reservationData, String userUid,
      String restaurantUid) async {
    isLoading = true;
    notifyListeners();

    //Guarda-se os dados da reserva no firebase na coleção do usuário
    DocumentReference reservationId = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('schedule')
        .add(reservationData);

    //Guarda-se os dados da reserva no firebase na coleção do restaurante
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantUid)
        .collection('schedule')
        .doc(reservationId.id)
        .set(reservationData);

    isLoading = false;
    notifyListeners();

    return reservationId.id;
  }

  //Finaliza a edição, salva às alterações da reserva no firebase, tanto na coleção do restaurante como na do usuário
  Future<Null> updateBooking(
      Map<String, dynamic> reservationData, String bookId) async {
    isLoading = true;
    notifyListeners();

    //Guarda-se os dados da reserva no firebase na coleção do usuário
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('schedule')
        .doc(bookId)
        .update(reservationData);

    //Guarda-se os dados da reserva no firebase na coleção do restaurante
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(reservationData['restaurant_id'])
        .collection('schedule')
        .doc(bookId)
        .update(reservationData);

    isLoading = false;
    notifyListeners();
  }

  Future<Null> deleteBook(String bookId, String restaurantId) async {
    isLoading = true;
    notifyListeners();

    //Guarda-se os dados da reserva no firebase na coleção do usuário
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('schedule')
        .doc(bookId)
        .delete();

    //Guarda-se os dados da reserva no firebase na coleção do restaurante
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId)
        .collection('schedule')
        .doc(bookId)
        .delete();

    isLoading = false;
    notifyListeners();
  }
}
