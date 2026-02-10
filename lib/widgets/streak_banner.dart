import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/streak_provider.dart';

class StreakBanner extends StatefulWidget {
  const StreakBanner({super.key});

  @override
  State<StreakBanner> createState() => _StreakBannerState();
}

class _StreakBannerState extends State<StreakBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _fireController;
  late Animation<double> _fireAnimation;

  @override
  void initState() {
    super.initState();
    _fireController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _fireAnimation = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _fireController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StreakProvider>(
      builder: (context, streakProvider, child) {
        final streak = streakProvider.currentStreak;
        final longestStreak = streakProvider.longestStreak;
        final practicedToday = streakProvider.practicedToday;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: practicedToday
                  ? [
                      const Color(0xFFFF6B35),
                      const Color(0xFFFF8C42),
                      const Color(0xFFFFAA5C),
                    ]
                  : isDark
                      ? [
                          Colors.grey.shade800,
                          Colors.grey.shade700,
                        ]
                      : [
                          Colors.grey.shade300,
                          Colors.grey.shade200,
                        ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (practicedToday)
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              // Fire icon with animation
              AnimatedBuilder(
                animation: _fireAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: streak > 0 ? _fireAnimation.value : 1.0,
                    child: Text(
                      streak > 0 ? '🔥' : '💤',
                      style: const TextStyle(fontSize: 32),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              // Streak info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          streak == 1
                              ? '$streak dia'
                              : '$streak dias',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: practicedToday
                                ? Colors.white
                                : isDark
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                          ),
                        ),
                        if (longestStreak > streak) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: practicedToday
                                  ? Colors.white.withOpacity(0.25)
                                  : isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Recorde: $longestStreak',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: practicedToday
                                    ? Colors.white
                                    : isDark
                                        ? Colors.white70
                                        : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      streakProvider.motivationalMessage,
                      style: TextStyle(
                        fontSize: 13,
                        color: practicedToday
                            ? Colors.white.withOpacity(0.9)
                            : isDark
                                ? Colors.white54
                                : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Checkmark if practiced today
              if (practicedToday)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
