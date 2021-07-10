import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/components/components.dart';
import 'package:todo/components/constants.dart';
import 'package:todo/database/database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  TextEditingController timeController = TextEditingController();

  TextEditingController titleController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  bool isOpended = false;

  @override
  void initState() {
    createDataBase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
            child: isOpended ? Text("Save") : Icon(Icons.add),
            onPressed: () async {
              if (isOpended) {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                insertToDataBase(
                        task: titleController.text,
                        time: timeController.text,
                        date: dateController.text)
                    .then((value) async {
                  await getFromDataBase(dataBase);

                  setState(() {});
                });
                Navigator.of(context).pop();
                isOpended = false;
                titleController.text = "";
                timeController.text = "";
                dateController.text = "";
              } else {
                createDataBase();
                isOpended = true;
                scaffoldKey.currentState!
                    .showBottomSheet((context) => Form(
                          key: formKey,
                          child: Container(
                            color: Colors.grey[100],
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                myTextFormField(
                                    controller: titleController,
                                    context: context,
                                    label: "Title",
                                    icon: Icons.check_box_rounded,
                                    onTap: () {},
                                    validateMessage: "you have to set a title"),
                                SizedBox(
                                  height: 15,
                                ),
                                myTextFormField(
                                    context: context,
                                    controller: timeController,
                                    icon: Icons.access_time,
                                    label: "Task Time",
                                    validateMessage: "you have to set a time",
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                myTextFormField(
                                  context: context,
                                  controller: dateController,
                                  icon: Icons.date_range,
                                  label: "Task Date",
                                  validateMessage: "you have to set a date",
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now()
                                                .add(Duration(days: 60)))
                                        .then((value) => dateController.text =
                                            DateFormat.yMMMMEEEEd()
                                                .format(value!));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  setState(() {
                    isOpended = false;
                  });
                });
              }
              setState(() {});
            }),
      ),
      appBar: AppBar(
        title: Text("Tasks App"),
      ),
      body: emptyDataBase
          ? Center(
              child: Text("You don't have any task"),
            )
          : tasks.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Text("${tasks[index]["time"]}"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${tasks[index]["task"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${tasks[index]["date"]}",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () async {
                                await deleteFromDataBase(tasks[index]["time"]);
                                await getFromDataBase(dataBase);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: tasks.length),
    );
  }
}
