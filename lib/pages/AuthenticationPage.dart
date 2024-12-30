import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// If you want some brand color constants, you can keep AppColors:
import '../theme/colors.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final PageController _pageController = PageController();
  final _databaseService = DatabaseService();
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _autoSlide();
    });
  }

  void _autoSlide() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted) {
        setState(() {
          _currentPage = (_currentPage + 1) % 4;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _databaseService.logInWithGoogle(context);
      if (userCredential != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In Successful')),
        );
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _databaseService.logInWithFacebook(context);
      if (userCredential != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facebook Sign-In Successful')),
        );
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook Sign-In Failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      // Let the theme decide the background color:
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Slider
                SizedBox(
                  height: size.height * 0.5,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        'assets/images/slider_${index + 1}.png',
                        fit: BoxFit.contain,
                        height: size.height * 0.5,
                        width: size.width,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surface,
                            child: const Icon(Icons.error),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    bool isActive = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: isActive ? 12.0 : 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.colorScheme.primary // highlight color
                            : theme.disabledColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24.0),

                // Text Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Develop good habits',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Habits are a fundamental part of our life. Make the most of your life!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: size.width * 0.04,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Buttons Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: Size(size.width * 0.8, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16.0,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: Size(size.width * 0.8, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login With Email',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16.0,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Social Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/google.svg',
                              // Tint the asset with onSurface or something similar:
                              colorFilter: ColorFilter.mode(
                                theme.iconTheme.color ?? Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            iconSize: 36,
                            onPressed: _handleGoogleSignIn,
                          ),
                          // If you want Facebook:
                          // IconButton(
                          //   icon: SvgPicture.asset(
                          //     'assets/icons/facebook.svg',
                          //     colorFilter: ColorFilter.mode(
                          //       theme.iconTheme.color ?? Colors.white,
                          //       BlendMode.srcIn,
                          //     ),
                          //   ),
                          //   iconSize: 36,
                          //   onPressed: _handleFacebookSignIn,
                          // ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'By continuing you agree to Habeet\'s\nTerms of Services & Privacy Policy',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: size.width * 0.03,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
