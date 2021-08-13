import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/chat_provider.dart';
import 'package:kilifi_county_admin/providers/post_provider.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:kilifi_county_admin/screen/auth_screen.dart';
import 'package:kilifi_county_admin/screen/chat/chat.dart';

import 'package:kilifi_county_admin/screen/chat/widget/chat_profile.dart';
import 'package:kilifi_county_admin/screen/chat/widget/chatscreen.dart';
import 'package:kilifi_county_admin/screen/dashboard/widgets/new_users.dart';
import 'package:kilifi_county_admin/screen/drawer.dart';

import 'package:kilifi_county_admin/screen/news/add_article.dart';
import 'package:kilifi_county_admin/screen/news/edit_article.dart';
import 'package:kilifi_county_admin/screen/news/news_details_screen.dart';
import 'package:kilifi_county_admin/screen/start_screen.dart';
import 'package:kilifi_county_admin/screen/user_management/user_management.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UsersProvider()),
        ChangeNotifierProvider.value(value: ChatProvider()),
        ChangeNotifierProvider.value(value: PostProvider()),
      ],
      child: MaterialApp(
        title: 'Kilifi County Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            focusColor: kBackground,
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme,
            )),
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (ctx, snapshot) => snapshot.hasData ? Home() : StartScreen(),
        // ),

        home: Home(),

        routes: {
          AddArticle.routeName: (ctx) => AddArticle(),
          ChatProfile.routeName: (ctx) => ChatProfile(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
          UserManagement.routeName: (ctx) => UserManagement(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          NewsDetailsScreen.routeName: (ctx) => NewsDetailsScreen(),
          EditArticle.routeName: (ctx) => EditArticle(),
        },
      ),
    );
  }
}
