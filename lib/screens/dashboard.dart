import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tenupproductioncounter/widgets/display_card.dart';
import 'package:firebase_database/firebase_database.dart';

class Dashboard extends StatefulWidget {
  static const String id = 'dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  List<DisplayCard> displayCards = [];

  _fetchData() {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('Company1').child('line1');
    dbRef.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var DATA = snap.value;
      print(DATA['count']);
      displayCards.clear();
      DisplayCard tempCard = DisplayCard(
        line: 'Line1',
        target: 1000,
        done: DATA['count'],
        left: 1000 - DATA['count'],
        tabColor: Colors.green,
      );
      displayCards.add(tempCard);
      setState(() {
        print(displayCards.length);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _fetchData();
  }

  Widget _buildUI(int done) {
    return DisplayCard(
      line: 'Line1',
      tabColor: Colors.green,
      shift: 'Shift1',
      target: 1000,
      done: done,
      left: 1000-done<0 ? 0 : 1000-done,
    );
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
      ),
      endDrawer: AppDrawer(),
      body: Container(
        child: displayCards.length == 0
        ? Center(child: Text('Nothing to display'))
        : ListView.builder(
          itemCount: displayCards.length,
          itemBuilder: (_, index) {
            print(displayCards[index].done);
            return _buildUI(displayCards[index].done);
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF42906A),
        child: Icon(Icons.refresh),
        onPressed: (){
          _fetchData();
        },
      ),
    );
  }
}
