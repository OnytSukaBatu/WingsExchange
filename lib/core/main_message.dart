abstract class MainMessage {
  final String message;
  const MainMessage(this.message);
}

class MsgFailure extends MainMessage {
  MsgFailure(String msg) : super(msg);
}
