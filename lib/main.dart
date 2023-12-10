import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karayedar_pk/chat/communication/communication_cubit.dart';
import 'package:karayedar_pk/chat/my_chat/my_chat_cubit.dart';
import 'package:karayedar_pk/chat/my_chat/my_chat_cubit.dart';
import 'package:karayedar_pk/chat/single_user/single_user_cubit.dart';
import 'package:karayedar_pk/screens/homescreen.dart';
import 'package:karayedar_pk/screens/signinscreen.dart';
import 'package:karayedar_pk/screens/splashscreen.dart';
import 'package:karayedar_pk/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:karayedar_pk/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:karayedar_pk/user/presentation/cubit/credentials/credential_cubit.dart';
import 'package:karayedar_pk/user/presentation/cubit/credentials/credential_cubit.dart';
import 'package:karayedar_pk/user/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:karayedar_pk/user/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:karayedar_pk/user/presentation/cubit/user/get_users_cubit.dart';
import 'package:karayedar_pk/user/presentation/cubit/user/get_users_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommunicationCubit>(create: (_) => CommunicationCubit()),
        BlocProvider<MyChatCubit>(create: (_) => MyChatCubit()),
        BlocProvider<SingleUserCubit>(create: (_) => SingleUserCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..appStarted()),
        BlocProvider<CredentialCubit>(create: (_) => CredentialCubit()),
        BlocProvider<GetSingleUserCubit>(create: (_) => GetSingleUserCubit()),
        BlocProvider<GetUsersCubit>(create: (_) => GetUsersCubit()),
      ],
      child: MaterialApp(
        title: 'My App',
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                return TenantHomeScreen();
              } else {
                return SplashScreen();
              }
            });
          }
        },
      ),
    );
  }
}
