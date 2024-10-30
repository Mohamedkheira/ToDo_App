import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/TodoProvider.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/task_collection.dart';
import 'package:todo/style/dialog_utils.dart';
import 'package:todo/ui/AuthProvider.dart';
import 'package:todo/ui/home/widget/editeTaskSheet.dart';

class ToDoWidget extends StatefulWidget {
  Task tasks;
  ToDoWidget({super.key,required this.tasks});

  @override
  State<ToDoWidget> createState() => _ToDoWidgetState();
}

class _ToDoWidgetState extends State<ToDoWidget> {
  @override
  Widget build(BuildContext context) {
  AuthUserProvider provider = Provider.of<AuthUserProvider>(context);
    return Slidable(
      startActionPane: ActionPane(
          extentRatio: 0.5,
          motion: ScrollMotion(),
          children: [
            SlidableAction(
                onPressed: (context){
                  deleteTask();
                },
              icon: Icons.delete,
              label: 'Delete',
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            SlidableAction(
              onPressed: (context){
                Navigator.pushNamed(context, EditeTaskSheet.routeName, arguments:  widget.tasks);
              },
              icon: Icons.edit,
              label: 'Edite',
              backgroundColor: Colors.blue,
            )
          ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 27, horizontal: 17),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: widget.tasks.isDone == true ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 25,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tasks.title??'',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: widget.tasks.isDone == true ? Theme.of(context).colorScheme.tertiary :null
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.tasks.description??'',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.tasks.date?.toDate().hour??"no hour"} : ${widget.tasks.date?.toDate().minute??"no minute"}',
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.tasks.isDone == true ? Colors.transparent :null,
                  elevation:  widget.tasks.isDone == true ?0:null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                onPressed: (){
                  setState(() {

                  });
                  widget.tasks = Task(
                    title: widget.tasks.title,
                    description: widget.tasks.description,
                    date: widget.tasks.date,
                    isDone: !(widget.tasks.isDone??false),
                  );
                  TaskCollection.updateTaskFromFirebase(userId: provider.firebaseUser!.uid, task: widget.tasks);
                },
                child: widget.tasks.isDone == true ? Text('Done !',style: Theme.of(context).textTheme.displayMedium
                ) : Icon(Icons.check),),
            ],
          ),
        ),
      ),
    );
  }

  deleteTask(){
    TodoProvider todoProvider = Provider.of<TodoProvider>(context,listen: false);
    var provider = Provider.of<AuthUserProvider>(context,listen: false);
    DialogUtils.showConfirmationDialog(context: context,
        message: "Are You Sure Want to Delete",
        onPositivePress: ()async{
      Navigator.pop(context);
      // DialogUtils.showLoadingDialog(context: context);
      await TaskCollection.deleteTask(provider.firebaseUser!.uid, widget.tasks.id??"");
      // if(mounted){
      //   Navigator.pop(context);
      // }
      // todoProvider.refreshTask(provider.firebaseUser!.uid);
        },
        onNegativePress: (){
      Navigator.pop(context);
      DialogUtils.showLoadingDialog(context: context);
      Navigator.pop(context);
        });

  }
}
