import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<HomeBloc>().add(ResetInvitationStatusEvent());

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
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
      final newBytes =
      await Future.wait(pickedFiles.map((f) => f.readAsBytes()));
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
        const SnackBar(content: Text("Please fill all details")),
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

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (prev, curr) =>
        prev.isInvitationLoading != curr.isInvitationLoading ||
            prev.savedInvitationId != curr.savedInvitationId ||
            prev.invitationError != curr.invitationError,
        listener: (context, state) {
          if (state.invitationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.invitationError!)),
            );
          }
          if (state.savedInvitationId != null) {
            _navigateToPreview(context);
          }
        },
        builder: (context, state) {
          final isLoading = state.isInvitationLoading;

          return SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 0 : 24,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 520 : double.infinity,
                        ),
                        child: isTablet
                            ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 32,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(40),
                          child: _buildContent(isLoading),
                        )
                            : _buildContent(isLoading),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header (Replaces AppBar) ────────────────────────────────
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Create Invitation",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Fill in the details for your special day.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 32),

        // ── Banner ──────────────────────────────────────────────────
        _imagePickerBox(
          onTap: _pickBannerImage,
          imageBytes: bannerBytes,
          title: "Upload Banner",
          icon: Icons.landscape_outlined,
        ),
        const SizedBox(height: 24),

        // ── Bride & Groom Row ───────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _imagePickerBox(
                onTap: _pickBrideImage,
                imageBytes: brideBytes,
                title: "Bride",
                icon: Icons.face_3_outlined,
                height: 120,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _imagePickerBox(
                onTap: _pickGroomImage,
                imageBytes: groomBytes,
                title: "Groom",
                icon: Icons.face_outlined,
                height: 120,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // ── Text fields ─────────────────────────────────────────────
        _textField(
            controller: brideController, hint: "Bride's Name", icon: Icons.woman),
        const SizedBox(height: 16),
        _textField(
            controller: groomController, hint: "Groom's Name", icon: Icons.man),
        const SizedBox(height: 16),
        _textField(
            controller: venueController,
            hint: "Venue Name",
            icon: Icons.business_outlined),
        const SizedBox(height: 16),
        _textField(
            controller: addressController,
            hint: "Full Address",
            icon: Icons.location_on_outlined),
        const SizedBox(height: 16),
        _textField(
            controller: mapLinkController,
            hint: "Google Maps URL",
            icon: Icons.map_outlined),
        const SizedBox(height: 16),

        // ── Date picker ─────────────────────────────────────────────
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500),
                const SizedBox(width: 16),
                Text(
                  selectedDate == null
                      ? "Select Wedding Date"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  style: TextStyle(
                    color: selectedDate == null
                        ? Colors.grey.shade500
                        : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Gallery ─────────────────────────────────────────────────
        Text(
          "Gallery",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: _pickGalleryImages,
                child: Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.add_photo_alternate_outlined,
                      color: Colors.grey.shade500, size: 28),
                ),
              ),
              ...galleryBytes.asMap().entries.map(
                    (entry) => Stack(
                  children: [
                    Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(entry.value, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            galleryXFiles.removeAt(entry.key);
                            galleryBytes.removeAt(entry.key);
                          });
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close,
                              size: 14, color: Colors.white),
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

        // ── Proceed button ──────────────────────────────────────────
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _onProceed(isLoading),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
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
                : const Text(
              "Proceed",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Reusable widgets ─────────────────────────────────────────────────────────
  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _imagePickerBox({
    required VoidCallback onTap,
    required Uint8List? imageBytes,
    required String title,
    required IconData icon,
    double height = 140,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: imageBytes == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(imageBytes, fit: BoxFit.cover),
        ),
      ),
    );
  }

  // ── Navigation helper ────────────────────────────────────────────────────────
  void _navigateToPreview(BuildContext context) {
    final bannerBase64 = bannerBytes != null ? base64Encode(bannerBytes!) : '';
    final brideBase64 = brideBytes != null ? base64Encode(brideBytes!) : '';
    final groomBase64 = groomBytes != null ? base64Encode(groomBytes!) : '';
    final galleryBase64 = galleryBytes.map((b) => base64Encode(b)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvitationPreviewScreen(
          brideName: brideController.text.trim(),
          groomName: groomController.text.trim(),
          venue: venueController.text.trim(),
          address: addressController.text.trim(),
          mapUrl: mapLinkController.text.trim(),
          date: selectedDate!,
          bannerImage: bannerBase64,
          brideImage: brideBase64,
          groomImage: groomBase64,
          galleryImages: galleryBase64,
        ),
      ),
    );
  }
}