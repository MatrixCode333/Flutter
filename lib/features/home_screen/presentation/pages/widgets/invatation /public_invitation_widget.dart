import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PublicInvitationScreen extends StatefulWidget {
  final String userId; // ✅ only userId needed

  const PublicInvitationScreen({
    super.key,
    required this.userId,
  });

  @override
  State<PublicInvitationScreen> createState() =>
      _PublicInvitationScreenState();
}

class _PublicInvitationScreenState
    extends State<PublicInvitationScreen> {
  List<Map<String, dynamic>> invitationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInvitations();
  }

  Future<void> loadInvitations() async {
    try {
      // ✅ Fetch all invitations for this userId directly
      final snapshot = await FirebaseDatabase.instance
          .ref("users")
          .child(widget.userId)
          .child("invitations")
          .get();

      if (snapshot.exists) {
        final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

        setState(() {
          invitationList = data.values
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("ERROR => $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (invitationList.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Invitations Found")),
      );
    }

    // If user has multiple invitations, show all in a PageView
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: invitationList.length,
        itemBuilder: (context, pageIndex) {
          final invitation = invitationList[pageIndex];
          final galleryImages =
          List<String>.from(invitation["gallery_images"] ?? []);

          return SingleChildScrollView(
            child: Column(
              children: [
                // BANNER IMAGE
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: Image.memory(
                    base64Decode(invitation["banner_image"]),
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  invitation["groom_name"] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                const Text("&",
                    style: TextStyle(color: Colors.white, fontSize: 22)),
                const SizedBox(height: 10),

                Text(
                  invitation["bride_name"] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  invitation["venue"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 20),
                ),

                const SizedBox(height: 10),

                Text(
                  invitation["address"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 16),
                ),

                const SizedBox(height: 20),

                Text(
                  invitation["date"] ?? "",
                  style: const TextStyle(
                      color: Colors.pink, fontSize: 18),
                ),

                const SizedBox(height: 30),

                // GALLERY
                if (galleryImages.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: galleryImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 180,
                          margin: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(
                              base64Decode(galleryImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Page indicator (if multiple invitations)
                if (invitationList.length > 1) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      invitationList.length,
                          (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == pageIndex ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == pageIndex
                              ? Colors.pink
                              : Colors.white38,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}