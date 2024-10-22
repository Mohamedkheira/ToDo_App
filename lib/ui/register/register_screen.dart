import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/FirebaseErrorCodes.dart';
import 'package:todo/firebase/model/users.dart';
import 'package:todo/firebase/user_collection.dart';
import 'package:todo/style/dialog_utils.dart';
import 'package:todo/style/resuble_componants/CustomFormFelid.dart';
import 'package:todo/style/resuble_componants/contants_dart.dart';
import 'package:todo/ui/AuthProvider.dart';
import 'package:todo/ui/home/home_screen.dart';
import 'package:todo/firebase/model/users.dart' as MyUser;

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'Register';

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordConfirmationController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            'assets/images/background.jpg',
          ),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
        toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Create Account',
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomFormField(
                    controller: fullNameController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please Enter Your Name";
                      }
                      return null;
                    },
                    label: "Full Name",
                    type: TextInputType.name,
                  ),
                  CustomFormField(
                    controller: userNameController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please Enter Your Username";
                      }
                      return null;
                    },
                    label: "username",
                    type: TextInputType.name,
                  ),
                  CustomFormField(
                    controller: emailController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please Enter Email";
                      }
                      if(!isValetEmail(value)){
                        return 'Enter Valid Email';
                      }
                      return null;
                    },
                    label: "Email",
                    type: TextInputType.emailAddress,
                  ),
                  CustomFormField(
                    controller: passwordController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please Enter Password";
                      }
                      if(value.length<6){
                        return 'password must contain at least 6 characters';
                      }
                      return null;
                    },
                    isPassword: true,
                    label: "Password",
                  ),
                  CustomFormField(
                    controller: passwordConfirmationController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please Enter Password Confirmation";
                      }
                      if(value.length<6){
                        return 'password must contain at least 6 characters';
                      }
                      if(value != passwordController.text){
                        return "password don't match";
                      }
                      return null;
                    },
                    isPassword: true,
                    label: "Password Confirmation",
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Theme.of(context).colorScheme.primary,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       )
                     ),
                      onPressed: (){
                       CearteAccount();
                      },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create Account',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CearteAccount() async {
    AuthUserProvider provider = Provider.of<AuthUserProvider>(context,listen: false);
    // DialogUtils.showLoadingDialog(context: context);
    if(formKey.currentState?.validate()??false){
      try {
        DialogUtils.showLoadingDialog(context: context);
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        MyUser.User user = MyUser.User(
          id: credential.user?.uid,
          email: emailController.text.trim(),
          fullName: fullNameController.text,
          userName: userNameController.text,
        );
       await UserCollection.createUser(credential.user?.uid??"",user );
        provider.setUsers(credential.user!, user);
        Navigator.pop(context);
        DialogUtils.showMessageDialog(context: context, message: "Account Is Created Successful ${credential.user?.email}", onPress: (){
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route)=> false);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == weakPass) {
          Navigator.pop(context);
          DialogUtils.showMessageDialog(context: context, message: "The password provided is too weak.", onPress: (){
            Navigator.pop(context);
          });
        } else if (e.code == emailUsed) {
          Navigator.pop(context);
          DialogUtils.showMessageDialog(context: context, message: "The account already exists for that email.", onPress: (){
            Navigator.pop(context);
          });
        }
      } catch (e) {
        Navigator.pop(context);
        DialogUtils.showMessageDialog(context: context, message: "${e.toString()}", onPress: (){
          Navigator.pop(context);
        });
      }
    }
  }
}
