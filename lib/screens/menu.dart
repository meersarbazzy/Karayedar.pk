import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karayedar_pk/screens/homescreen.dart';
import 'package:karayedar_pk/screens/landlord_homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:karayedar_pk/screens/myproperties_screen.dart';
import 'package:karayedar_pk/screens/profile_page.dart';
import 'package:karayedar_pk/screens/realtorscreen.dart';
import 'package:karayedar_pk/screens/signinscreen.dart';
import 'package:karayedar_pk/user/data/remote_data_source/firebase_remote_data_source_impl.dart';
import 'package:karayedar_pk/user/presentation/cubit/auth/auth_cubit.dart';

import '../chat/chat/chat_page.dart';

class CustomDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final db = UserFirebaseRemoteDataSourceImpl();

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(currentUser?.displayName ?? "John Doe"),
            accountEmail: Text(currentUser?.email ?? "john.doe@example.com"),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(currentUser?.photoURL ?? "assets/images/profile_image.jpg"),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF42210B),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Tenant Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => TenantHomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text("Landlord Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => LandlordHomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Realtor"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => RealtorScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.apartment), // Using apartment icon for properties
            title: Text("My Properties"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPropertiesScreen()));

              // Note: Add the appropriate navigation action here for "My Properties"
              // For now, I'm leaving it blank as you haven't provided specific details.
            },
          ),
          ListTile(
            leading: Icon(Icons.apartment), // Using apartment icon for properties
            title: Text("Messages"),
            onTap: () async{
              final uid = await db.getCurrentUid();
              // Navigator.pop(context);
               Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(uid: uid)));

              // Note: Add the appropriate navigation action here for "My Properties"
              // For now, I'm leaving it blank as you haven't provided specific details.
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {

              BlocProvider.of<AuthCubit>(context).loggedOut();

            },
          ),
        ],
      ),
    );
  }
}
