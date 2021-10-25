import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/maps.dart';
import 'package:flutter_login_regis_provider/domain/times.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../timesheet.dart';
import 'buttons.dart';
import 'signDialog.dart';


Future<Times> fetchTimes(String token, int uid) async {
  var date =  DateTime.now();
  final response = await http
      .get(Uri.parse('https://bts-algeria.com/API/api/timesheet/u/'+uid.toString()+'/'+date.year.toString()+'/'+date.month.toString()),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer '+token,
    },);
  print(token);
  print("--------------------");
  if (response.statusCode == 200) {
    print(response.body);

    return Times.fromJson(jsonDecode(response.body));
  } else {

    throw Exception('Failed to load album');
  }
}
Widget statusColored(int status){
  if(status == 6){
    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(statuses[status],style: TextStyle(color: Colors.white),),
      ),
    );
  }
  if(status == 7){
    return Container(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(statuses[status],style: TextStyle(color: Colors.white),),
      ),
    );
  }
  if(status == 8){
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(statuses[status],style: TextStyle(color: Colors.white),),
      ),
    );
  }
  if(status == 9){
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(statuses[status],style: TextStyle(color: Colors.white),),
      ),
    );
  }
  else{
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(statuses[status],style: TextStyle(color: Colors.white),),
      ),
    );
  }
}


class Timesheet extends StatefulWidget {
   int id;
  Timesheet([this.id]);
  @override
  State<Timesheet> createState() => _TimesheetState();
}

class _TimesheetState extends State<Timesheet> {
  Future<Times> futureTimes;
  User _user = new User();

  @override
  void dispose() {
 
      widget.id = null;

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<UserProvider>(context).user;
    if (widget.id!=null){
      futureTimes = fetchTimes(_user.resp.accessToken, widget.id);
    }else futureTimes = fetchTimes(_user.resp.accessToken, _user.user.first.id);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<Times>(
        future: futureTimes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TimesTable(snapshot.data,);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return Center(child: const CircularProgressIndicator());
        },
      ),

    );
  }
}

class TimesTable extends StatefulWidget {
  Times times;
  TimesTable(this.times);

  @override
  State<TimesTable> createState() => _TimesTableState();
}

class _TimesTableState extends State<TimesTable> {

