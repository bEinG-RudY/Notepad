import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepad/pages/forgot_password_page.dart';
import 'package:notepad/pages/note_editor.dart';
import 'package:notepad/pages/note_reader.dart';
import 'package:notepad/services/app_style.dart';
import 'package:notepad/services/note_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Notes',
          style:
              TextStyle(color: AppStyle.mainColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[50],
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your recent notes',
              style: GoogleFonts.roboto(
                  color: AppStyle.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        children: snapshot.data!.docs
                            .map((note) => noteCard(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NoteReader(note)));
                                }, note))
                            .toList());
                  }
                  return Text(
                    "there's  no notes",
                    style: GoogleFonts.nunito(color: Colors.white),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: bottomNavbar(context),
    );
  }
}

Container bottomNavbar(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(8),
    height: 60,
    decoration: BoxDecoration(
      boxShadow:
      [BoxShadow(spreadRadius:8,blurRadius:7,color: AppStyle.mainColor.withOpacity(1))],
      color: Colors.lightBlue[50],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          enableFeedback: false,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> LogOut()));
          },
          icon: LogOut()==true
              ? const Icon(
                  Icons.space_dashboard_rounded,
                  color: Colors.white,
                  size: 35,
                )
              : const Icon(
                  Icons.space_dashboard_outlined,
                  color: Colors.black,
                  size: 35,
                ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NoteEditor()));
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppStyle.mainColor,
              shape: BoxShape.circle
            ),
            child: Icon(Icons.add,color: Colors.white,
            ),
          ),
        ),
        IconButton(
          enableFeedback: false,
          onPressed: () {},
          icon: ForgotPasswordPage() == true
              ? const Icon(
            Icons.person_outline_rounded,
            color: Colors.white,
            size: 35,
          )
              : const Icon(
            Icons.person_outline_outlined,
            color: Colors.black,
            size: 35,
          ),
        ),
      ],
    ),
  );
}

class LogOut extends StatefulWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  State<LogOut> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
          FirebaseAuth.instance.signOut();
        },
          icon: Icon(Icons.logout_rounded),


        ),
      ),
    );
  }
}

