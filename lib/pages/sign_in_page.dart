import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../repositories/genre_repository.dart';
import '../repositories/task_repository.dart';
import '../utils/authentication.dart';
import '../widgets/google_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  final GenreRepository genreRepository;
  final TaskRepository taskRepository;

  const SignInPage(
      {super.key, required this.genreRepository, required this.taskRepository});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton(
                      genreRepository: widget.genreRepository,
                      taskRepository: widget.taskRepository,
                    );
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CupertinoColors.systemBlue,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
