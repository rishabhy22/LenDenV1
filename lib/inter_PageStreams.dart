import 'dart:async';
var acStreamController=StreamController<int>.broadcast();
var streamController = StreamController<int>();
class OpStream {

  Stream<int> get opStream {
    return streamController.stream;
  }
  Stream<int> get acOp
  {
    return acStreamController.stream;
  }
  void dispose()
  {
    streamController.close();
  }
}
StreamController<String> friendsStreamController=StreamController.broadcast();
class FriendOpStream {

  Stream<String> get friendOpStream{
    return friendsStreamController.stream;
  }

}

StreamController<String> sendData=StreamController<String>.broadcast();
class DataSharingStream{
  Stream<String> get sendString
  {
    return sendData.stream;
  }

}