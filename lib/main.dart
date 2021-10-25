import 'package:flutter/material.dart';
import '/providers/auth_provider.dart';
import '/providers/user_provider.dart';
import '/screens/timesheet.dart';
import '/utility/shared_preference.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';
import 'screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Future<User> getUserData () {
      return UserPreferences().getUser();
    }

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> AuthProvider()),
          ChangeNotifierProvider(create: (_)=>UserProvider())
        ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login Registration',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (snapshot.data.resp.refreshToken == null){
                    print(snapshot.data.resp.refreshToken );
                    print(snapshot.data.user.first.name );
                    print(snapshot.data.user.first.email );

                    return Login();
                  }
                  else if (snapshot.data.resp.refreshToken != null)
                    Provider.of<UserProvider>(context).setUser(snapshot.data);
                    return Timesheets();

              }
            }),
        routes: {
          '/login':(context)=>Login(),
          '/timesheet':(context)=>Timesheets()
        },
      ),
    );


  }
}



