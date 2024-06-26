import 'package:flutter/material.dart';
import 'package:frontend/pages/ai_chat/ai_chat.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AiChat(),
    );
  }
}
