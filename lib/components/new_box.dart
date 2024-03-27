import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class NewBox extends StatelessWidget {
  const NewBox({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.pink.shade400,
            blurRadius: 15,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: isDarkMode ? Colors.pink.shade400 : Colors.white,
            blurRadius: 15,
            offset: const Offset(-4, -4),
          )
        ],
      ),
      child: child,
    );
  }
}
