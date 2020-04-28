import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamBuilder Bug Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    LoginButtons(),
    UserStream()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text("Account"),
            )
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}

class UserStream extends StatefulWidget {
  UserStream() {
    print('created');
  }

  @override
  _UserStreamState createState() => _UserStreamState();
}

class _UserStreamState extends State<UserStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseUserReloader.onAuthStateChangedOrReloaded,
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        print('snapshot has data: ${snapshot.hasData}');
        print('user name: ${snapshot.data?.displayName}');
        return Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  @override
  void dispose() {
    print('disposed');
    super.dispose();
  }
}

class LoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text('Press me to login'),
            onPressed: () async {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: 'test@email.com', password: '123456');
            },
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Press me to logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}

