import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dio/core/services/api_services.dart';
import 'package:http_dio/features/show_data/domain/data_model.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_events.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_states.dart';
import 'package:http_dio/main.dart';
import 'package:path_provider/path_provider.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;
// Alice alice=Alice();

  UserBloc({required this.apiService}) : super(UserInitial()) {
    on<FetchUsers>(fetchUsers);
    on<PostUserEvent>(postUserEvent);
    on<DownloadFileEvent>(downloadFileEvent);
  }

  FutureOr<void> fetchUsers(UserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final responseOfFetching = await apiService.fetchUsers();
                    alice.onHttpResponse(responseOfFetching);
  //           // setStaus(1);
  if (responseOfFetching.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(responseOfFetching.body);
    List<User> users = jsonResponse.map((user) => User.fromJson(user)).toList();
          emit(UserLoaded(users: users));

        

  } else {
    throw Exception('Failed to load users');
  }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> postUserEvent(
      PostUserEvent event, Emitter<UserState> emit) async {
    try {
      final responseOfPosting = await apiService.postUser(event.postData);
                          alice.onHttpResponse(responseOfPosting);
            emit(NewUserAddedState());
    //     if (responseOfPosting.statusCode == 200) {
    //   List<dynamic> jsonResponse = jsonDecode(responseOfPosting.body);
    //   List<User> users = jsonResponse.map((user) => User.fromJson(user)).toList();
      
    //   emit(UserLoaded(users: users));
    // } else {
    //   throw Exception('Failed to load users');
    // }

    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }


  // Future<void> postUserEvent(
  //     PostUserEvent event, Emitter<UserState> emit) async {
  //   try {
  //     final response = await apiService.postUser(event.postData);
  //     if (response.statusCode == 201) {
  //       final users = await apiService.fetchUsers();
  //       emit(UserLoaded(users: users));
  //     } else {
  //       emit(UserError(message: 'Failed to post user: ${response.statusCode}'));
  //     }
  //   } catch (e) {
  //     emit(UserError(message: e.toString()));
  //   }
  // }
 Future<void> downloadFileEvent(
      DownloadFileEvent event, Emitter<UserState> emit) async {
    try {
        final response =
      await apiService.downloadFile(event.url, event.fileName);

      emit(FileLoadedSuccessState(response: response));

      // return response;
   
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // Future<void> downloadFileEvent(
  //     DownloadFileEvent event, Emitter<UserState> emit) async {
  //   try {
  //    //final users = await apiService.fetchUsers();

  //     // emit(UserLoading());
  //     // final response =
  //     await apiService.downloadFile(event.url, event.fileName);
  //     emit(DownloadFilePageState());
  //     // if (response.statusCode == 200) {
  //     //emit(FileLoadedSuccessState());
  //     // emit(UserLoaded(users: users));

  //     // }
  //     // else {
  //     // emit(UserError(
  //     //     message: 'Failed to download file: ${response.statusCode}'));
  //     // }
  //   } catch (e) {
  //     emit(UserError(message: e.toString()));
  //   }
  // }
}




































// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http_dio/presentation/api_services.dart';
// import 'package:http_dio/presentation/bloc/dio_events.dart';
// import 'package:http_dio/presentation/bloc/dio_states.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final ApiService apiService;

//   UserBloc({required this.apiService}) : super(UserInitial()) {
//     on<FetchUsers>(fetchUsers);
//     on<PostUserEvent>(postUserEvent);
//   }

//   FutureOr<void> fetchUsers(UserEvent event, Emitter<UserState> emit) async {
//     emit(UserLoading());
//     try {
//       final users = await apiService.fetchUsers();
//       emit(UserLoaded(users: users));
//     } catch (e) {
//       emit(UserError(message: e.toString()));
//     }
//   }

//   Future<void> postUserEvent(PostUserEvent event, Emitter<UserState> emit) async {
//     try {
//       final response = await apiService.postUser(event.postData);
//       if (response.statusCode == 201) {
//         emit(UserPostSuccess());
//       } else {
//         emit(UserError(message: 'Failed to post user: ${response.statusCode}'));
//       }
//     } catch (e) {
//       emit(UserError(message: e.toString()));
//     }
//   }
// }

// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http_dio/presentation/api_services.dart';
// import 'package:http_dio/presentation/bloc/dio_events.dart';
// import 'package:http_dio/presentation/bloc/dio_states.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//     final ApiService apiService;

//   UserBloc({required this.apiService}) : super((UserInitial())) {
//     on<FetchUsers>(fetchUsers);
//         on<PostUserEvent>(postUserEvent);

//   }

//   FutureOr<void> fetchUsers(UserEvent event, Emitter<UserState> emit) async{
//       emit(UserLoading());
//       try {
//         final user = await apiService.fetchUsers();
//         emit(UserLoaded(users: user));
//       } catch (e) {
//         emit(UserError(message: e.toString()));
//       }

//   }

// Future<void> postUserEvent(PostUserEvent event, Emitter<UserState> emit) async {
//   // emit(UserLoading());
//   try {
//     await apiService.postUser(event.postData);
//     emit(UserPostSuccess());
//   } catch (e) {
//     // emit(UserError(message: e.toString()));
//   }
// }

//   // FutureOr<void> postUserEvent(PostUserEvent event, Emitter<UserState> emit) async{
//   //     try {
//   //       await apiService.postUser(event.postData);
//   //       // emit(ProductLoaded(users: user ));
//   //     } catch (e) {
//   //       emit(ProductError(message: e.toString()));
//   //     }
//   // }

// }
