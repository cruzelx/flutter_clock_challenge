// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFFFFFFFF),
  _Element.text: Colors.black,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  //SVGs

  //end SVGs

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final seconds = DateFormat('ss').format(_dateTime);
    final fontFamily = 'BungeeInline';
    print(colors[_Element.background]);
    return Stack(
      children: <Widget>[
        Container(
            color: (Theme.of(context).brightness == Brightness.light)
                ? Color(0xff66a4dd)
                : Color(0xff040000),
            height: double.infinity,
            width: double.infinity,
            child: (Theme.of(context).brightness == Brightness.light)
                ? FlareActor(
                    'assets/flare/sunrise.flr',
                    fit: BoxFit.contain,
                    animation: 'sunrise',
                  )
                : FlareActor(
                    'assets/flare/moonrise.flr',
                    fit: BoxFit.contain,
                    animation: 'moonrise',
                  )),
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: '$hour',
                      style:
                          TextStyle(fontFamily: fontFamily, fontSize: 100.0)),
                  TextSpan(
                      text: '$minute',
                      style: TextStyle(
                        fontSize: 60.0,
                        fontFamily: fontFamily,
                      )),
                  TextSpan(
                      text: '$seconds',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: fontFamily,
                      ))
                ]),
          ),
        ),
       
      ],
    );
  }
}
