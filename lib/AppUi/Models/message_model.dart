enum MessageType { text, image, file, voice }

class Message {
  final String text;
  final String? path; 
  final MessageType type;
  final bool isUser;
  final int? audioDurationMs; 
  final String? fileName; 

  Message({
    required this.text,
    this.path,
    required this.type,
    required this.isUser,
    this.audioDurationMs,
    this.fileName,
  });

  factory Message.textMsg(String text, {required bool isUser}) {
    return Message(text: text, type: MessageType.text, isUser: isUser);
  }

  factory Message.imageMsg({required String path, required bool isUser}) {
    return Message(text: "Image", path: path, type: MessageType.image, isUser: isUser);
  }

  factory Message.fileMsg({required String path, required String fileName, required bool isUser}) {
    return Message(text: fileName, path: path, type: MessageType.file, isUser: isUser, fileName: fileName);
  }

  factory Message.voiceMsg({required String path, required int durationMs, required bool isUser}) {
    return Message(text: "Voice Note", path: path, type: MessageType.voice, isUser: isUser, audioDurationMs: durationMs);
  }
}
