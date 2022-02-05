import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> _requestPermission(Permission permission) async {
//    final PermissionHandler _permissionHandler = PermissionHandler();
  var result = await [permission].request();
//    var result = await _permissionHandler.requestPermissions([permission]);
  if (result[permission] == PermissionStatus.granted) {
    return true;
  }
  return false;
}

/*Checking if your App has been Given Permission*/
Future<bool> requestLocationPermission() async {
  var granted = await _requestPermission(Permission.location);
  if (granted != true) {
    requestLocationPermission();
  }
  return granted;
}

/*Show dialog if GPS not enabled and open settings location*/
Future _checkGps(context) async {
  if (!(await Geolocator.isLocationServiceEnabled())) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Can't get gurrent location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () async {
                      final AndroidIntent intent = AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                      await intent.launch();
                      Navigator.of(context, rootNavigator: true).pop();
                      _gpsService(context);
                    })
              ],
            );
          });
    }
  }
}

/*Check if gps service is enabled or not*/
Future _gpsService(context) async {
  if (!(await Geolocator.isLocationServiceEnabled())) {
    _checkGps(context);
    return null;
  } else
    return true;
}
