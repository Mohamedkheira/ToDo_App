import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/task_collection.dart';
import 'package:todo/style/dialog_utils.dart';
import 'package:todo/ui/AuthProvider.dart';

class ToDoWidget extends StatefulWidget {
  Task tasks;
  ToDoWidget({super.key,required this.tasks});

  @override
  State<ToDoWidget> createState() => _ToDoWidgetState();
}

class _ToDoWidgetState extends State<ToDoWidget> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
          motion: BehindMotion(),
          extentRatio: 0.3,
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
                  color: Theme.of(context).colorScheme.primary,
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
                      style: Theme.of(context).textTheme.labelLarge,
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                onPressed: (){},
                child: Icon(Icons.check),),
            ],
          ),
        ),
      ),
    );
  }

  deleteTask(){
    var provider = Provider.of<AuthUserProvider>(context,listen: false);
    DialogUtils.showConfirmationDialog(context: context,
        message: "Are You Sure Want to Delete",
        onPositivePress: ()async{
      Navigator.pop(context);
      DialogUtils.showLoadingDialog(context: context);
      await TaskCollection.deleteTask(provider.firebaseUser!.uid, widget.tasks.id??"");
      Navigator.pop(context);
        },
        onNegativePress: (){
      Navigator.pop(context);
      DialogUtils.showLoadingDialog(context: context);
        });

  }
}
