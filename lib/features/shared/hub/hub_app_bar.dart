import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/features/shared/components/app_icon.dart';

class HubAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HubAppBar({
    super.key,
    this.title,
    this.canPop = false,
    this.leading,
    this.actions,
    this.onBackButtonPressed,
    this.showBrandMark = true,
  });

  final String? title;
  final bool canPop;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onBackButtonPressed;
  final bool showBrandMark;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      automaticallyImplyLeading: canPop && leading == null,
      leading:
          leading ??
          (canPop
              ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                iconSize: 26,
                onPressed: onBackButtonPressed ?? () => Navigator.maybePop(context),
              )
              : null),
      title: Row(
        children: [
          if (showBrandMark && !canPop) ...[
            AppIcon.hub(size: 40),
            DSSpacing.sm.x,
          ],
          Expanded(
            child: Text(
              title ?? '',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.02,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}
