import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/screens/set_target_screen.dart';

class ShiftInputForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.pushNamed(context, SetTargetScreen.id);
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
//                                  key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
//                                            if (_formKey.currentState
//                                                .validate()) {
//                                              _formKey.currentState.save();
//                                            }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
