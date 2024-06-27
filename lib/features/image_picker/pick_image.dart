



import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? selectedImage;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: selectedImage != null
                      ? FileImage(selectedImage!)
                      : const NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                        ) as ImageProvider,
                ),
              ),
            ),
            Positioned(
              bottom: -5,
              left: 125,
              child: IconButton(
                onPressed: () {
                  showImagePickerOption(context);
                },
                icon: const Icon(Icons.add_a_photo, size: 50,),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      selectedImage = File(pickedFile.path);
    });

    await uploadImageToFirestore(selectedImage!);
  }

  Future<void> uploadImageToFirestore(File image) async {
    try {
      String fileName = image.path.split('/').last;
      Reference ref = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(image);

      await uploadTask.whenComplete(() => null);

      String imageUrl = await ref.getDownloadURL();
      print('************Image uploaded to Firestore****************: $imageUrl');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Image uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error uploading image to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to upload image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}




// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ApiService {
//   final Dio _dio = Dio();

//   Future<bool> uploadImage(File image) async {
//     try {
//       String fileName = image.path.split('/').last;

//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(image.path, filename: fileName),
//       });

//       Response response = await _dio.post(
//         "https://yourapiendpoint.com/upload", 
//         data: formData,
//         options: Options(
//           headers: {
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         print("Image uploaded successfully: ${response.data}");
//         return true;
//       } else {
//         print("Failed to upload image: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//       return false;
//     }
//   }
// }





// class PickImage extends StatefulWidget {
//   const PickImage({super.key});

//   @override
//   State<PickImage> createState() => _PickImageState();
// }

// class _PickImageState extends State<PickImage> {
//   Uint8List? _image;
//   File? selectedImage;
//   final ApiService _apiService = ApiService(); 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[100],
//       body: Center(
//         child: Stack(
//           children: [
//             Container(
//               width: 300,
//               height: 400,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: _image != null
//                       ? MemoryImage(_image!)
//                       : const NetworkImage(
//                           "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
//                         ) as ImageProvider,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -5,
//               left: 125,
//               child: IconButton(
//                 onPressed: () {
//                   showImagePickerOption(context);
//                 },
//                 icon: const Icon(Icons.add_a_photo, size: 50,),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void showImagePickerOption(BuildContext context) {
//     showModalBottomSheet(
//       backgroundColor: Colors.blue[100],
//       context: context,
//       builder: (builder) {
//         return Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height / 4.5,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       _pickImageFromGallery();
//                     },
//                     child: const SizedBox(
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.image,
//                             size: 70,
//                           ),
//                           Text("Gallery")
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       _pickImageFromCamera();
//                     },
//                     child: const SizedBox(
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.camera_alt,
//                             size: 70,
//                           ),
//                           Text("Camera")
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _pickImageFromGallery() async {
//     final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (returnImage == null) return;
//     setState(() {
//       selectedImage = File(returnImage.path);
//       _image = File(returnImage.path).readAsBytesSync();
//     });
//     Navigator.of(context).pop();
//     if (selectedImage != null) {
//       bool success = await _apiService.uploadImage(selectedImage!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(success ? 'Image uploaded successfully' : 'Failed to upload image'),
//           backgroundColor: success ? Colors.green : Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (returnImage == null) return;
//     setState(() {
//       selectedImage = File(returnImage.path);
//       _image = File(returnImage.path).readAsBytesSync();
//     });
//     Navigator.of(context).pop();
//     if (selectedImage != null) {
//       bool success = await _apiService.uploadImage(selectedImage!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(success ? 'Image uploaded successfully' : 'Failed to upload image'),
//           backgroundColor: success ? Colors.green : Colors.red,
//         ),
//       );
//     }
//   }
// }
