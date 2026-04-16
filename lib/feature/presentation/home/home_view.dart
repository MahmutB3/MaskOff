import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:testvid/feature/controllers/home_controller.dart';
import 'package:testvid/feature/controllers/theme_controller.dart';
import 'package:testvid/feature/controllers/profile&history/profile_and_history_controller.dart';
import 'package:testvid/feature/presentation/home/widgets/home_button.dart';
import 'package:testvid/feature/presentation/home/widgets/home_empty_state.dart';
import 'package:testvid/feature/presentation/home/widgets/home_.dart';
import 'package:testvid/feature/controllers/auth/auth_controller.dart';
import 'package:testvid/feature/controllers/result_controller.dart';
import 'package:testvid/feature/bindings/result_binding.dart';
import 'package:testvid/routes/app_pages.dart';
import 'package:testvid/generated/l10n.dart';
import 'package:testvid/core/services/app_logger.dart';
import 'package:testvid/core/utils/snackbar_helper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoController controller = Get.put(VideoController());
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();
    final ProfileController profileController = Get.put(ProfileController());

    return Obx(() {
      final isDark = themeController.isDarkMode;

      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E1E2E),
                      const Color(0xFF2D2D44),
                    ]
                  : [
                      const Color(0xFFF5F5FA),
                      const Color(0xFFE8E8F0),
                    ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).appTitle,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF333333),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              AppLogger()
                                  .info("Tema değiştirme butonu tıklandı");
                              AppLogger().info(
                                  "Mevcut tema: ${isDark ? 'Koyu' : 'Açık'}");
                              themeController.toggleTheme();
                              AppLogger().info(
                                  "Yeni tema: ${themeController.isDarkMode ? 'Koyu' : 'Açık'}");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : const Color(0xFF6C63FF)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Profile butonu
                          GestureDetector(
                            onTap: () => Get.toNamed('/profile'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : const Color(0xFF6C63FF)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Settings button
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.settings),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : const Color(0xFF6C63FF)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.settings,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    final user = authController.user.value;
                    final profile = profileController.userModel.value;

                    String welcomeText = S.of(context).detectDeepfake;

                    if (user != null) {
                      // Check if profile has first name
                      if (profile?.firstName != null &&
                          profile!.firstName!.isNotEmpty) {
                        welcomeText =
                            S.of(context).welcomeBack(profile.firstName!);
                      }
                      // Check if Firebase Auth has display name
                      else if (user.displayName != null &&
                          user.displayName!.isNotEmpty) {
                        final firstName = user.displayName!.split(' ').first;
                        welcomeText = S.of(context).welcomeBack(firstName);
                      }
                      // Use email as fallback
                      else {
                        final emailName =
                            user.email?.split('@').first ?? 'User';
                        welcomeText = S.of(context).welcomeBack(emailName);
                      }
                    }

                    return Text(
                      welcomeText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.8)
                            : const Color(0xFF555555),
                      ),
                    );
                  }),
                  const SizedBox(height: 5),
                  Text(
                    S.of(context).detectDeepfake,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : const Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Video Display Area
                  Expanded(
                    child: Center(
                      child: Obx(() {
                        if (controller.playerController.value != null &&
                            controller.isInitialized.value) {
                          return BuildVideoCard(
                              controller: controller, isDark: isDark);
                        } else {
                          return BuildEmptyState(isDark: isDark);
                        }
                      }),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: BuildButton(
                            icon: Icons.file_upload_outlined,
                            label: S.of(context).uploadVideo,
                            onPressed: controller.pickVideo,
                            isPrimary: true,
                            isDark: isDark),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BuildButton(
                            icon: Icons.search,
                            label: S.of(context).analyze,
                            onPressed: () async {
                              if (controller.isInitialized.value &&
                                  controller.videoFile.value != null) {
                                // Initialize ResultBinding
                                ResultBinding().dependencies();

                                final resultController =
                                    Get.find<ResultController>();

                                // Show loading dialog
                                Get.dialog(
                                  PopScope(
                                    canPop: false,
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? const Color(0xFF2D2D44)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.1),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Lottie.asset(
                                                'assets/Animation - 1749130545815.json',
                                                width: 100,
                                                height: 100,
                                              ),
                                              const SizedBox(height: 24),
                                              Text(
                                                S.of(context).analyzingVideo,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF333333),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                S.of(context).pleaseWait,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: isDark
                                                      ? Colors.white70
                                                      : Colors.grey[600],
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  barrierColor:
                                      Colors.black.withValues(alpha: 0.5),
                                );

                                await resultController
                                    .analyzeVideo(controller.videoFile.value!);

                                // Close loading dialog
                                Get.back();

                                Get.toNamed("/result");
                              } else {
                                SnackbarHelper.showError(
                                  S.of(context).uploadRequired,
                                  S.of(context).pleaseUploadFirst,
                                );
                              }
                            },
                            isPrimary: false,
                            isDark: isDark),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
