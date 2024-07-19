import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TaskMate/completedtasks.dart';
import 'package:TaskMate/taskmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskSplasher(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String KEYNAME2="tasktile2";
  static const String KEYNAME="tasktile";
  bool status=false;
  String? taskname = 'Select task type';
  String? hint = 'Enter task name';
  Icon theme = const Icon(Icons.nightlight_sharp, size: 25);
  Color icolor = const Color(0xfff6f3ff);
  Color iconcolor = Colors.black;
  bool flag = true;
  TextEditingController task = TextEditingController();

  var date;
  var Time;
  var tasktype = 'Select task type';
  var taskicon = {
    'sports': const Icon(Icons.sports_cricket, size: 45, color: CupertinoColors.systemYellow,shadows: [
      Shadow(
          color: Colors.black,
          blurRadius: 20
      )
    ],),
    'work': const Icon(Icons.work, size: 45, color: CupertinoColors.systemRed,shadows: [
      Shadow(
          color: Colors.black,
          blurRadius: 20
      )
    ]),
    'shopping': const Icon(Icons.shopping_bag, size: 45, color: Colors.white,shadows: [
      Shadow(
          color: Colors.black,
          blurRadius: 20
      )
    ]),
    'Household': const Icon(Icons.home, size: 45, color: Colors.orange,shadows: [
      Shadow(
          color: Colors.black,
          blurRadius: 20
      )
    ]),
    'personal': Icon(Icons.person, size: 45, color: Colors.green.shade500,shadows: const [
      Shadow(
          color: Colors.black,
          blurRadius: 20
      )
    ]),
  };
  var type = ['sports', 'work', 'shopping', 'Household', 'personal'];
  List<Map<String, dynamic>> todolist = [];
  List<Map<String, dynamic>> Completed_tasks=[];




  @override
  void initState(){

    super.initState();
    loadtasks();
    loadtasks2();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'TaskMate',
              style: TextStyle(fontSize: 25, fontFamily: 'Playwrite', color: Colors.white,fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 180),
            InkWell(
              onTap: () {

                setState(() {
                  if (flag) {
                    theme = const Icon(Icons.light_mode, size: 25);

                    icolor = Colors.black;
                    iconcolor = Colors.white;
                    flag = false;
                  } else {

                    theme = const Icon(Icons.nightlight_sharp, size: 25);
                    icolor = const Color(0xfff6f3ff);
                    iconcolor = Colors.black;

                    flag = true;
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0.05,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: icolor,
                  radius: 23,
                  foregroundColor: iconcolor,
                  child: theme,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent.shade400,
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        color: icolor,

        child: Padding(
          padding: const EdgeInsets.all(19),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 2),

                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(color: iconcolor, spreadRadius: 0.3, blurRadius: 15),
                    ],
                    gradient: LinearGradient(
                      colors: [iconcolor, icolor],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                      stops: const [0.7, 0.99],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            const SizedBox(width: 35),
                            Text(
                              'YOUR TASKS',
                              style: TextStyle(
                                color: icolor,
                                fontSize: 39,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Postsen',
                              ),
                            ),
                            const SizedBox(width: 30),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white.withOpacity(0.9),
                                          icon: const Icon(Icons.add_task_sharp, size: 50),
                                          iconColor: Colors.green,
                                          title: const Text(
                                            'Task details',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Ubuntu',
                                              fontSize: 30,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Name:  ',
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: TextField(
                                                    controller: task,
                                                    decoration: InputDecoration(
                                                      hintText: hint,
                                                      hintStyle: const TextStyle(color: Colors.black54),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Type:   ',
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: DropdownButton<String>(
                                                    hint: Text('Task Category'),

                                                    dropdownColor: Colors.grey,
                                                    value: tasktype == 'Select task type' ? null : tasktype,
                                                    isExpanded: true,

                                                    onChanged: (String? newValue) {
                                                      if (newValue != null) {
                                                        setState(() {
                                                          tasktype = newValue;
                                                          taskname = newValue;

                                                        });
                                                      }
                                                    },
                                                    items: type.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Center(
                                              child: TextButton(
                                                onPressed: () async {

                                                  setState(() {
                                                    hint = 'Enter task name';
                                                    var time = DateTime.now();
                                                    var itime = DateFormat('hh').format(time);
                                                    var imin=DateFormat('mm').format(time);
                                                    var amPm = DateFormat('a').format(time);
                                                    date = '${time.day}/${time.month}/${time.year}';
                                                    Time = '$itime:$imin $amPm';
                                                    var element = {
                                                      'taskname': task.text.toString(),
                                                      'date': date,
                                                      'time': Time,
                                                      'type': tasktype,
                                                      'task_status': 'black'
                                                    };

                                                    todolist.add(element);
                                                    tasktype = 'Select task type';
                                                  });

                                                    savelist();


                                                  Navigator.pop(context);


                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 2),
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(21),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black,
                                                        spreadRadius: 0.05,
                                                        blurRadius: 20,
                                                      )
                                                    ],
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'ADD',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 25,
                                                        fontFamily: 'Ubuntu',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            ,

                                          ],


                                        );
                                      }
                                  );

                                },
                                child: CircleAvatar(foregroundColor: iconcolor,backgroundColor: icolor,radius: 23,child: const Icon(Icons.add,weight: 50,size: 42,),))
                          ],
                        ),

                      ],
                    ),
                  ),

                ),
                const Details_bar(),
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  height: 514,
                  child: todolist.isEmpty
                      ? const Center(
                    child: Text(
                      'Wooho! no task remaining today',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                      : ListView(
                    physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                    itemExtent: 90,
                    children: todolist.asMap().entries.map((entry) {
                      int index = entry.key;
                      var value = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(left: 1, right: 1, bottom: 1, top: 0),
                        child: InkWell(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Remove the Task?'),
                                    actions: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const FaIcon(
                                                FontAwesomeIcons.timesCircle,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: () async{
                                                setState(() {
                                                  todolist.removeAt(index);
                                                  if (value['task_status'] == 'green') {
                                                    var currtime =
                                                        '${DateFormat('hh').format(DateTime.now())}:${DateFormat('mm').format(DateTime.now())} ${DateFormat('a').format(DateTime.now())}';
                                                    value['time'] = currtime;
                                                    Completed_tasks.add(value);
                                                  }
                                                  savelist2();
                                                  savelist();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Icon(
                                                Icons.check_circle_outline_outlined,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            child: Card(
                              color: Colors.red.shade300,
                              child: ListTile(
                                leading: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (!status) {
                                          value['task_status'] ='green';
                                          status = true;
                                        } else {
                                          value['task_status'] = 'black';
                                          status = false;
                                        }
                                      });
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.checkCircle,
                                      size: 40,
                                      color: value['task_status']=='black'?Colors.black:Colors.green,
                                    )),
                                title: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    '${value['taskname']}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${value['date']}  ',
                                      style: const TextStyle(fontSize: 15, color: Colors.white),
                                    ),
                                    Text(
                                      '${value['time']}',
                                      style: const TextStyle(fontSize: 15, color: Colors.white),
                                    ),
                                  ],
                                ),
                                trailing: taskicon[value['type']],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 15,),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => completed_tasks(Completed_tasks),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );

                          },
                          transitionDuration: const Duration(milliseconds: 820),
                        ),
                      );
                    },
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        boxShadow: [
                          BoxShadow(
                              color: iconcolor,
                              spreadRadius: 0.3,
                              blurRadius: 15
                          )
                        ],
                        gradient: LinearGradient(
                            colors: [
                              Colors.deepPurpleAccent.shade400,icolor,
                            ],
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            stops: const [0.7,0.99]
                        )
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: Text('     Tasks Completed ',
                            style: TextStyle(
                                fontFamily: 'Postsen',
                                color: Colors.white,


                                fontSize: 30
                            ),

                          ),
                        ),
                        const SizedBox(width: 12,),
                        Icon(Icons.navigate_next_rounded,size: 40,color: iconcolor,)
                      ],
                    ),


                  ),
                ),

              ],

            ),
          ),
        ),
      ),
    );


  }

  void loadtasks() async{
    var prefs = await SharedPreferences.getInstance();
    String? history = prefs.getString(KEYNAME);
    if (history != null) {
      List<dynamic> actual = json.decode(history);
      todolist = actual.map((task) => Map<String, dynamic>.from(task)).toList();
      setState(() {

      });
    }
  }
  void loadtasks2() async{
    var prefs2 = await SharedPreferences.getInstance();
    String? history = prefs2.getString(KEYNAME2);
    if (history != null) {
      List<dynamic> actual = json.decode(history);
      Completed_tasks = actual.map((task) => Map<String, dynamic>.from(task)).toList();
      setState(() {

      });
    }
  }
  void savelist2() async{
    var prefs2=await SharedPreferences.getInstance();
    String taskvalues=json.encode(Completed_tasks);
    prefs2.setString(KEYNAME2,taskvalues);
  }
  void savelist() async{
    var prefs=await SharedPreferences.getInstance();
    String taskvalues=json.encode(todolist);
    prefs.setString(KEYNAME,taskvalues);
  }


}


class Details_bar extends StatelessWidget{
  const Details_bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4,right: 4,top: 8),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        width: 360,
        height: 30,
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(topRight: Radius.circular(21),topLeft: Radius.circular(21))
        ),


        child: const Row(
          children: [
            SizedBox(width: 20,),
            Text('Status ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',fontSize: 14,decoration: TextDecoration.underline),),
            SizedBox(width: 50,),
            Text('Name & date ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',fontSize: 14,decoration: TextDecoration.underline)),
            SizedBox(width: 50,),
            Text('Tasktype ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',fontSize: 14,decoration: TextDecoration.underline)),


          ],
        ),
      ),
    );

  }

}