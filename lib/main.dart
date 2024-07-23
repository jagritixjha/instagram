import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/view/navigation_screen/navigation_screen.dart';
import 'package:instagram/view/responsive_layout/responsive_layout_screen.dart';
import 'package:instagram/view/signin_screen/signin.dart';
import 'package:instagram/view/signup_screen/signup.dart';
import 'package:instagram/view/web_view/main_screen.dart';
import 'package:instagram/widgets/small_text.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          // brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ResponsiveLayout(
                mobileScreen: SignInScreen(),
                webScreen: const WebView(),
              );
            } else if (snapshot.hasError) {
              return const SmallText(text: 'connection failed');
            } else if (!snapshot.hasData) {
              return SignUpScreen();
            } else {
              return BottomNavigationScreen();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: Colors.orange.shade700,
            );
          } else if (!snapshot.hasData) {
            return SignUpScreen();
          } else {
            return Center(
              child: SmallText(
                text: snapshot.error.toString(),
              ),
            );
          }
        },
      ),
    );
  }
}
