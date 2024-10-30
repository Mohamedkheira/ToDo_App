import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/TodoProvider.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/task_collection.dart';
import 'package:todo/ui/AuthProvider.dart';
import 'package:todo/ui/home/widget/todowidget.dart';

class ListTab extends StatefulWidget {
  ListTab({super.key});

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  DateTime selectDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    // TodoProvider provider = Provider.of<TodoProvider>(context);
    AuthUserProvider userProvider = Provider.of<AuthUserProvider>(context);
   /* if(provider.isTasksLoading){
      return Center(child: CircularProgressIndicator(),);
    }else if(provider.tasksError.isNotEmpty){
      return Center(child: Text(provider.tasksError),);
    }if(provider.tasksList.isEmpty){
      return Center(child: Text('No Tasks Yet'),);
    }*/
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.1,
              color: Theme.of(context).colorScheme.primary,
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now(),
                focusDate: selectDate,
                lastDate: DateTime.now().add(Duration(days: 365)),
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    monthStrStyle: TextStyle(color: Colors.transparent)
                  ),
                  activeDayStyle: DayStyle(
                    borderRadius: 0,
                      monthStrStyle: TextStyle(color: Colors.transparent)
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: Colors.white,

                    ),
                      monthStrStyle: TextStyle(color: Colors.transparent)

                  )
                ),
                onDateChange: (newSelectedDate) {
                  setState(() {
                  selectDate = DateTime(
                      newSelectedDate.year,
                    newSelectedDate.month,
                    newSelectedDate.day,
                  );
                  print(selectDate.toString());
                  });
                },
              ),
            ),
          ],
        ),
        Expanded(
          flex: 4,
          child: StreamBuilder(
              stream: TaskCollection.getTaskListen(userProvider.firebaseUser!.uid,selectDate),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasError){
                  return Center(child: Text(snapshot.error!.toString()));
                }
                List<Task> tasks = snapshot.data??[];
                if(tasks.isEmpty){
                  return Center(
                    child: Text("No Tasks Yet",
                    style: Theme.of(context).textTheme.labelLarge,
                    ),
                  );
                }else{
                  return  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.separated(itemBuilder: (context, index) => ToDoWidget(tasks: tasks[index]),
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                          itemCount: tasks.length)
                  );
                }

              }
              ,),
        ),
      ],
    );

  }
}