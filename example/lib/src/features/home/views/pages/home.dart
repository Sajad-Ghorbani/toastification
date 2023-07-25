import 'dart:math';

import 'package:example/src/core/usecase/responsive/responsive.dart';
import 'package:example/src/core/views/widgets/bottom_navigation.dart';
import 'package:example/src/features/home/views/widgets/app_bar/app_bar.dart';
import 'package:example/src/features/home/views/widgets/customization_panel.dart';
import 'package:example/src/features/home/views/widgets/header.dart';
import 'package:example/src/features/home/views/widgets/preview_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const route = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWithBorder = false;

  @override
  Widget build(BuildContext context) {
    return DefaultStickyHeaderController(
      child: Scaffold(
        bottomNavigationBar: const BottomNavigationView(),
        body: Stack(
          children: [
            NotificationListener<ScrollUpdateNotification>(
              onNotification: _toggleIsWithBorderBasedOnScroll,
              child: const CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: ToastHeader()),
                  CustomizationSection()
                ],
              ),
            ),
            ToastAppBar(
              isWithBorder: isWithBorder,
            ),
          ],
        ),
      ),
    );
  }

  bool _toggleIsWithBorderBasedOnScroll(ScrollUpdateNotification notification) {
    if (notification.metrics.pixels > 100) {
      if (!isWithBorder) {
        setState(() {
          isWithBorder = true;
        });
      }
      return true;
    }
    if (isWithBorder) {
      setState(() {
        isWithBorder = false;
      });
    }
    return true;
  }
}

class CustomizationSection extends StatelessWidget {
  const CustomizationSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.isInDesktopZone) {
      return const _HorizontalSection();
    }

    return const _VerticalSection();
  }
}

class _HorizontalSection extends StatelessWidget {
  const _HorizontalSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final sideHeaderWidth = screenWidth * 0.38;
    final previewPanelPadding = screenWidth * 0.04;

    return SliverPadding(
      padding:
          EdgeInsets.symmetric(horizontal: previewPanelPadding, vertical: 64),
      sliver: SliverStickyHeader(
        overlapsContent: true,
        header: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: SizedBox(
            width: sideHeaderWidth,
            child: const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 16, 0, 16),
              child: PreviewPanel(),
            ),
          ),
        ),
        sliver: SliverPadding(
          padding: EdgeInsetsDirectional.only(end: sideHeaderWidth),
          sliver: const CustomizationPanel(),
        ),
      ),
    );
  }
}

class _VerticalSection extends StatelessWidget {
  const _VerticalSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const widgetMaxSize = 600;
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: max((screenWidth - widgetMaxSize) / 2, 8),
      ),
      sliver: SliverStickyHeader(
        header: const PreviewPanel(),
        sliver: const SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 32, 8, 8),
          sliver: CustomizationPanel(),
        ),
      ),
    );
  }
}
