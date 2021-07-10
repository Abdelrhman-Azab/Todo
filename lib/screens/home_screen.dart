import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/components/components.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
            child: isOpended ? Text("Save") : Icon(Icons.add),
            onPressed: () {
              if (isOpended) {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                insertToDataBase(
                    task: titleController.text,
                    time: timeController.text,
                    date: dateController.text);
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
      body: Center(
        child: Text("Tasks"),
      ),
    );
  }
}
