import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Clipboard functionality
import 'package:google_fonts/google_fonts.dart';

class InvitationPreviewScreen extends StatefulWidget {
  final String brideName;
  final String groomName;
  final String venue;
  final String address;
  final String mapUrl;
  final DateTime date;
  final String bannerImage;
  final String brideImage;
  final String groomImage;
  final String invitationLink; // ← Receives the link from BlOC
  final List<String> galleryImages;

  const InvitationPreviewScreen({
    super.key,
    required this.brideName,
    required this.groomName,
    required this.venue,
    required this.address,
    required this.mapUrl,
    required this.date,
    required this.bannerImage,
    required this.brideImage,
    required this.groomImage,
    required this.invitationLink,
    required this.galleryImages,
  });

  @override
  State<InvitationPreviewScreen> createState() =>
      _InvitationPreviewScreenState();
}

class _InvitationPreviewScreenState extends State<InvitationPreviewScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ── Show modern alert dialog to copy link ──────────────────────────────────
  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Share Invitation',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Copy your digital invitation link below to share it with your guests.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              // Link field container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.invitationLink,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.link, size: 18, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: widget.invitationLink));
                  if (!context.mounted) return;
                  Navigator.pop(dialogContext); // Close Dialog

                  // Show clean confirmation SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Link copied to clipboard!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.black87,
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text(
                  'Copy Link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Clean off-white background

      // ── Modern Link Floating Action Button ──────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showShareDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.share_outlined, size: 20),
        label: Text(
          'Share Link',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Banner ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: 380,
                    width: double.infinity,
                    child: widget.bannerImage.isNotEmpty
                        ? Image.memory(
                      base64Decode(widget.bannerImage),
                      fit: BoxFit.cover,
                    )
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
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Color(0x80FAFAFA),
                            Color(0xFFFAFAFA),
                          ],
                          stops: [0.0, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Modern Back button
                  Positioned(
                    top: 48,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Clean badge
                  Positioned(
                    top: 52,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Wedding Invitation',
                        style: GoogleFonts.inter(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Main Content ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: const Color(0xFFFAFAFA),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ── Together Forever text ────────────────────────────
                    Text(
                      'T O G E T H E R   F O R E V E R',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Couple Photos Row ────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bride
                          Expanded(
                            child: Column(
                              children: [
                                _couplePhoto(widget.brideImage, isBride: true),
                                const SizedBox(height: 16),
                                Text(
                                  widget.brideName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'The Bride',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Ampersand
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  '&',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 32,
                                    color: Colors.grey.shade300,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Groom
                          Expanded(
                            child: Column(
                              children: [
                                _couplePhoto(widget.groomImage, isBride: false),
                                const SizedBox(height: 16),
                                Text(
                                  widget.groomName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'The Groom',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Invitation text ──────────────────────────────────
                    _minimalistDivider(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Together with their families\nrequest the pleasure of your company\nat the celebration of their marriage',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.8,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Date Card (Modern Style) ─────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(12),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'S A V E   T H E   D A T E',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Theme.of(context).primaryColor,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _formatDate(widget.date),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              height: 1,
                              width: 100,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    widget.venue,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.address,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // ── Gallery ──────────────────────────────────────────
                    if (widget.galleryImages.isNotEmpty) ...[
                      Text(
                        'Our Moments',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A glimpse of our journey together',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: widget.galleryImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(10),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(
                                  base64Decode(widget.galleryImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],

                    // ── Footer ───────────────────────────────────────────
                    _minimalistDivider(),
                    const SizedBox(height: 32),
                    Text(
                      'With Love & Joy',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.groomName} & ${widget.brideName}',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 100), // Added bottom spacing for FAB clearance
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _couplePhoto(String base64Image, {required bool isBride}) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: ClipOval(
        child: base64Image.isNotEmpty
            ? Image.memory(base64Decode(base64Image), fit: BoxFit.cover)
            : Container(
          color: Colors.grey.shade100,
          child: Icon(
            isBride ? Icons.face_3_outlined : Icons.face_outlined,
            color: Colors.grey.shade400,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _minimalistDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 1,
          color: Colors.grey.shade300,
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.favorite,
          size: 10,
          color: Colors.grey.shade300,
        ),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}