//Responsive Builder for mobile, desktop and tablet

import 'package:flutter/material.dart';
import 'package:login_page/core/utils/context.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) desktopBuilder;
  final Widget Function(BuildContext context)? mobileBuilder;
  final Widget Function(BuildContext context)? tabletBuilder;

  const ResponsiveBuilder({
    super.key,
    required this.desktopBuilder,
    this.mobileBuilder,
    this.tabletBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (context.isMobile && mobileBuilder != null) {
          return mobileBuilder!(context);
        } else if (context.isTablet && tabletBuilder != null) {
          return tabletBuilder!(context);
        } else if (context.isDesktop) {
          return desktopBuilder(context);
        }
        return desktopBuilder(context);
      },
    );
  }
}

class MobileColumnDesktopRow extends StatelessWidget {
  const MobileColumnDesktopRow({
    super.key,
    required this.children,
    this.rowCrossAxisAlignment,
    this.spacing = 0,
  });
  final List<Widget> children;
  final double spacing;
  final CrossAxisAlignment? rowCrossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? Column(
            spacing: spacing,
            children: children,
          )
        : Row(
            spacing: spacing,
            crossAxisAlignment:
                rowCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: children,
          );
  }
}

class ExpandedOrNot extends StatelessWidget {
  const ExpandedOrNot({
    super.key,
    this.isExpanded = true,
    this.flex = 1,
    required this.child,
    this.widthIfNotExpanded,
  });
  final bool isExpanded;
  final int flex;
  final Widget child;
  final double? widthIfNotExpanded;

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? Expanded(
            flex: flex,
            child: child,
          )
        : SizedBox(width: widthIfNotExpanded, child: child);
  }
}
