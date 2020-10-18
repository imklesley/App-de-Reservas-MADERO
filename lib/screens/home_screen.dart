import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madero_reservas/custom_widgets/custom_drawer.dart';
import 'package:madero_reservas/tabs/booking_tab.dart';
import 'package:madero_reservas/tabs/home_tab.dart';
import 'package:madero_reservas/tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //posição inicial do botão do bottomnavigator
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    //Só para colocar a tela em fullscreen
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);


    //instancia-se cada tab para só ir chamando depois
    BookingTab myBookingsTab = BookingTab();
    HomeTab homeTab = HomeTab();
    ProfileTab profileTab = ProfileTab();


    //Aqui criei uma função que irá escolher qual tela exibir baseando-se na var "_currentIndex"
    Widget _choosePage() {
      switch (_currentIndex) {
        case 0:
          return myBookingsTab;
        case 1:
          return homeTab;
        default:
          return profileTab;
      }
    }

    //Widget que permit colocar appbar,drawer ,bottomNavigation, entre outros
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          toolbarHeight: 70,
          title: Image
              .asset( // Passo o caminho da imagem e mando preencher todo espaço delimitado
            'assets/images/brand/brand.png',
            fit: BoxFit.cover,
            height: 40,
          ),
          centerTitle: true,
          //cor de fundo da appbar
          backgroundColor: Color(0xFFD9611E),
        ),
        backgroundColor: Colors.white,
        //Ao invés de utilizar o bottomnavigator padrãop do flutter, usei um plugin do pub.dev. Chamado de CircleBottomNavigation
        bottomNavigationBar: CircleBottomNavigation(
          //Passo a variável que vai representar a mudança de tela
            initialSelection: _currentIndex,
            textColor: Colors.black,
            // hasElevationShadows: true,
            barBackgroundColor: Color(0xFFD9611E),
            activeIconColor: Colors.white,
            inactiveIconColor: Colors.black,
            circleColor: Colors.black,

            //Coloca-se as informações de cada tab(Icones e bolinhas do bottom navigator)
            tabs: [
              TabData(
                  icon: Icons.list,
                  title: 'Reservas',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              TabData(
                  icon: Icons.home,
                  title: 'Início',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              TabData(
                  icon: Icons.person,
                  title: 'Perfíl',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ],
            //Na mudança de tab, é chamado uma função anônima que recebe como parâmetro
            //um int que representa a posição atual da tab
            onTabChangedListener: (index) {
              //Atualiza o estado da tela em relação a variável _currentIndex
              setState(() => _currentIndex = index);
            }

        ),

        body: _choosePage());
  }
}
