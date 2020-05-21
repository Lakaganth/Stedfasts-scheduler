import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/common/platform_exception_alert_dialog.dart';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/driver_database.dart';
import 'package:stedfasts_scheduler/utilities/form_submit_button.dart';

class AdminAddDriver extends StatefulWidget {
  static Future<void> show(BuildContext context,
      {DriverDatabase driverDatabase, Driver driver, AuthBase auth}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminAddDriver(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AdminAddDriverState createState() => _AdminAddDriverState();
}

class _AdminAddDriverState extends State<AdminAddDriver> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;
  String _phone;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final driverDatabase = Provider.of<DriverDatabase>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        final authResult =
            await auth.createUserWithEmailAndPassword(_email.trim(), _password);
        final newDriver = Driver(
          id: authResult.uid,
          name: _name,
          email: _email,
          favourite: false,
          avatarUrl:
              "https://www.shareicon.net/data/512x512/2016/04/10/747353_people_512x512.png",
          phone: _phone,
        );
        await driverDatabase.setNewDriver(newDriver);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(title: 'Operation Failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Driver"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormColumnChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildFormColumnChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Driver Name',
        ),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Driver Email',
        ),
        initialValue: _email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        initialValue: _password,
        validator: (value) =>
            value.isNotEmpty ? null : 'Password can\'t be empty',
        onSaved: (value) => _password = value,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Phone',
        ),
        initialValue: _phone,
        validator: (value) => value.isNotEmpty ? null : 'Phone can\'t be empty',
        onSaved: (value) => _phone = value,
      ),
      SizedBox(
        height: 26.0,
      ),
      FormSubmitButton(
        text: "Submit",
        onPressed: () => _submit(),
      )
    ];
  }
}
