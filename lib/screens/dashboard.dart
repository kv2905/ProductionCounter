import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/screens/welcome_screen.dart';
import 'package:tenupproductioncounter/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tenupproductioncounter/widgets/line_display_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  static const String id = 'dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  List<LineDisplayCard> displayCards = [];
  DateTime updatedAt;
  String updatedAtString;

  _fetchData() {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('Company1').child('line1');
    dbRef.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var DATA = snap.value;
      displayCards.clear();
      LineDisplayCard tempCard = LineDisplayCard(
        line: 'Line1',
        target: DATA['target'],
        done: DATA['count'],
        left: DATA['target'] - DATA['count'],
        tabColor: Colors.green,
      );
      displayCards.add(tempCard);
      setState(() {
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _fetchData();
    updatedAt = DateTime.now();
    updatedAtString = DateFormat('dd/MM/yyyy hh:mm:ss').format(updatedAt);
  }

  Widget _buildUI(int done, int target) {
    return LineDisplayCard(
      line: 'Line1',
      tabColor: Colors.green,
      shift: 'Shift1',
      target: target,
      done: done,
      left: target-done<0 ? 0 : target-done,
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: Column(
          children: [
            Container(
              height: 20,
              child: Text('Last updated at $updatedAtString'),
            ),
            Expanded(
              child: displayCards.length == 0
              ? Center(child: Text('Nothing to display'))
              : ListView.builder(
                itemCount: displayCards.length,
                itemBuilder: (_, index) {
                  return _buildUI(displayCards[index].done, displayCards[index].target);
                }
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF42906A),
          child: Icon(Icons.refresh),
          onPressed: (){
            _fetchData();
            setState(() {
              updatedAt = DateTime.now();
              updatedAtString = DateFormat('dd/MM/yyyy hh:mm:ss').format(updatedAt);
            });
          },
        ),
      ),
    );
  }
}


