// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new, unrelated_type_equality_checks, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_to_do_app/Services/Themes_services.dart';
import 'package:flutter_to_do_app/UI/Theme.dart';
import 'package:flutter_to_do_app/UI/widgets/button.dart';
import 'package:flutter_to_do_app/UI/widgets/task_title.dart';
import 'package:flutter_to_do_app/add_task_bar.dart';
import 'package:flutter_to_do_app/controller/task.dart';
import 'package:flutter_to_do_app/controller/task_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import '../Services/notifcationServices.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _taskController = Get.put(TaskController());
  DateTime _selectedData = DateTime.now();
  var notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _taskController.getTasks();
    });
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDataBar(),
            SizedBox(
              height: 10,
            ),
            _showTasks(),
          ],
        ));
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        //do (obs فيها taskListعشان Obxاستخدمت ال)
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              //  print(_taskController.taskList.length);
              Task task = _taskController.taskList[index];
              print(task.tojson());
              if (task.repeat == 'Daily') {
                //do ( بتعتنامعتمده علي التكرارلو يومي هتبقا كدا ListViewهنعرض ال)

                //  DateTime date = DateFormat.jm().parse(task.startTime.toString());//do (جبت )
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                        child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomsheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    )),
                  ),
                );
              }
              if (task.repeat == 'Weekly') {
                //TODO
                print('fuck u');

                var newDateTimeObj = new DateFormat()
                    .add_yMd()
                    .parse(task.data!)
                    .add(Duration(days: 7));

                print(newDateTimeObj);
                if (newDateTimeObj == _selectedData) {
                  print('ali');
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomsheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      )),
                    ),
                  );
                }
              }
              if (task.data == DateFormat.yMd().format(_selectedData)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                        child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomsheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    )),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _showBottomsheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyCLr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(), //do ( تحت خالص widgetهينزل ال)
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: 'Task completed',
                    onTap: () {
                      _taskController.markTaskCOmpleted(task.id!);
                      Get.back();
                    },
                    context: context,
                    clr: primaryClr,
                    iscolsed: false,
                  ),
            SizedBox(
              height: 10,
            ),
            _bottomSheetButton(
              label: 'Delete Task',
              onTap: () {
                _taskController.delet(task);
                Get.back();
              },
              context: context,
              clr: Colors.red[300]!,
              iscolsed: false,
            ),
            SizedBox(
              height: 15,
            ),
            _bottomSheetButton(
              label: 'Close',
              onTap: () {
                Get.back();
              },
              context: context,
              clr: Colors.red[300]!,
              iscolsed: true,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    required BuildContext context,
    bool iscolsed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: iscolsed == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: iscolsed == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: iscolsed
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors
                        .white), //do the same style of titlestyle but we change color
          ),
        ),
      ),
    );
  }

  _addDataBar() {
    return Container(
        margin: EdgeInsets.only(left: 8),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 65,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryClr,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          onDateChange: (data) {
            setState(() {
              _selectedData = data;
            });
          },
        ));
  }

  _addTaskBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+Add task",
              onTap: () async {
                await Get.to(AddTaskPage());
                _taskController.getTasks(); //to rebuild list of tasklist
                //do (rebuild list of tasklist كل لما هتضغط علي الزرار هيعمل )
              }),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme
          .backgroundColor, //do he will get backgroundcolor from class Theme

      leading: GestureDetector(
        onTap: () {
          ThemesServices().switchTheme();
          
          notifyHelper.displayNotification(
              title: 'Theme Changed',
              body: Get.isDarkMode
                  ? 'Activated Light mode'
                  : 'Activated Dark mode');

         // notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
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
}
