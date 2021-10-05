import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greatplaces/datenBank/db_helper.dart';
import 'package:greatplaces/provider/greatplaces.dart';
import 'package:greatplaces/screen/add_places_screen.dart';
import 'package:greatplaces/screen/place_detail_screen.dart';
import 'package:greatplaces/task/add.dart';
import 'package:greatplaces/task/db_task.dart';
import 'package:greatplaces/task/task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sqflite/sqflite.dart';

class PlacesListScreen extends StatefulWidget {
  PlacesListScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat("dd. MMM yyyy");
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(children: [
        ListTile(
          title: Text(
            task.title,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                decoration: task.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough),
          ),
          subtitle: Text(
            "${_dateFormatter.format(task.date)}   ${task.priority}",
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: task.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough),
          ),
          trailing: Checkbox(
            onChanged: (value) {
              task.status = value ? 1 : 0;
              DatabaseHelper.instance.updateTask(task);
              _updateTaskList();
            },
            activeColor: Colors.green,
            value: task.status == 1 ? true : false,
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList,
                        task: task,
                      ))),
        ),
        Divider(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList,
                      )))
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlacesScreen.routeName);
              },
              icon: Icon(Icons.add_a_photo))
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: FutureBuilder(
                future: Future.wait([
                  Provider.of<GreatPlaces>(context, listen: false)
                      .fetchAndSetPlaces(),
                ]),
                builder: (ctx, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      )
                    : Consumer<GreatPlaces>(
                        child: Center(
                          child: const Text("Warte auf Texte"),
                        ),
                        builder: (context, greatPlaces, ch) => greatPlaces
                                    .items.length <=
                                0
                            ? ch
                            : ListView.builder(
                                itemCount: greatPlaces.items.length,
                                itemBuilder: (context, index) =>
                                    Column(children: [
                                      Row(children: [
                                        Container(height: 30,
                                          child: SingleChildScrollView(
                                            child: Text(greatPlaces
                                                .items[index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                        Expanded(
                                            child: Align(
                                                alignment: Alignment.topRight,
                                                child: IconButton(
                                                    icon:
                                                        Icon(Icons.fingerprint),
                                                    onPressed: () async {
                                                      return showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Löschen ?'),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                      'Möchtest du das Bild löschen?'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text(
                                                                    'Nicht löschen'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    'Löschen'),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    DBHelper.deletePlaces(
                                                                        greatPlaces
                                                                            .items[index]
                                                                            .id);
                                                                  });

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    })))
                                      ]),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              Details.routeName,
                                              arguments:
                                                  greatPlaces.items[index].id);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 8,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          height: 300,
                                          width: double.infinity,
                                          child: Image(
                                              image: FileImage(
                                                greatPlaces.items[index].image,
                                              ),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            child: Text(greatPlaces
                                                .items[index].describtion, style: TextStyle(fontSize: 20,))),
                                      ),
                                    ]))),
              ),
            ),
            Container(
              child: FutureBuilder(
                  future: _taskList,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final int completedTaskCount = snapshot.data
                        .where((Task task) => task.status == 1)
                        .toList()
                        .length;

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      itemCount: 1 + snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Aufgabe des Praktikanten",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "$completedTaskCount of ${snapshot.data.length}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildTask(snapshot.data[index - 1]);
                      },
                    );
                  }),
            ),
            Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: Colors.lightGreen,
              inactiveColor: Colors.grey,
              title: Text('Add Picture'),
              icon: Icon(Icons.add_a_photo)),
          BottomNavyBarItem(
              activeColor: Colors.lightGreen,
              inactiveColor: Colors.grey,
              title: Text('Add Tasks'),
              icon: Icon(Icons.document_scanner)
          ),
        ],
      ),
    );
  }

}
