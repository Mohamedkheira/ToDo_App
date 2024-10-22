import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/FirebaseErrorCodes.dart';
import 'package:todo/firebase/user_collection.dart';
import 'package:todo/style/dialog_utils.dart';
import 'package:todo/style/resuble_componants/CustomFormFelid.dart';
import 'package:todo/style/resuble_componants/contants_dart.dart';
import 'package:todo/ui/AuthProvider.dart';
import 'package:todo/ui/home/home_screen.dart';
import 'package:todo/ui/register/register_screen.dart';
import 'package:todo/firebase/model/users.dart' as MyUser;


class LoginScreen extends StatefulWidget {
  static const String routeName = 'Login';

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

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
            'Login',
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
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Email";
                      }
                      if (!isValetEmail(value)) {
                        return 'Enter Valid Email';
                      }
                      return null;
                    },
                    label: "Email",
                    type: TextInputType.emailAddress,
                  ),
                  CustomFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Password";
                      }
                      if (value.length < 6) {
                        return 'password must contain at least 6 characters';
                      }
                      return null;
                    },
                    isPassword: true,
                    label: "Password",
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        LoginAccount();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Login',
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'or Create Account',
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: const Text(
                          'Register Name',
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LoginAccount() async {
    AuthUserProvider provider = Provider.of<AuthUserProvider>(context, listen: false);
    if(formKey.currentState?.validate()??false){
      try {
        DialogUtils.showLoadingDialog(context: context);
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
        );
       MyUser.User? user = await UserCollection.getUser(credential.user?.uid??"");
       provider.setUsers(credential.user!, user!);
       Navigator.pop(context);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } on FirebaseAuthException catch (e) {
        if (e.code == userNotFound) {
          Navigator.pop(context);
          DialogUtils.showMessageDialog(context: context, message: 'No user found for that email.', onPress: (){
            Navigator.pop(context);
          });
        } else if (e.code == passwordWrong) {
          Navigator.pop(context);
          DialogUtils.showMessageDialog(context: context, message: 'Wrong password provided for that user.', onPress: (){
            Navigator.pop(context);
          });
        }
      }
    }
  }
}
