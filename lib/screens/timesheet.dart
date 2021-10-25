import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/maps.dart';
import 'package:flutter_login_regis_provider/domain/times.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'package:flutter_login_regis_provider/screens/drawer.dart';
import 'first_timesheets/first_timesheets.dart';
import 'pending.dart';
import 'the_timesheet/third_timesheet.dart';
import 'package:flutter_login_regis_provider/utility/shared_preference.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';


class Timesheets extends StatefulWidget {
  final int ini;
  final int id;
  Timesheets([this.ini, this.id]);
  @override
  State<Timesheets> createState() => _TimesheetsState();
}

class _TimesheetsState extends State<Timesheets> with TickerProviderStateMixin {

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length:3, vsync: this,initialIndex: widget.ini?? 1, );// initialise it here
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  final List<Tab> theTabs = <Tab>[
    Tab(text: "Time sheets" ,icon: Icon(Icons.group_outlined)),
    Tab(text: "Timesheet",icon: Icon(Icons.watch_later_outlined )),
    Tab(text: "Pending attendance",icon: Icon(Icons.pending_actions_outlined)),
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: theTabs,
          ),
          title: const Text('µTiomes'),
        ),
        body:   TabBarView(
          controller: _tabController,
          children: [
            //AddAttendance(),
            FirstTimesheets(),
            Timesheet(widget.id),
            Pending(),
          ],
        ),
        drawer: TheDrawer(),
      ),
    );
  }
}

class AddAttendance extends StatefulWidget {

  @override
  State<AddAttendance> createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child:
      ElevatedButton(
        onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog();
          },
        );

        }, child: Text('Add Attendance'),

      ),),
    );
  }
}

class MyDialog extends StatefulWidget {

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final myController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  int _wilaya = 1;
  void _updateWilaya(int wilaya) {
    setState(() => _wilaya = wilaya);
  }

  int _status=0;
  void _updateStatus(int status) {
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    DateTime date = DateTime.now();
    String at_date = date.year.toString()+'-'+date.month.toString()+'-'+date.day.toString();
    Map data = {
      'attendance_date': at_date,
      'status': _status,
      'description': myController.text,
      'state': _wilaya,
    };
    String body = json.encode(data);
    return AlertDialog(
      title: const Text('Add Attendance'),
      content: SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WilayaDD(_updateWilaya),
            SizedBox(height: 20,),
            StatusDD(_updateStatus),
            SizedBox(height: 20,),
            TextField(
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),),
            SizedBox(height: 20,),


          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () async {
            print(body);
            print('-------------------------------------------');
            Response response = await http.post(Uri.parse('http://bts-algeria.com/API/api/timesheet/create'), body: body,
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});
                if (response.statusCode==200){
                  print(response.body);
                  Navigator.of(context).pop();
                }
                else{
                  print(response.body);
                  print ('---------------/---------------/------------');
                }

          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

