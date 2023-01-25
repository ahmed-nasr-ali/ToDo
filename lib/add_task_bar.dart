// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, unused_field, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

import 'package:flutter_to_do_app/Services/Themes_services.dart';
import 'package:flutter_to_do_app/UI/Theme.dart';
import 'package:flutter_to_do_app/UI/widgets/button.dart';
import 'package:flutter_to_do_app/UI/widgets/input_filed.dart';
import 'package:flutter_to_do_app/controller/task_controller.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'controller/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(
      TaskController()); //do (sqlite في TaskControllerعشان اقدر استخدم )
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedData = DateTime.now(); //do (dataبتاعTextfiled هتستخدمه في )
  String _startTime = DateFormat('hh:mm a')
      .format(DateTime.now())
      .toString(); //do (AM or PM  للتاريخ علي هيأت سعات دقايق formatانت هنا بتعمل )
  String _endTime = '12:00 PM';
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeated = 'None';
  List<String> repatedList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputFiled(
                title: 'Title',
                hint: 'Enter your Title',
                controller: _titleController,
              ),
              MyInputFiled(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              MyInputFiled(
                title: 'Data',
                hint: DateFormat.yMd().format(_selectedData),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  onPressed: () {
                    _getDataFromUser(); //to show calender
                  },
                ),
              ), //do (String بحيب  التاريخ بتاع النهرداوبرجعهعلي هيأت hint الجزء بتاع ال )
              Row(
                children: [
                  Expanded(
                    child: MyInputFiled(
                      title: 'Start Data',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartime: true);
                        },
                        icon:
                            Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputFiled(
                      title: 'End Data',
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartime: false);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
              MyInputFiled(
                title: "Remind",
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                    //do (DropdownButtonانا شم فاهم اي حاجه في )
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newvalue) {
                      setState(() {
                        _selectedRemind = int.parse(newvalue!);
                      });
                    },
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList()),
              ),
              MyInputFiled(
                title: "Repeated",
                hint: _selectedRepeated,
                widget: DropdownButton(
                    //do (DropdownButtonانا شم فاهم اي حاجه في )
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newvalue) {
                      setState(() {
                        _selectedRepeated = newvalue!;
                      });
                    },
                    items: repatedList
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList()),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(label: 'AddTask', onTap: () => _validateData())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add to data base
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fileds are required !',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: Icon(Icons.warning_amber_rounded),
      );
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        data: DateFormat.yMd().format(_selectedData),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeated,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print('My id is' + '$value');
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'color',
          style: titleStyle,
        ),
        Wrap(
          //do (widget in one lineبيخلي كل ال)
          children: List<Widget>.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme
          .backgroundColor, //do he will get backgroundcolor from class Theme

      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
            'Assets/images/unnamed.webp',
          ),
        ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }

  //to do calnder
  _getDataFromUser() async {
    //to do calendar
    DateTime? _pickerData = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2017),
      lastDate: DateTime(2050),
    );
    if (_pickerData != null) {
      setState(() {
        _selectedData =
            _pickerData; //do (عشان لو المستخدم اختار اي يوم  وضغط اوكي هو دا يبقا التاريخ بتعنا )
      });
    } else {
      print('its null or something wrong');
    }
  }

//do (calnderعشان نظهرالوقت زي )
  _getTimeFromUser({required bool isStartime}) async {
    var _pickTime = await _showTimePicker();
    String formatedTime = _pickTime?.format(context) ??
        _startTime; //do (String لي _pickTimeهنا حولنا String  لازم يكون _pickTimeالي هيظهر من )
    //do (_pickTime  عشانكدا حولنا Stringعشان تظهر اي حاجه علي الشاشه لازم تكون )
    if (_pickTime == null) {
    } else if (isStartime == true) {
      setState(() {
        _startTime =
            formatedTime; //do ( _startTime في formatedTimeهيخزن Start Data icon يعني لو ضغط  )
      });
    } else if (isStartime == false) {
      setState(() {
        _endTime =
            formatedTime; //do ( _endTime في formatedTimeهيخزن End Data icon يعني لو ضغط  )
      });
    }
  }

//this method do (عشان نظهر الوقت_getTimeFromUserبنستخدمهاا في )
  Future<TimeOfDay?> _showTimePicker() {
    //do (calnder بتظهرالوفت زي ال )
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        //do (dynamic based on _startTime هنخلي الساعتو لدقايق )
        //_startTime return --> 10:30 PM
        //hour take integer so we transfer _startTime to int
        //minute take integer so we transfer _startTime to int
        hour: int.parse(_startTime.split(':')[
            0]), //do spilte depend on : and take frist index ,[0]mean dristindex , [1]mean second index
        //_startTime return --> 10:30 PM
        minute: int.parse(_startTime.split(':')[1].split(' ')[0]),
      ),
    );
  }
}
