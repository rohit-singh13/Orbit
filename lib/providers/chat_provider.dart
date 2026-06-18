import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:orbit/models/message_model.dart';
import 'package:orbit/services/chat_services.dart';

class ChatProvider extends ChangeNotifier{
  final ChatServices _chatServices = ChatServices();

  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  bool _isSending = false;
  bool get isSending => _isSending;

  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  void listenMessages(String otherUserId) {
    _messagesSubscription?.cancel();

    _messagesSubscription = _chatServices.streamMessages(otherUserId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text
}) async {
    try {
      _isSending = true;
      notifyListeners();

      await _chatServices.sendMessage(receiverId: receiverId, text: text);
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
  void clearChat() {
    _messagesSubscription?.cancel();
    _messages = [];
    _isSending = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}