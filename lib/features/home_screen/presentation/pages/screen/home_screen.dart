import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/widgets/app_navigation.dart';


import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../widgets/category_chips_widget.dart';
import '../widgets/product_grid_widget.dart';
import '../widgets/promo_banner_widget.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _navVisible = true;

  final ScrollController _scrollController = ScrollController();

  double _lastScrollOffset = 0;

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Sports',
    'Beauty',
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = _scrollController.offset;

    final delta = offset - _lastScrollOffset;

    if (delta > 8 && _navVisible) {
      setState(() => _navVisible = false);
    } else if (delta < -8 && !_navVisible) {
      setState(() => _navVisible = true);
    }

    _lastScrollOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,

          extendBody: true,

          body: SafeArea(
            bottom: false,

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    0,
                  ),

                  child: SearchBarWidget(
                    onNotificationTap: () {},
                  ),
                ),

                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,

                    physics: const BouncingScrollPhysics(),

                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            20,
                            20,
                            0,
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [
                              _buildGreeting(state.userName),

                              const SizedBox(height: 20),

                              const PromoBannerWidget(),

                              const SizedBox(height: 24),

                              CategoryChipsWidget(
                                categories: _categories,

                                selectedCategory:
                                state.selectedCategory,

                                onCategorySelected: (category) {
                                  context
                                      .read<HomeBloc>()
                                      .add(
                                    ChangeCategoryEvent(
                                      category,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 20),

                              _buildSectionHeader(
                                'Trending Now',
                                onSeeAll: () {},
                              ),

                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          0,
                          20,
                          isTablet ? 32 : 100,
                        ),

                        sliver: ProductGridWidget(
                          products: state.products,

                          selectedCategory:
                          state.selectedCategory,

                          crossAxisCount:
                          isTablet ? 3 : 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: AppNavigation(
            currentIndex: state.currentNavIndex,

            isVisible: _navVisible,

            onTap: (index) {
              context.read<HomeBloc>().add(
                ChangeBottomNavEvent(index),
              );


              if (index == 2) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.weddingInvitationScreen,
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildGreeting(String userName) {

    final hour = DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = 'Good morning ☀️';
    } else if (hour < 17) {
      greeting = 'Good afternoon 👋';
    } else {
      greeting = 'Good evening 🌙';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          greeting,

          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9E9E9E),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          userName.isEmpty
              ? 'Welcome'
              : 'Hi, $userName 👋',

          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Discover value beyond new.',

          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }
  Widget _buildSectionHeader(
      String title, {
        VoidCallback? onSeeAll,
      }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),

        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,

            child: Text(
              'See all',

              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}