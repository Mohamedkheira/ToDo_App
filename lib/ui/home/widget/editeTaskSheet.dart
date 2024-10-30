import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/TodoProvider.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/task_collection.dart';
import 'package:todo/style/app_style.dart';
import 'package:todo/style/dialog_utils.dart';
import 'package:todo/style/resuble_componants/CustomFormFelid.dart';
import 'package:todo/ui/AuthProvider.dart';

class EditeTaskSheet extends StatefulWidget {
  static const String routeName = 'Edite';

  EditeTaskSheet({super.key});

  @override
  State<EditeTaskSheet> createState() => _EditeTaskSheetState();
}

class _EditeTaskSheetState extends State<EditeTaskSheet> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
    DateTime selectedDate = DateTime.now();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Task task = ModalRoute.of(context)!.settings.arguments as Task;
    title.text = task.title??'';
    description.text = task.description??'';
    selectedDate = DateTime.fromMillisecondsSinceEpoch(task.date as int);
    double hight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Title Task",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppStyle.TextLightColor,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                label: "Enter title Task",
                controller: title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title Can't be Empty";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                label: "Description",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description Can't be Empty";
                  }
                  return null;
                },
                controller: description,
              ),
              SizedBox(
                height: hight*0.06,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Date",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppStyle.TextLightColor),
                ),
              ),
              InkWell(
                onTap: () {
                  ShowDateSelecte();
                },
                child: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: hight * 0.02,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      addTask();
                    },
                    child: Text("Submit")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addTask() async {
    TodoProvider provider = Provider.of<TodoProvider>(context,listen: false);
    if(formKey.currentState?.validate()??false){
      DialogUtils.showLoadingDialog(context: context);
      AuthUserProvider authProvider =
      Provider.of<AuthUserProvider>(context, listen: false);
      await TaskCollection.createTask(
          authProvider.firebaseUser!.uid,
          Task(
            title: title.text,
            description: description.text,
            date: Timestamp.fromMillisecondsSinceEpoch(
                selectedDate.millisecondsSinceEpoch),
          ));
      Navigator.pop(context);
      DialogUtils.showMessageDialog(
          context: context,
          message: "Takes Created Successfully",
          onPress: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
      provider.refreshTask(authProvider.firebaseUser!.uid);
    }
  }

  ShowDateSelecte() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }
}
