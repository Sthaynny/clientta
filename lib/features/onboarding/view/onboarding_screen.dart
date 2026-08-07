import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/components/app_icon.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';
import 'package:clientta/features/shared/hub/hub_primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.onSkip,
    required this.onRegister,
  });

  final VoidCallback onSkip;
  final VoidCallback onRegister;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageCount = 2;
  static const _motionMs = 175;

  final _pageController = PageController();

  int _currentPage = 0;

  Duration _motionDuration(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Duration.zero;
    }
    return const Duration(milliseconds: _motionMs);
  }

  Curve _motionCurve(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Curves.linear;
    }
    return Curves.easeOutCubic;
  }

  Future<void> _goToPage(int page) async {
    await _pageController.animateToPage(
      page,
      duration: _motionDuration(context),
      curve: _motionCurve(context),
    );
  }

  void _onPrimaryAction() {
    if (_currentPage == 0) {
      _goToPage(1);
      return;
    }
    widget.onRegister();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryLabel =
        _currentPage == 0
            ? onboardingContinueString
            : onboardingRegisterCtaString;

    return Scaffold(
      backgroundColor: HubColors.canvas,
      body: Column(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [HubColors.seedDark, HubColors.seed],
              ),
            ),
            child: const SizedBox(height: 4, width: double.infinity),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      DSSpacing.lg.value,
                      DSSpacing.md.value,
                      DSSpacing.lg.value,
                      0,
                    ),
                    child: Row(
                      children: [
                        AppIcon.onLight(size: 36),
                        const Spacer(),
                        Semantics(
                          button: true,
                          label: onboardingSkipString,
                          child: TextButton(
                            onPressed: widget.onSkip,
                            style: TextButton.styleFrom(
                              foregroundColor: HubColors.inkMuted,
                              minimumSize: const Size(48, 48),
                            ),
                            child: Text(onboardingSkipString),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      children: [
                        _OnboardingPage(
                          icon: Icons.cloud_off_outlined,
                          title: onboardingOfflineTitle,
                          message: onboardingOfflineMessage,
                        ),
                        _OnboardingPage(
                          icon: Icons.event_note_outlined,
                          title: onboardingFirstAppointmentTitle,
                          message: onboardingFirstAppointmentMessage,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(DSSpacing.lg.value),
                    child: Column(
                      children: [
                        _PageIndicators(
                          count: _pageCount,
                          current: _currentPage,
                        ),
                        DSSpacing.md.y,
                        HubPrimaryButton(
                          label: primaryLabel,
                          onPressed: _onPrimaryAction,
                          trailingIcon: Icon(
                            _currentPage == 0
                                ? Icons.arrow_forward_rounded
                                : Icons.add_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DSSpacing.lg.value),
      child: HubSurface(
        padding: EdgeInsets.all(DSSpacing.xl.value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: HubColors.successTint,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(DSSpacing.xl.value),
                child: Icon(icon, size: 56, color: HubColors.seed),
              ),
            ),
            DSSpacing.xl.y,
            DSHeadlineLargeText(
              title,
              textAlign: TextAlign.center,
              color: HubColors.ink,
            ),
            DSSpacing.md.y,
            DSBodyText(
              message,
              textAlign: TextAlign.center,
              height: 1.5,
              color: HubColors.inkMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration:
              MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 175),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: DSSpacing.xxs.value),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? HubColors.seed : HubColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
