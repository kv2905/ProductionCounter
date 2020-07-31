import 'package:flutter/material.dart';
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
        target: 1000,
        done: DATA['count'],
        left: 1000 - DATA['count'],
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

  Widget _buildUI(int done) {
    return LineDisplayCard(
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
                return _buildUI(displayCards[index].done);
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
    );
  }
}
