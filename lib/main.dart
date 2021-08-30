import 'package:flutter/material.dart';
import 'package:todo_list/database.dart';

void main(){
  runApp(MaterialApp(
    home: Myapp(),
    debugShowCheckedModeBanner: false,
  ));
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  createDataBase  createdb = createDataBase();
  final editcontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: TextField(
                          controller: editcontrol,
                          onSubmitted: (value) async {
                            if (value!='') {
                              createDataBase dbnew = createDataBase();
                              todo newtodo = todo(task: value, checker: 0);
                              await dbnew.insertTask(newtodo);
                              editcontrol.clear();
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Task...",
                            border: InputBorder.none
                          ),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ),
                  ]
                ),
              ),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                      child : FutureBuilder(
                      initialData: [],
                      future: createdb.getTasks(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                createdb.updatetodo(todo(
                                  id: snapshot.data[index].id,
                                  task: snapshot.data[index].task,
                                  checker: snapshot.data[index].checker==0?1:0
                                ));
                                setState(() {});
                              },
                              child: toDoCheck(
                                text: snapshot.data[index].task,
                                isDone: snapshot.data[index].checker==0?false:true,
                              ),
                              onLongPress: () {
                                createdb.deletetodo(todo(id: snapshot.data[index].id));
                              },
                            );
                            }
                          ),
                        );
                      },
                    ),
                    )
                    ),
              ),
          ]
        ),
      ),
    )
    );
  }
}

class toDoCheck extends StatelessWidget {

  final String text;
  final bool isDone;
  toDoCheck({this.text,this.isDone});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isDone? Colors.deepPurpleAccent : Colors.transparent,
              border: isDone? null: Border.all(color: Colors.grey)
            ),
            child: Icon( isDone?Icons.assignment_turned_in_outlined:null,color: Colors.white,),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15
            ),
            child: Text(text,
              style: TextStyle(
                color: isDone?Colors.grey:Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child,
      AxisDirection axisDirection) {
    return child;
  }
}