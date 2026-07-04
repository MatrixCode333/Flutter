import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicInvitationScreen extends StatefulWidget {
  final String userId;

  const PublicInvitationScreen({
    super.key,
    required this.userId,
  });

  @override
  State<PublicInvitationScreen> createState() => _PublicInvitationScreenState();
}

class _PublicInvitationScreenState extends State<PublicInvitationScreen> {
  Map<String, dynamic>? invitationData;
  bool isLoading = true;
  String? debugErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadInvitation();
  }

  Future<void> _loadInvitation() async {
    // Safely trim and clear up any trailing parameters appended by web routers
    final cleanUserId = widget.userId.trim().replaceAll(RegExp(r'^/|/$'), '');

    try {
      final snapshot = await FirebaseDatabase.instance
          .ref("users")
          .child(cleanUserId)
          .child("invitation")
          .get();

      if (snapshot.exists && snapshot.value != null) {
        setState(() {
          invitationData = Map<String, dynamic>.from(snapshot.value as Map);
          isLoading = false;
        });
      } else {
        setState(() {
          debugErrorMessage = "No entry data found at path:\nusers/$cleanUserId/invitation";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        debugErrorMessage = "Firebase Exception:\n$e\n\nAttempted Path: users/$cleanUserId/invitation";
        isLoading = false;
      });
    }
  }

  String _formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      const days = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
      ];
      return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Handle Loading state smoothly
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    // 2. Safe local assignment for explicit type promotion (Eliminates the '!' crash completely)
    final invitation = invitationData;

    if (invitation == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    "Invitation Unavailable",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red.shade900),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    debugErrorMessage ?? "The invitation layout couldn't be loaded or is empty.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.red.shade800),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Beyond this point, 'invitation' is guaranteed non-nullable by Dart compiler
    final galleryImages = List<String>.from(invitation["gallery_images"] ?? []);
    final bannerImage = invitation["banner_image"] ?? "";
    final brideImage = invitation["bride_image"] ?? "";
    final groomImage = invitation["groom_image"] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Banner Image Header ──────────────────────────────────────────
            Stack(
              children: [
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: bannerImage.isNotEmpty
                      ? Image.memory(base64Decode(bannerImage), fit: BoxFit.cover)
                      : Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.landscape, size: 60, color: Colors.grey.shade400),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.transparent, Color(0x80FAFAFA), Color(0xFFFAFAFA)],
                        stops: [0.0, 0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Text(
              'T O G E T H E R   F O R E V E R',
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500, letterSpacing: 4, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 32),

            // ── Couple Circular Profile Avatars ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildCoupleAvatar(brideImage, isBride: true),
                        const SizedBox(height: 16),
                        Text(
                          invitation["bride_name"] ?? "",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('The Bride', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500, letterSpacing: 1)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text('&', style: GoogleFonts.playfairDisplay(fontSize: 32, color: Colors.grey.shade300, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildCoupleAvatar(groomImage, isBride: false),
                        const SizedBox(height: 16),
                        Text(
                          invitation["groom_name"] ?? "",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('The Groom', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            _buildMinimalistDivider(),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Together with their families\nrequest the pleasure of your company\nat the celebration of their marriage',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700, height: 1.8, letterSpacing: 0.2),
              ),
            ),
            const SizedBox(height: 40),

            // ── Elegant Venue & Date Details Box ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 32, offset: const Offset(0, 12))],
                ),
                child: Column(
                  children: [
                    Text(
                      'S A V E   T H E   D A T E',
                      style: GoogleFonts.inter(fontSize: 11, color: Theme.of(context).primaryColor, letterSpacing: 2, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatDateString(invitation["date"]),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, width: 100, color: Colors.grey.shade200),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.grey.shade400, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            invitation["venue"] ?? "",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      invitation["address"] ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),

            // ── Story Grid Gallery ───────────────────────────────────────────
            if (galleryImages.isNotEmpty) ...[
              Text('Our Moments', style: GoogleFonts.playfairDisplay(fontSize: 26, color: Colors.black87, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('A glimpse of our journey together', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500)),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 16, offset: const Offset(0, 8))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(base64Decode(galleryImages[index]), fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),
            ],

            _buildMinimalistDivider(),
            const SizedBox(height: 32),
            Text('With Love & Joy', style: GoogleFonts.playfairDisplay(fontSize: 18, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(
              '${invitation["groom_name"] ?? ""} & ${invitation["bride_name"] ?? ""}',
              style: GoogleFonts.playfairDisplay(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildCoupleAvatar(String base64Image, {required bool isBride}) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(4),
      child: ClipOval(
        child: base64Image.isNotEmpty
            ? Image.memory(base64Decode(base64Image), fit: BoxFit.cover)
            : Container(
          color: Colors.grey.shade100,
          child: Icon(isBride ? Icons.face_3_outlined : Icons.face_outlined, color: Colors.grey.shade400, size: 40),
        ),
      ),
    );
  }

  Widget _buildMinimalistDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 40, height: 1, color: Colors.grey.shade300),
        const SizedBox(width: 12),
        Icon(Icons.favorite, size: 10, color: Colors.grey.shade300),
        const SizedBox(width: 12),
        Container(width: 40, height: 1, color: Colors.grey.shade300),
      ],
    );
  }
}