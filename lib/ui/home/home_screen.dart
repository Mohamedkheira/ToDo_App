import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/home/tabs/list_tab.dart';
import 'package:todo/ui/home/tabs/settings_tab.dart';
import 'package:todo/ui/home/widget/addTaskSheet.dart';
import 'package:todo/ui/sign_in/login_screen.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName ='Home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    ListTab(),
    SettingsTab(),
  ];
    int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("ToDo List"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route)=>false);
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddTaskBottomSheet();
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        notchMargin: 10,
        elevation: 0,
        shape: CircularNotchedRectangle(),
        child:
        BottomNavigationBar(
          currentIndex: index,
          onTap: (newIndex){
            setState(() {

            index = newIndex;
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: [
        BottomNavigationBarItem(
        icon: Icon(Icons.menu_rounded),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: "",
      ),
      ],),

      ),
      body: tabs[index],
    );
  }


  void showAddTaskBottomSheet(){
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (context) => AddTaskSheet(),
    );
  }
}
