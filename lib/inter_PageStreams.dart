import 'dart:async';

var streamController = StreamController<int>();
class OpStream {

  Stream<int> get opStream {
    return streamController.stream;
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