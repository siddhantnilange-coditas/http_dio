


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_bloc.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_events.dart';
import 'package:http_dio/features/show_data/domain/data_model.dart';

void showPostUserDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Post User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Id'),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User Id'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String title = titleController.text;
              String body = bodyController.text;
              int userId = int.tryParse(userIdController.text) ?? 0;
              int id = int.tryParse(idController.text) ?? 0;

              User postData = User(
                id: id,
                title: title,
                body: body,
                userId: userId,
              );
              BlocProvider.of<UserBloc>(context).add(
                PostUserEvent(postData: postData),
              );
              Navigator.of(context).pop();
            },
            child: Text('Post'),
          ),
        ],
      );
    },
  );
}












// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http_dio/presentation/bloc/dio_bloc.dart';
// import 'package:http_dio/presentation/bloc/dio_events.dart';
// import 'package:http_dio/presentation/bloc/dio_states.dart';
// import 'package:http_dio/presentation/data_model.dart';

// void showPostUserDialog(BuildContext context) {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController bodyController = TextEditingController();

//   final TextEditingController userIdController = TextEditingController();
//   final TextEditingController idController = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Post User'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             TextField(
//               controller: idController,
//               decoration: InputDecoration(labelText: 'Id'),
//             ),
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: bodyController,
//               decoration: InputDecoration(labelText: 'Body'),
//             ),
//             TextField(
//               controller: userIdController,
//               decoration: InputDecoration(labelText: 'User Id'),
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               String title = titleController.text;
//               String body = bodyController.text;
//               int userId = int.tryParse(userIdController.text) ?? 0;
//               int id = int.tryParse(idController.text) ?? 0;

//               User postData = User(
//                 id: id,
//                 title: title,
//                 body: body,
//                 userId: userId,
//               );
//               BlocProvider.of<UserBloc>(context).add(
//                 PostUserEvent(postData: postData),
//               );
//               Navigator.of(context).pop();
//             },
//             child: Text('Post'),
//           ),
//         ],
//       );
//     },
//   );
// }
