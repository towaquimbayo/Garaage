import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/config/theme/app_colors.dart';
import '../bloc/chatbot_cubit.dart';

class ChatbotBody extends StatefulWidget {
  const ChatbotBody({super.key});

  @override
  State<ChatbotBody> createState() => _ChatbotBodyState();
}

class _ChatbotBodyState extends State<ChatbotBody> {
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Mika");

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult? result) {
    final speechInput = result?.recognizedWords ?? "";
    setState(() {
      _controller.text = speechInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotCubit, ChatbotState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final sendMessage = BlocProvider.of<ChatbotCubit>(context).addChatMessage;

        return SizedBox(
          height: size.height * 0.8,
          width: size.width,
          child: _buildUI(state, sendMessage),
        );
      },
    );
  }

  Widget _buildUI(
    ChatbotState chatBotState,
    Function(ChatMessage) sendMessage,
  ) {
    return DashChat(
      inputOptions: InputOptions(
        leading: [
          IconButton(
            onPressed: () {
              _sendMediaMessage(sendMessage);
            },
            icon: const Icon(
              Icons.image_outlined,
            ),
          )
        ], 
        trailing: [
          IconButton(
            onPressed:
                _speechToText.isListening ? _stopListening : _startListening,
            icon: Icon(
              _speechToText.isListening ? Icons.mic_off : Icons.mic,
            ),
          )
        ], 
        textController: _controller
      ),
      currentUser: currentUser,
      onSend: sendMessage,
      messages: chatBotState.chatMessages
    );
  }

  void _sendMediaMessage(
    Function(ChatMessage) sendMessage,
  ) async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage message = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe the image",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ]
      );
      sendMessage(message);
    }
  }
}