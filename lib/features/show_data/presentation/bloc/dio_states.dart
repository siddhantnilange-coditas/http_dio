// bloc/product_state.dart
import 'dart:io';

import 'package:http_dio/features/show_data/domain/data_model.dart';

abstract class UserState {
  const UserState();


}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;

  const UserLoaded({required this.users});


}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});


}

class NewUserAddedState extends UserState{
  
}

class UserPostSuccess extends UserState {



}

class FileLoadedSuccessState extends UserState{
  FileLoadedSuccessState({required this.response});
final File? response;

}

class DownloadFilePageState extends UserState{}


