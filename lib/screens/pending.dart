import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/maps.dart';
import 'package:flutter_login_regis_provider/domain/pends.dart';
import 'package:flutter_login_regis_provider/domain/times.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'package:flutter_login_regis_provider/screens/drawer.dart';
import 'first_timesheets/first_timesheets.dart';
import 'the_timesheet/buttons.dart';
import 'the_timesheet/third_timesheet.dart';
import 'package:flutter_login_regis_provider/utility/shared_preference.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';


Future<Pends> fetchPending(String token) async {
  final response = await http
      .get(Uri.parse('https://bts-algeria.com/API/api/timesheet/pending'),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer '+token,
    },);
  print(token);
  print("--------------------");
  if (response.statusCode == 200) {

    print("this is    "+response.body);

    return Pends.fromJson(jsonDecode(response.body));
  } else {

    throw Exception('Failed to load album');
  }
}


class Pending extends StatefulWidget {
  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  Future<Pends> futurePending;
  User _user = new User();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<UserProvider>(context).user;
    futurePending = fetchPending(_user.resp.accessToken);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<Pends>(
        future: futurePending,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PendingTable(snapshot.data,);
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



class PendingTable extends StatefulWidget {
  Pends pend;
  PendingTable(this.pend);

  @override
  State<PendingTable> createState() => _PendingTableState();
}

class _PendingTableState extends State<PendingTable> {


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
          for(Att att in widget.pend.atts)
            DataRow(
              cells: <DataCell>[
                DataCell(Container(width: 20,child: Text(widget.pend.atts.indexOf(att).toString() ))),
                DataCell(Text(att.userId?? 'no description')),
                DataCell(Text(states[int.parse(att.stateId?? "0")])),
                DataCell(Text(att.date?? 'no description')),
                DataCell(Text(att.description?? '-')),
                DataCell(Text(work_statuses[int.parse(att.workStatusId??'69')])),
                DataCell(statusColored(int.parse(att.statusId ?? '0'))),
                DataCell(
                    Row(children: [
                      // if(at.statusId!=null)Text(at.statusId+"***"+  at.date+"***"+at.userId+"***"+user.user.first.id.toString()),


                      if((att.statusId=="9" || att.statusId=="8" ||  att.statusId=="6" ) && att.userId!=user.user.first.id.toString())
                        Row(
                          children: [
                            if(att.statusId!="6")ElevatedButton( style:ElevatedButton.styleFrom(primary:Colors.green,   ),
                                onPressed: () {
                                  print(att.date);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return approver(  att.id ,att.userId, att.date, int.parse(att.userId),);
                                    },
                                  );
                                },child: Text('Approve')),
                            if(att.statusId=="6")ElevatedButton( style:ElevatedButton.styleFrom(primary:Colors.orange,   ),
                                onPressed: () {
                                  print(att.date);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return disapprover(  att.id ,att.userId, att.date, int.parse(att.userId),);
                                    },
                                  );
                                },child: Text('Disapprove')),
                            SizedBox(width: 10,),
                            if(att.statusId!="8")ElevatedButton( style:ElevatedButton.styleFrom(primary:Colors.red,   ),
                                onPressed: () {
                                  print(att.date);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return rejecter(  att.id ,att.userId, att.date, int.parse(att.userId),);
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