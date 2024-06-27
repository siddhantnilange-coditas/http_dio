// import 'package:alice/alice.dart';
import 'package:alice/alice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dio/core/services/api_services.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_bloc.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_events.dart';
import 'package:http_dio/features/show_data/presentation/pages/home_page.dart';
import 'package:http_dio/firebase_options.dart';

Alice alice=Alice(showNotification: true);
Future<void> main() async {
  final ApiService apiService = ApiService();
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  MyApp({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc(apiService: apiService)..add(FetchUsers()),
        ),
       
      ],
      child: MaterialApp(
        navigatorKey: alice.getNavigatorKey(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http_dio/presentation/api_services.dart';
// import 'package:http_dio/presentation/bloc/dio_bloc.dart';
// import 'package:http_dio/presentation/pages/home_page.dart';

// void main() {
//   final ApiService apiService = ApiService();

//   runApp(MyApp(apiService: apiService));
// }

// class MyApp extends StatelessWidget {
//   final ApiService apiService;

//   MyApp({required this.apiService});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<UserBloc>(
//           create: (context) => UserBloc(apiService: apiService)..add(FetchUsers()),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: HomePage(),
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http_dio/presentation/api_services.dart';
// import 'package:http_dio/presentation/bloc/dio_bloc.dart';
// import 'package:http_dio/presentation/bloc/dio_events.dart';
// import 'package:http_dio/presentation/pages/home_page.dart';

// void main() {

//   runApp(MyApp());
//   // runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key, });

//   @override
//  Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Dio BLoC Example',
//       home: 
//         // create: (context) => UserBloc(apiService: ApiService())..add(FetchUsers()),
//         HomePage(),
//       // ), 
//     );
//   }
// }
