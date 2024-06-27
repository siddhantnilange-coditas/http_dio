
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dio/features/image_picker/pick_image.dart';
import 'package:http_dio/features/location/presentation/pages/get_location.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_bloc.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_events.dart';
import 'package:http_dio/features/show_data/presentation/bloc/dio_states.dart';
import 'package:http_dio/features/show_data/presentation/pages/post_dialog.dart';
import 'package:http_dio/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    String _status='';
  // void callOne()async{
  //   final response = await http.get
  // }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(onPressed: (){
            alice.showInspector();
          }, icon: Icon(Icons.run_circle_outlined)),
          IconButton(onPressed: (){
            alice.showInspector();
          }, icon: Icon(Icons.show_chart_outlined)),
        ],
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Users Loaded Sucessfully')),
            );
          } 
          else if(state is NewUserAddedState){
               ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Users Added Sucessfully')),
              
            );
          } 
          else if (state is FileLoadedSuccessState) {
            // if(state.response == null){
            //   return;
            // }
            print('Path: ${state.response?.path}');
            // OpenFile.open(state.response?.path);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File Downloaded Sucessfully')),
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) =>
              current is UserLoading ||
              current is UserLoaded ||
              current is UserError,
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }
           else if (state is UserLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return Card(
                    color: const Color.fromARGB(255, 241, 238, 238),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.id.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            maxLines: 2,
                            user.body,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            user.userId.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            } else
              return Center(child: Text('page not found'));
          },
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
            child: const Icon(
              Icons.add,
              color: Colors.green,
            ),
            onPressed: () {
              showPostUserDialog(context);
            }),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          child: const Icon(
            Icons.download,
            color: Colors.blue,
          ),
          onPressed: () {
            openFile(
                url:
                    'https://cdn.builder.io/api/v1/image/assets%2FYJIGb4i01jvw0SRdL5Bt%2F869bfbaec9c64415ae68235d9b7b1425',
                fileName: 'sample_image.jpg',
                context: context);
          },
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
            child: const Icon(
              Icons.camera,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PickImage()));
            }),
             SizedBox(
          width: 20,
        ),
           ElevatedButton(
            child: const Icon(
              Icons.location_pin,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GetLocation()));
                                    // .push(MaterialPageRoute(builder: (context) => ButtonScreen()));

            }),
      ]),

      // FloatingActionButton(
      //   onPressed: () {
      //     showPostUserDialog(context);
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void openFile(
      {required String url, required String fileName, context}) async {
    BlocProvider.of<UserBloc>(context).add(DownloadFileEvent(
      url: url,
      fileName: fileName,
    ));
  }
}
  // BlocProvider.of<UserBloc>(context).add(DownloadFileEvent(
  //               url: 'https://www.buds.com.ua/images/Lorem_ipsum.pdf',
  //               fileName: 'video.mp4',
  //             )
              // );
// void downloadVideo() async {

//   var dir = await getExternalStorageDirectory();

//                       final dio = Dio();

//                       dio.download(
//                           'https://cdn.builder.io/api/v1/image/assets%2FYJIGb4i01jvw0SRdL5Bt%2F869bfbaec9c64415ae68235d9b7b1425',
//                           '${dir!.path}/video.mp4', // saving path, I'm trying to save it in phone gallery
//                           onReceiveProgress: (actualBytes, totalBytes){
//                             var percentage = actualBytes/totalBytes*100;

                    
//                           }
//                       );
// }