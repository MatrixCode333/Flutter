import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicInvitationScreen extends StatefulWidget {
  final List<Map<String, dynamic>> invitations;

  const PublicInvitationScreen({super.key, required this.invitations});

  @override
  State<PublicInvitationScreen> createState() => _PublicInvitationScreenState();
}

class _PublicInvitationScreenState extends State<PublicInvitationScreen>
    with SingleTickerProviderStateMixin {
  static const Color _gold = Color(0xFFB8860B);
  static const Color _goldLight = Color(0xFFD4A843);
  static const Color _deepBrown = Color(0xFF1A0A05);
  static const Color _roseDust = Color(0xFFD4A0A0);
  static const Color _warmBrown = Color(0xFF8B6F5E);

  final PageController _pageController = PageController();
  int _currentPage = 0;

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
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.invitations.isEmpty) {
      return Scaffold(
        backgroundColor: _deepBrown,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _gold.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border,
                  color: _goldLight,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No Invitations Found',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No wedding invitations available',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _deepBrown,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.invitations.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, pageIndex) {
                final invitation = widget.invitations[pageIndex];
                final galleryImages = List<String>.from(
                  invitation['gallery_images'] ?? [],
                );

                return _buildInvitationPage(invitation, galleryImages);
              },
            ),

            // Page indicator (if multiple)
            if (widget.invitations.length > 1)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.invitations.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _currentPage
                            ? _goldLight
                            : Colors.white.withAlpha(60),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationPage(
      Map<String, dynamic> invitation,
      List<String> galleryImages,
      ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Banner ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Stack(
            children: [
              SizedBox(
                height: 380,
                width: double.infinity,
                child:
                (invitation['banner_image'] != null &&
                    (invitation['banner_image'] as String).isNotEmpty)
                    ? Image.memory(
                  base64Decode(invitation['banner_image'] as String),
                  fit: BoxFit.cover,
                )
                    : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF3D1A0A), Color(0xFF1A0A05)],
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Color(0x801A0A05),
                        Color(0xFF1A0A05),
                      ],
                      stops: [0.0, 0.4, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
              // Gold top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_gold, _goldLight, _gold],
                    ),
                  ),
                ),
              ),
              // Back button
              Positioned(
                top: 48,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withAlpha(40)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              // Invitation badge
              Positioned(
                top: 52,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _gold.withAlpha(200),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Wedding Invitation',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Content ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            color: _deepBrown,
            child: Column(
              children: [
                const SizedBox(height: 8),
                _ornamentalDivider(),
                const SizedBox(height: 24),

                Text(
                  'Together Forever',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: _goldLight,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Couple Photos ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _couplePhoto(
                              invitation['groom_image'] as String? ?? '',
                              isBride: false,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              invitation['groom_name'] as String? ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'The Groom',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: _roseDust,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              '&',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 36,
                                color: _goldLight,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            _couplePhoto(
                              invitation['bride_image'] as String? ?? '',
                              isBride: true,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              invitation['bride_name'] as String? ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'The Bride',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: _roseDust,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                _ornamentalDivider(),
                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Together with their families\nrequest the pleasure of your company\nat the celebration of their marriage',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withAlpha(178),
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Date & Venue Card ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: _gold.withAlpha(80)),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withAlpha(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Save The Date',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: _goldLight,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _formatDate(invitation['date'] as String? ?? ''),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                _gold.withAlpha(150),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: _roseDust,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                invitation['venue'] as String? ?? '',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          invitation['address'] as String? ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withAlpha(150),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // ── Gallery ────────────────────────────────────────────
                if (galleryImages.isNotEmpty) ...[
                  _ornamentalDivider(),
                  const SizedBox(height: 24),
                  Text(
                    'Our Moments',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A glimpse of our journey together',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: galleryImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _gold.withAlpha(60)),
                            boxShadow: [
                              BoxShadow(
                                color: _gold.withAlpha(30),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(
                              base64Decode(galleryImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 36),
                ],

                // ── Footer ─────────────────────────────────────────────
                _ornamentalDivider(),
                const SizedBox(height: 24),
                Text(
                  'With Love & Joy',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: _goldLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${invitation['groom_name'] ?? ''} & ${invitation['bride_name'] ?? ''}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _couplePhoto(String base64Image, {required bool isBride}) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _goldLight, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: _gold.withAlpha(60),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: base64Image.isNotEmpty
            ? Image.memory(base64Decode(base64Image), fit: BoxFit.cover)
            : Container(
          color: _warmBrown.withAlpha(60),
          child: Icon(
            isBride ? Icons.face_3 : Icons.face,
            color: _goldLight,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _ornamentalDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, _gold.withAlpha(150)],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('✦', style: TextStyle(color: _goldLight, fontSize: 14)),
        const SizedBox(width: 6),
        Text('❧', style: TextStyle(color: _roseDust, fontSize: 16)),
        const SizedBox(width: 6),
        Text('✦', style: TextStyle(color: _goldLight, fontSize: 14)),
        const SizedBox(width: 10),
        Container(
          width: 60,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_gold.withAlpha(150), Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}
