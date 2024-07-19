import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class completed_tasks extends StatefulWidget{
  final List<Map<String, dynamic>> task_list;
  const completed_tasks(this.task_list, {super.key});
  @override
  State<completed_tasks> createState() => _completed_tasksState();
}

class _completed_tasksState extends State<completed_tasks> {
  static const String KEYNAME="tasktile2";
  bool flag1=true;
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
  bool status=false;
  var flag=true;
  var theme=const Icon(Icons.nightlight_sharp, size: 25);
  Color icolor = const Color(0xfff6f3ff);
  Color iconcolor = Colors.black;
  List<Map<String, dynamic>> completed=[];
  FixedExtentScrollController _controller=FixedExtentScrollController();


  @override
  void initState() {
    super.initState();

    completed = widget.task_list;
    _controller = FixedExtentScrollController(
      initialItem: (widget.task_list.length / 2).floor(),
    );
    loadtasks3();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                'Completed tasks',
                style: TextStyle(fontSize: 25, fontFamily: 'PostSen', color: Colors.white,letterSpacing: 1),
              ),
              const SizedBox(width: 45),
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
                child:AnimatedContainer(
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
        body:AnimatedContainer(
          duration: const Duration(seconds: 2),
          color: icolor,
          child: Column(
            children: [
              const Center(child: Details_bar()),
              const SizedBox(height: 2),
              Expanded(
                child: widget.task_list.isEmpty ?
                const Center(
                  child: Text(
                    'No Task history found',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ):
                flag1?
                ListView(

                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast),
                  itemExtent: 100,
                  children: (widget.task_list).asMap().entries.map((entry) {
                    int index = entry.key;
                    var value = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4, right: 4, left: 4),
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
                                            setState((){
                                              if(completed.isNotEmpty){
                                                (completed).removeAt(index);
                                                widget.task_list.removeAt(index);
                                              }
                                              savelist3();

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
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child:AnimatedContainer(
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
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  Text(
                                    '${value['time']}',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
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
                ):
                ListWheelScrollView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast),
                  itemExtent: 120,
                  children: (widget.task_list).asMap().entries.map((entry){
                    int index = entry.key;
                    var value = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6, right: 4, left: 4),
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
                                            setState((){
                                              if(completed.isNotEmpty) (completed).removeAt(index);
                                              savelist3();

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
                                  ),
                                ],
                              );
                            },
                          );
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
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  Text(
                                    '${value['time']}',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
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
              const SizedBox(height: 5,),
              InkWell(
                  onTap: (){
                  setState(() {
                    flag1=!flag1;
                  }
                  );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      child: Container(
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
                                  Colors.lightBlue,icolor,
                                ],
                                end: Alignment.topCenter,
                                begin: Alignment.bottomCenter,
                                stops: const [0.7,0.99]
                            )
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 40,),
                            Center(
                              child: Text('Change Appearance ',
                                style: TextStyle(
                                    fontFamily: 'Postsen',
                                    color: iconcolor,
                                    fontWeight: FontWeight.w200,


                                    fontSize: 30
                                ),

                              ),
                            ),


                          ],
                        ),


                      ),
                    ),
                  )
              )
            ],
          ),
        ),




    );
  }

  void loadtasks3() async{
    var prefs2 = await SharedPreferences.getInstance();
    String? history = prefs2.getString(KEYNAME);
    if (history != null) {
      List<dynamic> actual = json.decode(history);

      setState(() {
        completed = actual.map((task) => Map<String, dynamic>.from(task)).toList();
        widget.task_list.clear();
        widget.task_list.addAll(completed);
      });
    }
  }
  void savelist3() async{
    var prefs2=await SharedPreferences.getInstance();
    String taskvalues=json.encode(completed);
    await prefs2.setString(KEYNAME,taskvalues);
  }
}

class Details_bar extends StatelessWidget{
  const Details_bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        width: 390,
        height: 30,
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(topRight: Radius.circular(21),topLeft: Radius.circular(21))
        ),


        child: const Row(
          children: [
            SizedBox(width: 20,),
            Text('Status ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',fontSize: 14,decoration: TextDecoration.underline),),
            SizedBox(width: 60,),
            Text('Name & date ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',fontSize: 14,decoration: TextDecoration.underline)),
            SizedBox(width: 70,),
            Text('Tasktype ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',fontSize: 14,decoration: TextDecoration.underline)),


          ],
        ),
      ),
    );

  }

}