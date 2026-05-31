import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const Color kMidnightDeep = Color(0xFF0F172A);
const Color kMidnightSlate = Color(0xFF1E293B);
const Color kRoseGold = Color(0xFFE29587);
const Color kRoseGoldLight = Color(0xFFF3D5D0);
const Color kIvory = Color(0xFFFDFCF0);
const Color kDeepPurple = Color(0xFF5F16E8);
const Color kDarkIndigo = Color(0xFF1E1B4B);

class InvitationPreviewScreen extends StatefulWidget {
  final String brideName;

  final String groomName;

  final String venue;

  final String address;

  final String mapUrl;

  final DateTime date;

  final String bannerImage;

  final List<String> galleryImages;

  final String brideImage;

  final String groomImage;

  const InvitationPreviewScreen({
    super.key,
    required this.brideName,
    required this.groomName,
    required this.venue,
    required this.address,
    required this.mapUrl,
    required this.date,
    required this.bannerImage,
    required this.galleryImages,
    required this.brideImage,
    required this.groomImage,
  });

  @override
  State<InvitationPreviewScreen> createState() =>
      _InvitationPreviewScreenState();
}

class _InvitationPreviewScreenState
    extends State<InvitationPreviewScreen>
    with TickerProviderStateMixin {
  late AnimationController bgController;

  late Animation<Alignment> topAlignment;

  late Animation<Alignment> bottomAlignment;

  Timer? timer;

  Duration timeLeft = const Duration();

  @override
  void initState() {
    super.initState();

    bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    topAlignment = AlignmentTween(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    ).animate(bgController);

    bottomAlignment = AlignmentTween(
      begin: Alignment.bottomRight,
      end: Alignment.bottomLeft,
    ).animate(bgController);

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) {
          setState(() {
            timeLeft =
                widget.date.difference(DateTime.now());
          });
        }
      },
    );
  }

  @override
  void dispose() {
    bgController.dispose();

    timer?.cancel();

    super.dispose();
  }

  TextStyle headerFont(
      double size, {
        Color color = kIvory,
      }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 1.2,
    );
  }

  TextStyle scriptFont(
      double size, {
        Color color = kRoseGold,
      }) {
    return GoogleFonts.greatVibes(
      fontSize: size,
      color: color,
    );
  }

  TextStyle bodyFont(
      double size, {
        Color color = Colors.white70,
      }) {
    return GoogleFonts.montserrat(
      fontSize: size,
      color: color,
      letterSpacing: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMidnightDeep,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: bgController,
            builder: (_, __) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: topAlignment.value,
                    end: bottomAlignment.value,
                    colors: const [
                      kMidnightDeep,
                      kDeepPurple,
                      kDarkIndigo,
                      kMidnightDeep,
                    ],
                  ),
                ),
              );
            },
          ),

          const FloatingStardust(),

          SingleChildScrollView(
            child: Column(
              children: [
                _buildPhotoHeader(),

                const SizedBox(height: 60),

                FadeInUp(
                  child: _buildCoupleSection(),
                ),

                const SizedBox(height: 60),

                FadeIn(
                  child: _buildStoryArch(),
                ),

                const SizedBox(height: 60),

                _buildCountdownSection(),

                const SizedBox(height: 60),

                _buildGallerySection(),

                const SizedBox(height: 60),

                _buildVenueSection(),

                const SizedBox(height: 60),

                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoHeader() {
    return FadeInDown(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          double dynamicHeight = screenWidth < 600
              ? 550
              : (screenWidth < 1024 ? 650 : 750);

          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: dynamicHeight,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                  child: Image.memory(
                    base64Decode(widget.bannerImage),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) {
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Container(
                height: dynamicHeight,
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                      Colors.transparent,
                      kMidnightDeep,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      0.0,
                      0.3,
                      0.7,
                      1.0,
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      "Save the Date",
                      style: scriptFont(50),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      height: 1,
                      width: 80,
                      color: kRoseGoldLight,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "FOR THE WEDDING OF",
                      style: bodyFont(
                        12,
                        color: kIvory,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoupleSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            _circularProfile(
              widget.groomImage,
            ),

            const SizedBox(width: 40),

            _circularProfile(
              widget.brideImage,
            ),
          ],
        ),

        const SizedBox(height: 40),

        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "&",
              style: GoogleFonts.greatVibes(
                fontSize: 120,
                color:
                kRoseGold.withOpacity(0.15),
              ),
            ),

            Column(
              children: [
                _gradientText(
                  widget.groomName.toUpperCase(),
                  GoogleFonts.cinzel(
                    fontSize: 28,
                    fontWeight:
                    FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 5),

                Container(
                  height: 1,
                  width: 100,
                  color:
                  kRoseGold.withOpacity(0.3),
                ),

                const SizedBox(height: 5),

                _gradientText(
                  widget.brideName.toUpperCase(),
                  GoogleFonts.cinzel(
                    fontSize: 28,
                    fontWeight:
                    FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          "${widget.date.day}/${widget.date.month}/${widget.date.year}",
          style: bodyFont(
            14,
            color:
            kIvory.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _gradientText(
      String text,
      TextStyle style,
      ) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          const LinearGradient(
            colors: [
              kRoseGoldLight,
              kRoseGold,
              Color(0xFFB87333),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromLTWH(
              0,
              0,
              bounds.width,
              bounds.height,
            ),
          ),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  Widget _buildStoryArch() {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: kMidnightSlate.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(150),
          topRight: Radius.circular(150),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(
          color: kRoseGold.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: kRoseGold,
            size: 30,
          ),

          const SizedBox(height: 20),

          Text(
            "Our Story",
            style: headerFont(28),
          ),

          const SizedBox(height: 15),

          Text(
            "Together with our families, we invite you to celebrate the beginning of our forever journey.",
            textAlign: TextAlign.center,
            style: bodyFont(
              15,
              color:
              kIvory.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownSection() {
    return Column(
      children: [
        Text(
          "THE COUNTDOWN",
          style: headerFont(
            20,
            color: kRoseGold,
          ),
        ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            _timePill(
              timeLeft.inDays.toString(),
              "Days",
            ),

            _timePill(
              (timeLeft.inHours % 24)
                  .toString(),
              "Hrs",
            ),

            _timePill(
              (timeLeft.inMinutes % 60)
                  .toString(),
              "Min",
            ),
          ],
        ),
      ],
    );
  }

  Widget _timePill(
      String val,
      String label,
      ) {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: 10),
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color:
        kRoseGold.withOpacity(0.1),
        borderRadius:
        BorderRadius.circular(50),
        border: Border.all(
          color:
          kRoseGold.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Text(
            val,
            style: headerFont(
              24,
              color: kRoseGold,
            ),
          ),

          Text(
            label,
            style: bodyFont(10),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 400,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 1.0,
      ),
      items:
      widget.galleryImages.map((img) {
        return Container(
          padding:
          const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kIvory,
            borderRadius:
            BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.memory(
                  base64Decode(img),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder:
                      (_, __, ___) {
                    return Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(
                          Icons.image,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Moments",
                style: scriptFont(
                  24,
                  color: kMidnightDeep,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVenueSection() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "THE VENUE",
            style: headerFont(
              28,
              color: kRoseGold,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                kRoseGold.withOpacity(0.3),
              ),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: kRoseGold,
                  size: 40,
                ),

                const SizedBox(height: 20),

                Text(
                  widget.venue,
                  textAlign: TextAlign.center,
                  style: headerFont(20),
                ),

                const SizedBox(height: 10),

                Text(
                  widget.address,
                  textAlign: TextAlign.center,
                  style: bodyFont(14),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () async {
                    final Uri googleMapsUrl =
                    Uri.parse(widget.mapUrl);

                    await launchUrl(
                      googleMapsUrl,
                      mode: LaunchMode
                          .externalApplication,
                    );
                  },
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    kRoseGold,
                    foregroundColor:
                    kMidnightDeep,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),
                  child: const Text(
                    "VIEW ON MAPS",
                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: Colors.black45,
      padding:
      const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Text(
            "We can't wait to see you!",
            style: scriptFont(35),
          ),

          const SizedBox(height: 20),

          Text(
            "#WeddingInvitation",
            style: bodyFont(
              12,
              color: kRoseGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circularProfile(String img) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: kRoseGold,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundImage:
            MemoryImage(base64Decode(img),)
      ),
    );
  }
}

class FloatingStardust extends StatefulWidget {
  const FloatingStardust({super.key});

  @override
  State<FloatingStardust> createState() =>
      _FloatingStardustState();
}

class _FloatingStardustState
    extends State<FloatingStardust>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<Offset> stars = List.generate(
    40,
        (i) => Offset(
      Random().nextDouble(),
      Random().nextDouble(),
    ),
  );

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: stars.map((star) {
            return Positioned(
              left: star.dx *
                  MediaQuery.of(context)
                      .size
                      .width,
              top: ((star.dy +
                  controller.value) %
                  1.0) *
                  MediaQuery.of(context)
                      .size
                      .height,
              child: Opacity(
                opacity:
                Random().nextDouble() *
                    0.5 +
                    0.2,
                child: Icon(
                  Icons.auto_awesome,
                  size:
                  Random().nextDouble() *
                      8 +
                      2,
                  color: kRoseGoldLight,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}