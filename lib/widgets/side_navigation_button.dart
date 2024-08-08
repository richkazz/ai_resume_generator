import 'package:flutter/material.dart';

class SideNavigationButton extends StatelessWidget {
  final List<SectionItem> sections;
  final ScrollController scrollController;
  final double buttonSpacing;
  final double buttonSize;
  final Color activeColor;
  final Color inactiveColor;

  const SideNavigationButton({
    super.key,
    required this.sections,
    required this.scrollController,
    this.buttonSpacing = 10.0,
    this.buttonSize = 40.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16.0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            sections.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: buttonSpacing),
              child: _buildNavigationButton(index, context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(int index, BuildContext context) {
    return GestureDetector(
      onTap: () => _scrollToSection(index),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
        child: Center(
          child: Icon(
            sections[index].icon,
            color: Theme.of(context).colorScheme.surface,
            size: buttonSize * 0.6,
          ),
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    final context = sections[index].key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}

class SectionItem {
  final GlobalKey key;
  final IconData icon;

  SectionItem({required this.key, required this.icon});
}
