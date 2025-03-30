import 'package:flutter/material.dart';
import 'dart:async';
class TimeRemainingPage extends StatefulWidget {
  final DateTime endTime;
  final TextStyle onText;
  TimeRemainingPage({required this.endTime,required this.onText});

  @override
  _TimeRemainingPageState createState() => _TimeRemainingPageState();
}

class _TimeRemainingPageState extends State<TimeRemainingPage> {
  Duration _remainingTime = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
  }

  void _updateRemainingTime() {
    DateTime now = DateTime.now();
    
    setState(() {
      _remainingTime = widget.endTime.difference(now);
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
            Text(
              "${_remainingTime.inHours}:${(_remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
              style: widget.onText,
            );
  }
}
