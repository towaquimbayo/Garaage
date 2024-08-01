import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garaage/presentation/chatbot/widgets/selected_images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/config/assets/app_icons.dart';
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
  final imagesPicked = <XFile?>[];

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
    _stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotCubit, ChatbotState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final sendMessage =
            BlocProvider.of<ChatbotCubit>(context).addChatMessage;
        final chatBotSize =
            imagesPicked.isNotEmpty ? size.height * 0.8 : size.height * 0.88;
        final selectedImagesSize = size.height - chatBotSize;
        return Column(
          children: [
            SizedBox(
              height: chatBotSize,
              width: size.width,
              child: _buildUI(state, sendMessage),
            ),
            SelectedImages(
              selectedImages: imagesPicked,
              size: imagesPicked.isNotEmpty ? selectedImagesSize : 0,
              removeImage: (index) {
                setState(() {
                  imagesPicked.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUI(
    ChatbotState chatBotState,
    Function(ChatMessage) sendMessage,
  ) {
    print(imagesPicked.length);
    return DashChat(
        inputOptions: InputOptions(leading: [
          Stack(children: [
            IconButton(
              onPressed: () {
                // _sendMediaMessage(sendMessage);
                _pickImages();
              },
              icon: SvgPicture.asset(
                AppIcons.broken['gallery']!,
                colorFilter: const ColorFilter.mode(
                  AppColors.darkGrayDarkest,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (imagesPicked.isNotEmpty)
              Positioned(
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    "${imagesPicked.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ]),
        ], trailing: [
          IconButton(
              onPressed:
                  _speechToText.isListening ? _stopListening : _startListening,
              icon: _speechToText.isListening
                  ? CircleAvatar(
                      backgroundColor: AppColors.darkGrayLightest,
                      child: SvgPicture.asset(
                        AppIcons.broken['microphone']!,
                        colorFilter: const ColorFilter.mode(
                          AppColors.lightGrayLightest,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : SvgPicture.asset(
                      AppIcons.broken['microphone']!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.darkGrayDarkest,
                        BlendMode.srcIn,
                      ),
                    )),
        ], textController: _controller),
        currentUser: currentUser,
        onSend: (chatMessage) {
          _sendMediaMessage(sendMessage, chatMessage);
        },
        messages: chatBotState.chatMessages);
  }

  void _pickImages() async {
    ImagePicker picker = ImagePicker();
    List<XFile?> files = await picker.pickMultiImage(
      limit: 5,
    );
    for (var file in files) {
      if (!imagesPicked.contains(file)) {
        imagesPicked.add(file);
      }
    }
    setState(() {});
  }

  void _sendMediaMessage(
    Function(ChatMessage) sendMessage,
    ChatMessage chatMessage,
  ) {
    List<ChatMedia> medias = [];
    for (final file in imagesPicked) {
      if (file != null) {
        medias.add(
          ChatMedia(url: file.path, fileName: file.name, type: MediaType.image),
        );
      }
    }
    chatMessage.medias = medias;
    sendMessage(chatMessage);
    setState(() {
      imagesPicked.clear();
    });
  }
}
