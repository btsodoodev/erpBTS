import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../timesheet.dart';

class approver extends StatefulWidget {
  final int id;
  final String name;
  final String date;
  final int userId;
  approver( this.id, this.name, this.date,this.userId );

  @override
  _approverState createState() => _approverState();
}

class _approverState extends State<approver> {
  Future<Map> futureApp;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return AlertDialog(
        title: const Text('Approve!'),
      content:  Text('Are you sure that you want to approve for '+widget.name+" the activity on "+widget.date+"?"),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final response = await http
                .post(Uri.parse('https://bts-algeria.com/API/api/timesheet/approve/'+widget.id.toString()),
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});

            print("--------------------");

            if (response.statusCode == 200) {
              print('succccc');
              Fluttertoast.showToast(
                  msg: "Attendance approved successfully,",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Timesheets(1, widget.userId)));

            } else {
              print('fuuuc');
              print(response.body);
              print ('---------------/---------------/------------');
              Fluttertoast.showToast(
                  msg: "error!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
          child: const Text('Approve'),
        ),
        ElevatedButton(
          onPressed: ()  {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),


      ],
    );
  }
}
class disapprover extends StatefulWidget {
  final int id;
  final String name;
  final String date;
  final int userId;
  disapprover( this.id, this.name, this.date,this.userId );

  @override
  _disapproverState createState() => _disapproverState();
}

class _disapproverState extends State<disapprover> {
  Future<Map> futureApp;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return AlertDialog(
      title: const Text('Disapprove!'),
      content:  Text('Are you sure that you want to disapprove for '+widget.name+" the activity on "+widget.date+"?"),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final response = await http
                .post(Uri.parse('https://bts-algeria.com/API/api/timesheet/disapprove/'+widget.id.toString()),
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});

            print("--------------------");

            if (response.statusCode == 200) {
              print('succccc');
              Fluttertoast.showToast(
                  msg: "Attendance disapproved successfully,",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Timesheets(1, widget.userId)));

            } else {
              print('fuuuc');
              print(response.body);
              print ('---------------/---------------/------------');
              Fluttertoast.showToast(
                  msg: "error!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
          child: const Text('Disapprove'),
        ),
        ElevatedButton(
          onPressed: ()  {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),


      ],
    );
  }
}
class rejecter extends StatefulWidget {
  final int id;
  final String name;
  final String date;
  final int userId;
  rejecter( this.id, this.name, this.date,this.userId );

  @override
  _rejecterState createState() => _rejecterState();
}

class _rejecterState extends State<rejecter> {
  Future<Map> futureApp;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return AlertDialog(
      title: const Text('Reject!'),
      content:  Text('Are you sure that you want to reject for '+widget.name+" the activity on "+widget.date+"?"),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final response = await http
                .post(Uri.parse('https://bts-algeria.com/API/api/timesheet/reject/'+widget.id.toString()),
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});

            print("--------------------");

            if (response.statusCode == 200) {
              print('succccc');
              Fluttertoast.showToast(
                  msg: "Attendance rejected successfully,",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Timesheets(1, widget.userId)));

            } else {
              print('fuuuc');
              print(response.body);
              print ('---------------/---------------/------------');
              Fluttertoast.showToast(
                  msg: "error!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
          child: const Text('Reject'),
        ),
        ElevatedButton(
          onPressed: ()  {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),


      ],
    );
  }
}
