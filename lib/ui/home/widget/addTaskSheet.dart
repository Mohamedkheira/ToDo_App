import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/task_collection.dart';
import 'package:todo/style/app_style.dart';
import 'package:todo/style/dialog_utils.dart';
import 'package:todo/style/resuble_componants/CustomFormFelid.dart';
import 'package:todo/ui/AuthProvider.dart';

class AddTaskSheet extends StatefulWidget {
  AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              "Add New Task",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppStyle.TextLightColor),
            ),
            SizedBox(
              height: hight * 0.05,
            ),
            CustomFormField(
              label: 'Title',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Title Can't be Empty";
                }
                return null;
              },
              controller: titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomFormField(
              label: 'Description',
              lines: 4,
              type: TextInputType.multiline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Description Can't be Empty";
                }
                return null;
              },
              controller: descriptionController,
            ),
            const SizedBox(
              height: 10,
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
                    AddTask();
                  },
                  child: Text("Submit")),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom * 1.1,
            )
          ],
        ),
      ),
    );
  }

  AddTask() async {
    DialogUtils.showLoadingDialog(context: context);
    AuthUserProvider authProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    await TaskCollection.createTask(
        authProvider.firebaseUser!.uid,
        Task(
          title: titleController.text,
          description: descriptionController.text,
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
