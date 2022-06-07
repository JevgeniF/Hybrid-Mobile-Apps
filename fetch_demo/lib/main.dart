import 'dart:async';
import 'dart:convert';

import 'package:fetch_demo/song_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

Future<SongInfo> fetchSongInfo() async {
  final response =
      await http.get(Uri.parse('https://dad.akaver.com/api/SongTitles/RRAP'));
  if (response.statusCode == 200) {
    return SongInfo.fromJson(json.decode(response.body));
  }

  return SongInfo(
      artist: 'Status ${response.statusCode}',
      title: response.reasonPhrase.toString());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<SongInfo> songInfo;
  // ignore: unused_field
  late Timer _timer;
  int _timerCounter = 10;

  @override
  void initState() {
    super.initState();
    songInfo = fetchSongInfo();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_timerCounter <= 0) {
          //timer.cancel();
          songInfo = fetchSongInfo();
          _timerCounter = 10;
        } else {
          _timerCounter--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch demo'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<SongInfo>(
                future: songInfo,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        snapshot.data!.artist + ' - ' + snapshot.data!.title);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      songInfo = fetchSongInfo();
                    });
                  },
                  child: const Text('Refresh data')),
              ElevatedButton(
                  onPressed: () {
                    _timerCounter = 10;
                    startTimer();
                  },
                  child: Text('Refresh after $_timerCounter secs')),
            ],
          ),
        ),
      ),
    );
  }
}
