import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  final List<types.Message> _messages = [];
  @override
  Widget build(BuildContext context) {
    final user = types.User(id: context.read<UserProvider>().userId.toString());
    void handleSendPressed(types.PartialText message) {
      final textMessage = types.TextMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: message.text,
      );

      _addMessage(textMessage);
    }

    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: handleSendPressed,
        user: user,
      ),
    );
  }
}