  void _updateUpdate(int id, String date, int state, int status, String desc){
    for (Attendance at in widget.times.attendances){
      if (at.id== id){
        setState(() {
          at.date = date;
          at.workStatusId = status.toString();
          at.stateId = state.toString();
          at.description = desc;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    DateTime now = new DateTime.now();
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 20,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              '#',
            ),
          ),
          DataColumn(
            label: Text(
              'Full name',
            ),
          ),
          DataColumn(
            label: Text(
              'State',
            ),
          ),
          DataColumn(
            label: Text(
              'Date',
            ),
          ),
          DataColumn(
            label: Text(
              'Remark',
            ),
          ),
          DataColumn(
            label: Text(
              'Work status',
            ),
          ),
          DataColumn(
            label: Text(
              'Status',
            ),
          ),
          DataColumn(
            label: Text(
              'Actions',
            ),
          ),

        ],
        rows:  <DataRow>[
         for (Attendance at in widget.times.attendances)
            DataRow(
              cells: <DataCell>[
                DataCell(Container(width: 20,child: Text(widget.times.attendances.indexOf(at).toString() ))),
                DataCell(Text(widget.times.timesUser.name?? 'no description')),
                DataCell(Text(states[int.parse(at.stateId?? "0")])),
                DataCell(Text(at.date?? 'no description')),
                DataCell(Text(at.description?? '-')),
                DataCell(Text(work_statuses[int.parse(at.workStatusId??'69')])),
                DataCell(statusColored(int.parse(at.statusId ?? '0'))),
                DataCell(
                    Row(children: [
                     // if(at.statusId!=null)Text(at.statusId+"***"+  at.date+"***"+at.userId+"***"+user.user.first.id.toString()),
                        if((at.statusId=="9" || at.statusId=="8" ) && at.userId==user.user.first.id.toString())
                          ElevatedButton(
                            onPressed: () {
                            showDialog(
                           context: context,
                           builder: (BuildContext context) {
                            return UpdateDialog(widget.times.timesUser.id, at.date,_updateUpdate, at.id);},);
                           }, child: Text('Update')),
                        //&&  DateTime.parse(at.date).isBefore(now)
                      if(at.statusId=="7" &&  DateTime.parse(at.date).isBefore(now) && at.userId==user.user.first.id.toString() )
                        ElevatedButton(  onPressed: () {
                          print(at.date);
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return SignDialog( at.date, );
                        //   },
                        // );
                          },child: Text('Sign')),
                      if((at.statusId=="9" || at.statusId=="8" ||  at.statusId=="6" ) && at.userId!=user.user.first.id.toString())
                        Row(
                          children: [
                        if(at.statusId!="6")ElevatedButton( style:ElevatedButton.styleFrom(primary:Colors.green,   ),
                                onPressed: () {
                              print(at.date);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return approver(  at.id ,widget.times.timesUser.name, at.date, int.parse(at.userId),);
                                },
                              );
                            },child: Text('Approve')),
                            if(at.statusId=="6")ElevatedButton( style:ElevatedButton.styleFrom(primary:Colors.orange,   ),
                                onPressed: () {
                                  print(at.date);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return disapprover(  at.id ,widget.times.timesUser.name, at.date, int.parse(at.userId),);
                                    },
                                  );
                                },child: Text('Disapprove')),
                            SizedBox(width: 10,),
                            if(at.statusId!="8")ElevatedButton( style:ElevatedButton.styleFrom(primary:Colors.red,   ),
                                onPressed: () {
                              print(at.date);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return rejecter(  at.id ,widget.times.timesUser.name, at.date, int.parse(at.userId),);
                                },
                              );
                            },child: Text('Reject')),
                          ],
                        ),

                      //if(at.statusId=="6")  Text('Approved', style: TextStyle(color: Colors.white,backgroundColor: Colors.red),),
                     // if(at.statusId=="66") approver(user.resp.accessToken, at.id),
                      //if(at.statusId=="66")disapprover(user.resp.accessToken, at.id),
                      //if(at.statusId=="66") rejecter(user.resp.accessToken, at.id),

                ],)),
              ],
            ),
        ],
      ),
    );
  }
}
class UpdateDialog extends StatefulWidget {
  final int u_id;
  final String row_date;
  final int row_id;
  final  Function updateUpdate;
  UpdateDialog(this.u_id, this.row_date, this.updateUpdate, this.row_id);
  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {

String _desc = "";


  int _wilaya = 1;
  void _updateWilaya(int wilaya) {
    setState(() => _wilaya = wilaya);
  }

  int _status = 0;
  void _updateStatus(int status) {
    setState(() {
       _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    Map data = {
      'attendance_date': widget.row_date,
      'status': _status,
      'description': _desc,
      'state': _wilaya,
      'user_id':widget.u_id
    };
    //print("rets_"+_status.toString());
    //print(myController.text);

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
              onChanged: (text) {
                setState(() {
                  _desc= text;
                  print("from state"+_desc);
                });

              },
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
            Response response = await http.patch(Uri.parse('http://bts-algeria.com/API/api/timesheet/update'),
                body: body,
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});
            if (response.statusCode==200){
              print(response.body);
              widget.updateUpdate( widget.row_id, widget.row_date,_status, _wilaya, _desc );
              Fluttertoast.showToast(
                  msg: "Attendance updated successfully, Waiting for manager approval.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.of(context).pop();
            }
            else{
              print(response.body);
              print ('---------------/---------------/------------');
              Fluttertoast.showToast(
                  msg: "error",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }

          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}

class WilayaDD extends StatefulWidget {
  final Function updateWilaya;
  WilayaDD(this.updateWilaya);

  @override
  _WilayaDDState createState() => _WilayaDDState();
}

class _WilayaDDState extends State<WilayaDD> {

  int dropdownValue =0;
  String val= states[1];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      style: TextStyle(color: Colors.black),
      items: states
          .map((index, value) {
        return MapEntry(
            index,
            DropdownMenuItem<String>(
              value: value,
              child: Text(states[index]),
            ));
      })
          .values
          .toList(),
      value: val,
      onChanged: (String newValue) {
        if (newValue != null) {
          setState(() {
            val = newValue;
            var usdKey = states.keys.firstWhere(
                    (k) => states[k] == val, orElse: () => null);
            print (usdKey);
            dropdownValue = usdKey;
            widget.updateWilaya(dropdownValue);

          });
        }
      },


    );
  }
}

class StatusDD extends StatefulWidget {
  final Function updateStatus;
  StatusDD(this.updateStatus);

  @override
  _StatusDDState createState() => _StatusDDState();
}

class _StatusDDState extends State<StatusDD> {

  int dropdownValue =0;
  String val= work_statuses[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: work_statuses
          .map((index, value) {
        return MapEntry(
            index,
            DropdownMenuItem<String>(
              value: value,
              child: Text(work_statuses[index]),
            ));
      })
          .values
          .toList(),
      value: val,
      onChanged: (String newValue) {
        if (newValue != null) {
            val = newValue;
            var usdKey = work_statuses.keys.firstWhere(
                    (k) => work_statuses[k] == val, orElse: () => null);
            dropdownValue = usdKey;
            widget.updateStatus(dropdownValue);
            print(dropdownValue);


        }
      },
    );
  }
}

