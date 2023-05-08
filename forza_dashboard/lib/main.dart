import 'dart:async';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'dart:io';
import 'FDP.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'forza Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var defaultMessage = "Hello, this is Forza Dashboard";
  var changedMessage = "Button pressed!";
  bool listening = false;
  final InternetAddress internetAddress = InternetAddress.anyIPv4;
  final port = 65432;
  late RawDatagramSocket socket;  // Socket to be used to receive forza udp data
  late Stream<RawSocketEvent> broadcastStream;  // broadcast stream that will contain the stream of data
  var streamCreated = false;
  late StreamSubscription<RawSocketEvent> listener;  // The listener stream that will trigger events

  // creates the stream and socket
  void createStream() async {
    print("Creating stream...");
    socket = await RawDatagramSocket.bind(internetAddress, port);
    broadcastStream = socket.asBroadcastStream(
    onCancel: (controller) {
      print("Stream paused");
      controller.pause();
    },
    onListen: (controller) async {
      if (controller.isPaused) {
        print("Stream resumed");
        controller.resume();
      }
    },);
    print("Broadcast Stream created! Listening on ${internetAddress.address}:$port");
    streamCreated = true;
    listener = createListener();
  }

  StreamSubscription<RawSocketEvent> createListener() {
    return broadcastStream.listen((event) {
      Datagram? datagram = socket.receive();
      if (datagram == null) return;
      var fdp = FDP(datagram.data);
      if (fdp.isRaceOn == 1 && listening) print(1);
    });
  }

  @override
  void initState() {
    super.initState();
    print("In initState");
    createStream();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Forza Dashboard"),
      ),
      body: Column(
        children: [
          Text(listening ? "Listening..." : "Not listening."),
          ElevatedButton(
            onPressed: () {
              setState(() {
                listening = !listening;
              });
            },
            child: Text("Start Listening"),
          )
        ],
      ),
    );
  }
}