import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
import 'package:flutter_codelabs/yes_no_selection.dart';
import 'package:provider/provider.dart';          // new

import 'app_state.dart';   
import 'guest_book.dart';                          // new
import 'src/authentication.dart';                 // new
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Meetup'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),
          // Add from here
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          // to here
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("Qué estaremos haciendo"),
          const Paragraph(
            '¡Únase a nosotros por un día lleno de talleres de Firebase y pizza!',
          ),
         // Add the following two lines.
          const Header('Discussion'),
          // ignore: avoid_print
          GuestBook(addMessage: (message) => print(message), messages: const [],),
          Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              switch (appState.attendees) {
                1 => const Paragraph('1 person going'),
                >= 2 => Paragraph('${appState.attendees} people going'),
                _ => const Paragraph('No one going'),
              },
              if (appState.loggedIn) ...[
                YesNoSelection(
                      state: appState.attending,
                      onSelection: (attending) => appState.attending = attending,
                    ),
                const Header('Discussion'),
                GuestBook(
                  addMessage: (message) =>
                      appState.addMessageToGuestBook(message),
                  messages: appState.guestBookMessages, // new
                ),
              ],
            ],
          ),
        ),
        ],
      ),
    );
  }
}