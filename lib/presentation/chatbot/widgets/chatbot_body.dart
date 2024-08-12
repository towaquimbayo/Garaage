import 'package:camera/camera.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../camera/page/camera.dart';
import '../bloc/chatbot_cubit.dart';
import './selected_images.dart';

/// A stateful widget that represents the main body of the chatbot page.
class ChatbotBody extends StatefulWidget {
  const ChatbotBody({super.key});

  @override
  State<ChatbotBody> createState() => _ChatbotBodyState();
}

class _ChatbotBodyState extends State<ChatbotBody> {
  /// Controller for the text input field.
  final TextEditingController _controller = TextEditingController();

  /// Instance of SpeechToText for voice input.
  final SpeechToText _speechToText = SpeechToText();

  /// Boolean to indicate if speech recognition is enabled.
  bool _speechEnabled = false;

  /// List to store chat messages.
  List<ChatMessage> messages = [];

  /// List to store selected images.
  final imagesPicked = <XFile?>[];

  /// List of available camera descriptions.
  late List<CameraDescription> cameras;

  /// Selected camera description.
  late CameraDescription camera;

  @override
  void initState() {
    super.initState();
    initSpeech();
    initCamera();
  }

  /// Initializes the camera by fetching available cameras and selecting the first one.
  void initCamera() {
    try {
      availableCameras().then((availableCameras) {
        cameras = availableCameras;
        camera = cameras.first;
        print(cameras);
      });
    } on CameraException catch (e) {
      print(e);
    }
  }

  /// Initializes speech recognition by enabling it.
  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Starts listening to the user's speech input.
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Stops listening to the user's speech input.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// Handles the result of speech recognition and updates the text input field.
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

        /// Function to send a chat message using the ChatbotCubit.
        final sendMessage =
            BlocProvider.of<ChatbotCubit>(context).addChatMessage;

        /// Calculate the height of the chat UI based on whether images are picked.
        final chatBotSize =
            imagesPicked.isNotEmpty ? size.height * 0.8 : size.height * 0.88;

        /// Calculate the size for displaying selected images.
        final selectedImagesSize = size.height - chatBotSize;

        return Column(
          children: [
            SizedBox(
              height: chatBotSize,
              width: size.width,
              child: _buildUI(state, sendMessage),
            ),
            SelectedImages(
              pickedImages: imagesPicked,
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

  /// Builds the UI for the chatbot including the message input field and send button.
  Widget _buildUI(
    ChatbotState chatBotState,
    Function(ChatMessage) sendMessage,
  ) {
    print(imagesPicked.length);
    return DashChat(
      inputOptions: InputOptions(
        leading: [
          Stack(children: [
            IconButton(
              onPressed: () {
                // Opens the image picker to select images from the gallery.
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
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              // Opens the camera page to capture images.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraPage(
                    camera: camera,
                    addImage: (xFile) {
                      setState(() {
                        imagesPicked.add(xFile);
                      });
                    },
                  ),
                ),
              );
            },
            icon: SvgPicture.asset(
              AppIcons.broken['camera']!,
              colorFilter: const ColorFilter.mode(
                AppColors.darkGrayDarkest,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
        trailing: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Ink(
              decoration: ShapeDecoration(
                color: _speechToText.isListening
                    ? AppColors.primaryDarkest
                    : AppColors.background,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                onPressed: _speechToText.isListening
                    ? _stopListening
                    : _startListening,
                icon: SvgPicture.asset(
                  AppIcons.broken['microphone']!,
                  colorFilter: const ColorFilter.mode(
                    AppColors.darkGrayDarkest,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
        textController: _controller,
      ),
      currentUser: ChatbotState.currentUser,
      onSend: (chatMessage) {
        _sendMediaMessage(sendMessage, chatMessage);
      },
      messages: chatBotState.chatMessages,
      typingUsers: [
        if (chatBotState.aiTyping) ChatbotState.geminiUser,
      ],
    );
  }

  /// Opens the image picker to select multiple images from the gallery.
  void _pickImages() async {
    ImagePicker picker = ImagePicker();
    List<XFile?> files = await picker.pickMultiImage(limit: 5);
    for (var file in files) {
      if (!imagesPicked.contains(file)) {
        imagesPicked.add(file);
      }
    }
    setState(() {});
  }

  /// Sends a chat message along with any selected media files.
  void _sendMediaMessage(
    Function(ChatMessage) sendMessage,
    ChatMessage chatMessage,
  ) {
    List<ChatMedia> medias = [];
    for (final file in imagesPicked) {
      if (file != null) {
        medias.add(
          ChatMedia(
            url: file.path,
            fileName: file.name,
            type: MediaType.image,
          ),
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
