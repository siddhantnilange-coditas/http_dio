// bloc/product_event.dart

import 'package:http_dio/features/show_data/domain/data_model.dart';

abstract class UserEvent {
  const UserEvent();


}

class FetchUsers extends UserEvent {}
// class PostUserEvent extends UserEvent {}
class PostUserEvent extends UserEvent {
    const PostUserEvent({required this.postData});
  final User postData;


  

}


class DownloadFileEvent extends UserEvent{
  DownloadFileEvent({required this.url, required this.fileName});
  final String url;
    final String fileName;

}