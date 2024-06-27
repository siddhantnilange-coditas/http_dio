// import 'package:flutter/material.dart';
// import 'package:http_dio/core/services/local_auth.dart';
// import 'package:local_auth/local_auth.dart';
// import 'home_page.dart';

// class AuthPage extends StatefulWidget {
//   @override
//   _AuthPageState createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   bool authenticated= false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Authenticate'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: ()async{
//             final authenticate= await LocalAuth.authenticate();
//             setState(() {
//               authenticated=authenticate;
//             });
//           },
//           child: Text('Authenticate'),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http_dio/core/services/local_auth.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _authenticated = false;

  Future<void> _authenticate() async {
    bool authenticated = await LocalAuth.authenticate();
    if (!mounted) return;

    setState(() {
      _authenticated = authenticated;
      if (_authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticate'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: Text('Authenticate'),
        ),
      ),
    );
  }
}
