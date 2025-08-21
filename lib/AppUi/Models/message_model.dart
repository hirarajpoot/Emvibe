class Message {
  final String text;
  final bool isUser;
  final DateTime time;

  final String? audioPath;    
  final int? audioDurationMs; 

  Message({
    required this.text,
    required this.isUser,
    DateTime? time,
    this.audioPath,
    this.audioDurationMs,
  }) : time = time ?? DateTime.fromMillisecondsSinceEpoch(0);

  Message copyWith({
    String? text,
    bool? isUser,
    DateTime? time,
    String? audioPath,
    int? audioDurationMs,
  }) {
    return Message(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      time: time ?? this.time,
      audioPath: audioPath ?? this.audioPath,
      audioDurationMs: audioDurationMs ?? this.audioDurationMs,
    );
  }

  factory Message.textMsg(String text, {required bool isUser}) => Message(
        text: text,
        isUser: isUser,
        time: DateTime.now(),
      );

  factory Message.voiceMsg({
    required String path,
    required int durationMs,
    required bool isUser,
  }) =>
      Message(
        text: "🎧 Voice message",
        isUser: isUser,
        time: DateTime.now(),
        audioPath: path,
        audioDurationMs: durationMs,
      );
}
