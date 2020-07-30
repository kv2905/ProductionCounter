import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tenupproductioncounter/widgets/custom_logo.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter_blue/flutter_blue.dart';

class WifiSettingsScreen extends StatefulWidget {
  static const String id = 'wifi_settings_screen';
  @override
  _WifiSettingsScreenState createState() => _WifiSettingsScreenState();
}

class _WifiSettingsScreenState extends State<WifiSettingsScreen> {
  // ignore: non_constant_identifier_names
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  // ignore: non_constant_identifier_names
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  // ignore: non_constant_identifier_names
  final String TARGET_DEVICE_NAME = "ESP32";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubscription;
  BluetoothState state;
  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";

  @override
  void initState() {
    super.initState();
    startScan();
  }



  startScan() {
    setState(() {
      connectionText = "Started Scanning";
    });

    scanSubscription = flutterBlue.scan().listen((scanResult) {
      print(scanResult.device.name);
      if (scanResult.device.name.contains(TARGET_DEVICE_NAME)) {
        stopScan();
        setState(() {
          connectionText = "Found Target Device";
        });

        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  stopScan() {
    flutterBlue.stopScan();
    scanSubscription?.cancel();
    scanSubscription = null;
  }

  connectToDevice() async {
    if (targetDevice == null) {
      return;
    }

    setState(() {
      connectionText = "Device Connecting";
    });

    await targetDevice.connect();
    setState(() {
      connectionText = "Device Connected";
    });

    discoverServices();
  }

  disconnectFromDevice() {
    if (targetDevice == null) {
      return;
    }

    targetDevice.disconnect();
    setState(() {
      connectionText = "Device Disconnected";
    });
  }

  discoverServices() async {
    if (targetDevice == null) {
      return;
    }

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristics) {
          if (characteristics.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristics;
            setState(() {
              connectionText = "${targetDevice.name}";
            });
          }
        });
      }
    });
  }

  writeData(String data) async {
    if (targetCharacteristic == null) {
      return;
    }

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
  }

  @override
  void dispose() {
    stopScan();
    targetDevice.disconnect();
    super.dispose();
  }

  submitAction() {
    var wifiDATA = '${wifiNameController.text},${wifiPasswordController.text}';
    writeData(wifiDATA);
    targetDevice.disconnect();
    Navigator.pop(context);
  }

  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLogo(
                  name: connectionText,
                ),
                SizedBox(
                  height: 48.0,
                ),
                targetCharacteristic == null
              ? Text(
                  'Waiting...',
                  style: TextStyle(
                    color: Color(0xFFE42426),
                    fontSize: 34.0,
                  ),
                )
              : Column(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      controller: wifiNameController,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'SSID',
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      controller: wifiPasswordController,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    RoundedButton(
                      color: Colors.lightBlueAccent,
                      buttonName: 'Send',
                      onPressed: submitAction,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
