import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/TodoProvider.dart';
import 'package:todo/ui/AuthProvider.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
/*    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      Provider.of<TodoProvider>(context, listen: false).refreshTask(Provider.of<AuthUserProvider>(context,listen: false).firebaseUser!.uid);
    });*/
  }


  @override
  Widget build(BuildContext context) {
      AuthUserProvider provider = Provider.of<AuthUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CachedNetworkImage(
                imageUrl: provider.databaseUser?.imageURL??"",
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 20,
                backgroundImage: imageProvider),
              placeholder: (context, url) => CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                child: SizedBox(
                  width: 15,
                    height: 15,
                    child: Center(child: CircularProgressIndicator(),)),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: Center(child: Icon(Icons.warning_amber),),
              ),
              ),
            SizedBox(
              width: 20,
            ),
            const Text("ToDo List")
          ],
        ),
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
