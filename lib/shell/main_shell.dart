import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/services/ads/banner_ad_slot.dart';

/// Bottom navigation with 3 tabs: Home / Saved / Setting (`design.md` §3).
/// Each tab keeps its own navigation stack and state.
///
/// Free users: the collapsible banner sits at the very bottom, under the
/// nav bar, so it stays while they switch tabs. Not in the first launch
/// (language → intro → Home): from the next launch on.
class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final withBanner = !ref.read(settingsRepositoryProvider).inFirstRunSession;
    final nav = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // Re-tapping the current tab pops it back to its root.
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_border_rounded),
            selectedIcon: const Icon(Icons.bookmark_rounded),
            label: l10n.navSaved,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: withBanner
          ? Builder(
              // Under the Scaffold's own MediaQuery (the status bar's inset
              // is already off the bottom bar there; the outer one still
              // has it and made the bar taller).
              builder: (context) {
                final media = MediaQuery.of(context);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The system bar's area goes under the banner instead.
                    // The bar reads `padding`, so it is zeroed there.
                    MediaQuery(
                      data: media.copyWith(
                        padding: media.padding.copyWith(top: 0, bottom: 0),
                        viewPadding: media.viewPadding.copyWith(
                          top: 0,
                          bottom: 0,
                        ),
                      ),
                      child: nav,
                    ),
                    ColoredBox(
                      color: colors.surfaceCard,
                      child: const SizedBox(
                        width: double.infinity,
                        height: LmSpacing.s4,
                      ),
                    ),
                    BannerAdSlot(
                      collapsible: true,
                      bottomInset: media.padding.bottom,
                      background: colors.surfaceCard,
                    ),
                  ],
                );
              },
            )
          : nav,
    );
  }
}
