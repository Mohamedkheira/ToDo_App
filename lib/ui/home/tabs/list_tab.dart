import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/task_collection.dart';
import 'package:todo/ui/AuthProvider.dart';
import 'package:todo/ui/home/widget/todowidget.dart';

class ListTab extends StatelessWidget {
  const ListTab({super.key});

  @override
  Widget build(BuildContext context) {
    AuthUserProvider provider = Provider.of<AuthUserProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 78,horizontal: 27),
      child: FutureBuilder(
          future: TaskCollection.getTask(provider.firebaseUser!.uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            List<Task> tasks = snapshot.data??[];
            return ListView.separated(itemBuilder: (context, index) => ToDoWidget(tasks: tasks[index]),
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20,
                  );
                },
                itemCount: tasks.length);
          },),
    );
  }
}
