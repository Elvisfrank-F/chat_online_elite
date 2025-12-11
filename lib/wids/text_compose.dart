import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class TextCompose extends StatefulWidget {

   final Function({String? text, XFile? img}) sendMessage;

  const TextCompose({super.key, required this.sendMessage});

  @override
  State<TextCompose> createState() => _TextComposeState();
}

class _TextComposeState extends State<TextCompose> {

  bool _isComposing = false;

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.photo_camera),
              onPressed: () async{

            final XFile? imgFile = await ImagePicker().pickImage(
              source: ImageSource.camera
            );

            if(imgFile == null) return;

            widget.sendMessage(img: imgFile);



              }),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensagem'),
              onChanged: (text){
              setState(() {
              _isComposing = text.isNotEmpty;

              });
              },
              onSubmitted: (text){
                widget.sendMessage(text: text);
                setState(() {
                  _isComposing = false;
                  _controller.clear();
                });
              },
            ),
          ),
          IconButton(icon: Icon(Icons.send),
              onPressed: _isComposing ? () async{
                widget.sendMessage(text: _controller.text);
                setState(() {
                  _isComposing = false;
                  _controller.clear();
                });
              } : null)
        ],
      ),
    );
  }
}

