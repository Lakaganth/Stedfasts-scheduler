import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/services/auth.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Container(
      child: Center(
        child: FlatButton(
          child: Text("signOut"),
          onPressed: () {
            auth.signOut();
          },
        ),
      ),
    );
  }
}
