import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renty_crud_version/ui/shared/shared_styles.dart';
import 'package:renty_crud_version/ui/shared/ui_helpers.dart';

import 'note_text.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextInputType textInputType;
  final bool password;
  final bool isReadOnly;
  final String placeholder;
  final String validationMessage;
  final Function enterPressed;
  final bool smallVersion;
  final FocusNode fieldFocusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final String additionalNote;
  final Function(String) onChanged;
  final TextInputFormatter formatter;

  InputField(
      {@required this.controller,
      @required this.placeholder,
      this.decoration,
      this.enterPressed,
      this.fieldFocusNode,
      this.nextFocusNode,
      this.additionalNote,
      this.onChanged,
      this.formatter,
      this.validationMessage,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.password = false,
      this.isReadOnly = false,
      this.smallVersion = false});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isPassword;
  bool showPassword;
  double fieldHeight = 55;

  @override
  void initState() {
    super.initState();
    showPassword = false;
    isPassword = widget.password;
    if(isPassword){
      showPassword = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
        labelText: widget.placeholder,
        focusColor: Colors.pinkAccent,
        border: OutlineInputBorder(),
        prefixIcon: widget.placeholder.toString() == 'Email'
            ? Icon(Icons.email)
            : widget.placeholder.toString() == 'Password'
                ? Icon(Icons.lock)
                : widget.placeholder.toString() == 'Full Name'
                    ? Icon(Icons.person)
                    : Icon(Icons.cake));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.smallVersion ? 40 : fieldHeight,
          alignment: Alignment.centerLeft,
          padding: fieldPadding,
          // decoration:
          //     widget.isReadOnly ? disabledFieldDecortaion : fieldDecortaion,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.textInputType,
                  focusNode: widget.fieldFocusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  inputFormatters:
                      widget.formatter != null ? [widget.formatter] : null,
                  onEditingComplete: () {
                    if (widget.enterPressed != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.enterPressed();
                    }
                  },
                  onFieldSubmitted: (value) {
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode.requestFocus();
                    }
                  },
                  obscureText: showPassword,
                  readOnly: widget.isReadOnly,
                  decoration: isPassword
                      ? InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                              onTap: () => setState(() {
                                    showPassword = !showPassword;
                                  }),
                              child: Icon(showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off)))
                      : inputDecoration,
                  // decoration: widget.decoration,
                ),
              ),
            ],
          ),
        ),
        if (widget.validationMessage != null)
          NoteText(
            widget.validationMessage,
            color: Colors.red,
          ),
        if (widget.additionalNote != null) verticalSpace(5),
        if (widget.additionalNote != null) NoteText(widget.additionalNote),
        verticalSpaceSmall
      ],
    );
  }
}
