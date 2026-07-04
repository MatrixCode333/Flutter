import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../widgets/invatation /view_invatation.dart';

class WeddingInvitationScreen extends StatefulWidget {
  const WeddingInvitationScreen({super.key});

  @override
  State<WeddingInvitationScreen> createState() =>
      _WeddingInvitationScreenState();
}

class _WeddingInvitationScreenState extends State<WeddingInvitationScreen>
    with TickerProviderStateMixin {
  // ── Color Palette ────────────────────────────────────────────────────────────
  static const Color _cream = Color(0xFFFDF8F5);
  static const Color _gold = Color(0xFFB8860B);
  static const Color _goldLight = Color(0xFFD4A843);
  static const Color _roseDust = Color(0xFFD4A0A0);
  static const Color _deepBrown = Color(0xFF2C1810);
  static const Color _warmBrown = Color(0xFF8B6F5E);
  static const Color _softPink = Color(0xFFF9EEE8);
  static const Color _borderColor = Color(0xFFE8D5C4);

  // ── Controllers ─────────────────────────────────────────────────────────────
  final brideController = TextEditingController();
  final groomController = TextEditingController();
  final venueController = TextEditingController();
  final addressController = TextEditingController();
  final mapLinkController = TextEditingController();

  // ── Local image state ────────────────────────────────────────────────────────
  DateTime? selectedDate;
  XFile? bannerXFile;
  XFile? brideXFile;
  XFile? groomXFile;
  List<XFile> galleryXFiles = [];
  Uint8List? bannerBytes;
  Uint8List? brideBytes;
  Uint8List? groomBytes;
  List<Uint8List> galleryBytes = [];
  final ImagePicker _picker = ImagePicker();

  // ── Animations ──────────────────────────────────────────────────────────────
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Lifecycle ────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    // Reset any previous invitation state when entering the screen
    context.read<HomeBloc>().add(ResetInvitationStatusEvent());

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    _entranceController.forward();
  }

  @override
  void dispose() {
    brideController.dispose();
    groomController.dispose();
    venueController.dispose();
    addressController.dispose();
    mapLinkController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  // ── Image pickers ────────────────────────────────────────────────────────────
  Future<void> _pickBannerImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        bannerXFile = picked;
        bannerBytes = bytes;
      });
    }
  }

  Future<void> _pickBrideImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        brideXFile = picked;
        brideBytes = bytes;
      });
    }
  }

  Future<void> _pickGroomImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        groomXFile = picked;
        groomBytes = bytes;
      });
    }
  }

  Future<void> _pickGalleryImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final newBytes = await Future.wait(
        pickedFiles.map((f) => f.readAsBytes()),
      );
      setState(() {
        galleryXFiles = [...galleryXFiles, ...pickedFiles];
        galleryBytes = [...galleryBytes, ...newBytes];
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _gold,
              onPrimary: Colors.white,
              surface: _cream,
              onSurface: _deepBrown,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  // ── Validation & dispatch ────────────────────────────────────────────────────
  void _onProceed(bool isLoading) {
    if (isLoading) return;

    if (brideController.text.trim().isEmpty ||
        groomController.text.trim().isEmpty ||
        venueController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        mapLinkController.text.trim().isEmpty ||
        selectedDate == null ||
        bannerXFile == null ||
        brideXFile == null ||
        groomXFile == null ||
        galleryXFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all details to continue',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: _deepBrown,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    context.read<HomeBloc>().add(
      SaveInvitationEvent(
        brideName: brideController.text.trim(),
        groomName: groomController.text.trim(),
        venue: venueController.text.trim(),
        address: addressController.text.trim(),
        mapUrl: mapLinkController.text.trim(),
        weddingDate: selectedDate!,
        bannerXFile: bannerXFile!,
        brideXFile: brideXFile!,
        groomXFile: groomXFile!,
        galleryXFiles: galleryXFiles,
      ),
    );
  }

  // ── Navigation helper ────────────────────────────────────────────────────────
  void _navigateToPreview(BuildContext context,String? invitationLink) {
    final bannerBase64 = bannerBytes != null ? base64Encode(bannerBytes!) : '';
    final brideBase64  = brideBytes  != null ? base64Encode(brideBytes!)  : '';
    final groomBase64  = groomBytes  != null ? base64Encode(groomBytes!)  : '';
    final galleryBase64 = galleryBytes.map((b) => base64Encode(b)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvitationPreviewScreen(
          brideName:     brideController.text.trim(),
          groomName:     groomController.text.trim(),
          venue:         venueController.text.trim(),
          address:       addressController.text.trim(),
          mapUrl:        mapLinkController.text.trim(),
          date:          selectedDate!,
          bannerImage:   bannerBase64,
          brideImage:    brideBase64,
          groomImage:    groomBase64,
          galleryImages: galleryBase64,
          invitationLink: invitationLink!,
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: _cream,
      body: BlocConsumer<HomeBloc, HomeState>(
        // Only rebuild/listen when invitation-related state changes
        listenWhen: (prev, curr) =>
        prev.isInvitationLoading != curr.isInvitationLoading ||
            prev.savedInvitationId  != curr.savedInvitationId  ||
            prev.invitationError    != curr.invitationError,
        listener: (context, state) {
          if (state.invitationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.invitationError!,
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                backgroundColor: _deepBrown,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
          if (state.savedInvitationId != null) {
            _navigateToPreview(context, state.invitationLink);
          }
        },
        builder: (context, state) {
          final isLoading = state.isInvitationLoading;

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Decorative Header ──────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          height: 220,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2C1810), Color(0xFF5C3317)],
                            ),
                          ),
                        ),
                        // Decorative floral pattern overlay
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.08,
                            child: CustomPaint(painter: _FloralPatternPainter()),
                          ),
                        ),
                        // Gold ornament top
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_gold, _goldLight, _gold],
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Back button
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(25),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withAlpha(50),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Ornamental divider
                                Row(
                                  children: [
                                    Container(width: 40, height: 1, color: _goldLight),
                                    const SizedBox(width: 8),
                                    Text('✦', style: TextStyle(color: _goldLight, fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Container(width: 40, height: 1, color: _goldLight),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Create Your',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: _goldLight,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Wedding Invitation',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Craft a beautiful invitation for your special day',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white.withAlpha(178),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Form Content ───────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 560 : double.infinity,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 0 : 20,
                            vertical: 28,
                          ),
                          child: isTablet
                              ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: _deepBrown.withAlpha(20),
                                  blurRadius: 40,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(40),
                            child: _buildFormContent(isLoading),
                          )
                              : _buildFormContent(isLoading),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormContent(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Section: Banner ────────────────────────────────────────────────
        _sectionLabel('Banner Photo', Icons.landscape_outlined),
        const SizedBox(height: 12),
        _imagePickerBox(
          onTap: _pickBannerImage,
          imageBytes: bannerBytes,
          title: 'Upload Banner Photo',
          subtitle: 'Tap to choose from gallery',
          icon: Icons.add_photo_alternate_outlined,
          height: 160,
        ),
        const SizedBox(height: 28),

        // ── Section: Couple Photos ─────────────────────────────────────────
        _sectionLabel('Couple Photos', Icons.favorite_outline),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _imagePickerBox(
                onTap: _pickBrideImage,
                imageBytes: brideBytes,
                title: 'Bride',
                subtitle: 'Tap to upload',
                icon: Icons.face_3_outlined,
                height: 130,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _roseDust.withAlpha(40),
                    shape: BoxShape.circle,
                    border: Border.all(color: _roseDust.withAlpha(80)),
                  ),
                  child: const Icon(Icons.favorite, color: _roseDust, size: 18),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _imagePickerBox(
                onTap: _pickGroomImage,
                imageBytes: groomBytes,
                title: 'Groom',
                subtitle: 'Tap to upload',
                icon: Icons.face_outlined,
                height: 130,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // ── Section: Couple Details ────────────────────────────────────────
        _sectionLabel('Couple Details', Icons.people_outline),
        const SizedBox(height: 12),
        _elegantTextField(
          controller: brideController,
          hint: "Bride's Full Name",
          icon: Icons.woman_outlined,
        ),
        const SizedBox(height: 14),
        _elegantTextField(
          controller: groomController,
          hint: "Groom's Full Name",
          icon: Icons.man_outlined,
        ),
        const SizedBox(height: 28),

        // ── Section: Venue Details ─────────────────────────────────────────
        _sectionLabel('Venue & Location', Icons.location_on_outlined),
        const SizedBox(height: 12),
        _elegantTextField(
          controller: venueController,
          hint: 'Venue Name',
          icon: Icons.business_outlined,
        ),
        const SizedBox(height: 14),
        _elegantTextField(
          controller: addressController,
          hint: 'Full Address',
          icon: Icons.location_on_outlined,
          maxLines: 2,
        ),
        const SizedBox(height: 14),
        _elegantTextField(
          controller: mapLinkController,
          hint: 'Google Maps URL',
          icon: Icons.map_outlined,
        ),
        const SizedBox(height: 28),

        // ── Section: Wedding Date ──────────────────────────────────────────
        _sectionLabel('Wedding Date', Icons.calendar_month_outlined),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _selectDate(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selectedDate != null ? _gold : _borderColor,
                width: selectedDate != null ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _deepBrown.withAlpha(8),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedDate != null
                        ? _gold.withAlpha(25)
                        : _softPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: selectedDate != null ? _gold : _warmBrown,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'Select Wedding Date'
                            : 'Wedding Date',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: _warmBrown,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(selectedDate!),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            color: _deepBrown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: _warmBrown.withAlpha(150),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // ── Section: Gallery ───────────────────────────────────────────────
        _sectionLabel('Photo Gallery', Icons.photo_library_outlined),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: _pickGalleryImages,
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _borderColor,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _deepBrown.withAlpha(8),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _gold.withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: _gold,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add Photos',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: _warmBrown,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...galleryBytes.asMap().entries.map(
                    (entry) => Stack(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: _deepBrown.withAlpha(20),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.memory(entry.value, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 18,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            galleryXFiles.removeAt(entry.key);
                            galleryBytes.removeAt(entry.key);
                          });
                        },
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: _deepBrown,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // ── Ornamental divider ─────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, _borderColor],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '✦ ✦ ✦',
                style: TextStyle(color: _gold.withAlpha(150), fontSize: 10),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_borderColor, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // ── Proceed Button ─────────────────────────────────────────────────
        Container(
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_deepBrown, Color(0xFF5C3317)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _deepBrown.withAlpha(80),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _onProceed(isLoading),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Preview Invitation',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ── Helper Widgets ───────────────────────────────────────────────────────────
  Widget _sectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _gold.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _gold, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _deepBrown,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_borderColor, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _elegantTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: _deepBrown,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: _warmBrown.withAlpha(120),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _softPink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _warmBrown, size: 18),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _gold, width: 1.5),
        ),
      ),
    );
  }

  Widget _imagePickerBox({
    required VoidCallback onTap,
    required Uint8List? imageBytes,
    required String title,
    required String subtitle,
    required IconData icon,
    double height = 140,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: imageBytes != null ? _gold.withAlpha(100) : _borderColor,
            width: imageBytes != null ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _deepBrown.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: imageBytes == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _gold.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 24, color: _gold),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                color: _deepBrown,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: _warmBrown.withAlpha(150),
                fontSize: 11,
              ),
            ),
          ],
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _deepBrown.withAlpha(180),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Change',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March',     'April',
      'May',      'June',     'July',      'August',
      'September','October',  'November',  'December',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

// ── Floral Pattern Painter ───────────────────────────────────────────────────
class _FloralPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        final cx = (size.width / 4) * i;
        final cy = (size.height / 2) * j;
        canvas.drawCircle(Offset(cx, cy), 20, paint);
        canvas.drawCircle(Offset(cx, cy), 10, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}