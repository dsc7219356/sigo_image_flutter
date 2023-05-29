import 'package:sigo_image_flutter/src/common/sigo_image_request.dart';


List<Map<String, dynamic>?> encodeRequests(List<SigoImageRequest> requests) {
  List<Map<String, dynamic>?> encodedTasks = requests
      .map<Map<String, dynamic>?>(
          (SigoImageRequest request) => request.encode())
      .toList();
  return encodedTasks;
}

abstract class SigoImageChannelImpl {
  void setup();

  void startImageRequests(List<SigoImageRequest> requests);

  void releaseImageRequests(List<SigoImageRequest> requests);
}

class SigoImageChannel {

  SigoImageChannelImpl? impl;

  void setup() {
    impl!.setup();
  }

  void startImageRequests(List<SigoImageRequest> requests) async {
    impl!.startImageRequests(requests);
  }

  void releaseImageRequests(List<SigoImageRequest> requests) async {
    impl!.releaseImageRequests(requests);
  }
}
