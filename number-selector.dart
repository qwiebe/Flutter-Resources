// ================================================== //
//  NumberSelector - A number selecting widget!       //
//    Creates a TextField which can be edited         //
//    by either tap-and-typing a new number           //
//    or by tap-and-dragging (scrolling).             //
//      Drag up   = decrease the number               //
//      Drag down = increase the number               //
//                                                    //
//  Parameters:                                       //
//    (Currently functional)                          //
//    width   the width of the textbox                //
//                                                    //
//    (Potential Future)                              //
//    height  the height of the textbox               //
//    color   color of textbox                        //
//    factor  affects the rate at which dragging      //
//            increments the number                   //
// ================================================== //

import 'package:flutter/material.dart';

class NumberSelector extends StatefulWidget {
  NumberSelector({Key key, this.width, this.height}) : super(key: key);
  final double width;
  final double height;

  @override
  _NumberSelector createState() => _NumberSelector(width, height);
}

class _NumberSelector extends State<NumberSelector> {
  // ========== CONSTRUCTOR =========== //
  _NumberSelector(this.width, this.height);

  // ========== DECLARATION OF VARIABLES =========== //
  double width;
  double height;
  int _number;    // the number displayed
  int _numHelp;   // stores the value of _number at the beginning of a scrolling-change
  TextEditingController _controller;
  FocusNode _focus;

  // ========== PUBLIC METHODS =========== //
  
  void increment(int i) {
  // Do not confuse with _increment()
  // increment() is for EXTERNAL USE ONLY
    setState(() {
      _number += i;
      _numHelp = _number;
      _controller.text = _intToString(_number, 2);
    });
  }

  void setNumber(int i) {
    setState(() {
      _number = i;
      _numHelp = i;
      _controller.text = _intToString(_number, 2);
    });
  }

  // ========== PRIVATE METHODS =========== //
  
  // Converts integer to string (with optional length extension eg. i=1, length=3 => s='001')
  String _intToString(int i, [int length, String fill = '0']) {
    String s = i.toString();
    if (length != null) {
      while (s.length < length) {
        s = fill + s;
      }
    }
    
    return s;
  }

  void _increment(int i) {
  // Not to be confused with increment().
  // _increment() is for internal use only.  It's kinda specially modified to work with the scrolling feature
    setState(() {
      // Change the _number displayed, but keep _numHelp unmodified for future reference
      _number = _numHelp + i;
      _controller.text = _intToString(_number, 2);
    });
  }

  void _onVerticalDragDown(details) {
    // For Testing Purposes
    // print(details);
  }

  void _onVerticalDragUpdate(details) {
    // Establish the factor by which the "scroll-increment" functionality works
    // Higher factors give higher scroll rates, and vice versa
    double factor = 0.25;

    // The position relative to the initial tap-down gives the amount to increment
    double i = details.localPosition.dy;
    i = i * factor;
    // For positive i, round up.  For negative, round down
    // This if-else block might be a bit useless... 
    //    it was critical in a prior revision where rounding to 0 was common-place and undesirable
    if (i > 0) {
      _increment(i.ceil());
    } else {
      _increment(i.floor());
    }
  }

  void _onVerticalDragEnd(details) {
    // Finally, the user has stopped scroll-changing.
    // Now we can set _numHelp to the new final (for now) value of _number
    _numHelp = _number;
  }

  void _onTap() {
    // Not scrolling this time.  Actually want to type in a value
    _focus.requestFocus();
  }

  void _onSubmit(String value) {
    // For manual typing in of value.  Sets the new _number.
    setNumber(int.parse(value));
  }
  
  // ========== OVERRIDE METHODS =========== //
  @override
  void initState() {
    super.initState();
    _number = 0;
    _numHelp = _number;
    _controller = TextEditingController();
    _focus = FocusNode();
    _controller.text = _intToString(_number, 2);

    if (width == null || height == null) {
      width = 50;
      height = 60;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) => _onVerticalDragDown(details),
      onVerticalDragUpdate: (DragUpdateDetails details) => _onVerticalDragUpdate(details),
      onVerticalDragEnd: (DragEndDetails details) =>_onVerticalDragEnd(details),
      onTap: _onTap,
      
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: IgnorePointer(
          child: TextField(
            focusNode: _focus,
            controller: _controller,
            onSubmitted: _onSubmit,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
        )
      )
    );
  }
}