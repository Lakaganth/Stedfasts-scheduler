import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/driver_database.dart';
import 'package:stedfasts_scheduler/common/platform_exception_alert_dialog.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as Im;

class AccountsScreen extends StatefulWidget {
  final User user;

  AccountsScreen({@required this.user});

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    final DriverDatabase driver = Provider.of<DriverDatabase>(context);

    return Scaffold(
      body: StreamBuilder(
        stream: driver.driverProfile(widget.user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<Driver> items = snapshot.data;
              return BuildAccountScreen(driver: items[0]);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error , ${snapshot.error}"),
              );
            } else {
              return Container(
                child: Text("No Data"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class BuildAccountScreen extends StatefulWidget {
  const BuildAccountScreen({@required this.driver});

  final Driver driver;

  @override
  _BuildAccountScreenState createState() => _BuildAccountScreenState();
}

class _BuildAccountScreenState extends State<BuildAccountScreen> {
  File file;
  String get postId => widget.driver.id;
  bool isUploading = false;
  final storageReference = FirebaseStorage.instance.ref();

  void _logout(AuthBase auth) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm Logout"),
            content: Text("Are you sure you want to Logout?"),
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: "Logut Failed", exception: e);
    }
  }

  void _handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  void _handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file;
    });
  }

  _selectImage() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: _handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: _handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return file == null
        ? SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(children: [
                      Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.blueAccent,
                          backgroundImage:
                              NetworkImage(widget.driver.avatarUrl),
                        ),
                      ),
                      Positioned(
                        right: screenWidth / 4.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.create,
                            size: 40.0,
                            color: Colors.black87,
                          ),
                          onPressed: () => _selectImage(),
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildDriverInfoBox(screenWidth),
                    _buildSignoutButton(auth),
                  ],
                ),
              ),
            ),
          )
        : buildUploadForm();
  }

  _buildDriverInfoBox(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 150,
        width: screenWidth / 1.1,
        decoration: BoxDecoration(
          color: Color(0xff1E1D1D),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, .3),
              blurRadius: 10.0,
              offset: Offset(0, 12),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _displayDriverInfo(label: "Name", driverInfo: widget.driver.name),
            _displayDriverInfo(label: "Email", driverInfo: widget.driver.email),
            _displayDriverInfo(label: "Phone", driverInfo: widget.driver.phone),
          ],
        ),
      ),
    );
  }

  Padding _displayDriverInfo(
      {@required String label, @required String driverInfo}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style:
                GoogleFonts.montserrat(color: Color(0xff6B6969), fontSize: 14),
          ),
          Text(
            "$driverInfo",
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  _buildSignoutButton(AuthBase auth) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(225, 126, 210, 1),
              Color.fromRGBO(255, 203, 215, 1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(143, 148, 251, .3),
              blurRadius: 20.0,
              offset: Offset(5, 12),
            )
          ],
        ),
        child: FlatButton(
          onPressed: () => _logout(auth),
          child: Center(
            child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageReference.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostinFireStore({String mediaURL}) async {
    final DriverDatabase driverDatabase =
        Provider.of<DriverDatabase>(context, listen: false);

    final newDriverAvatar = Driver(
      id: widget.driver.id,
      name: widget.driver.name,
      email: widget.driver.email,
      favourite: false,
      avatarUrl: mediaURL,
      phone: widget.driver.phone,
    );
    await driverDatabase.setNewDriver(newDriverAvatar);
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });

    await compressImage();

    String mediaUrl = await uploadImage(file);
    createPostinFireStore(
      mediaURL: mediaUrl,
    );

    setState(() {
      file = null;
      isUploading = false;
    });
  }

  buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: clearImage),
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? CircularProgressIndicator() : Text(''),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(file), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.driver.avatarUrl),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stedfasts_scheduler/services/auth.dart';

// class AccountsScreen extends StatefulWidget {
//   @override
//   _AccountsScreenState createState() => _AccountsScreenState();
// }

// class _AccountsScreenState extends State<AccountsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final AuthBase auth = Provider.of<AuthBase>(context);
//     return Container(
//       child: Center(
//         child: FlatButton(
//           child: Text("signOut"),
//           onPressed: () {
//             auth.signOut();
//           },
//         ),
//       ),
//     );
//   }
// }
