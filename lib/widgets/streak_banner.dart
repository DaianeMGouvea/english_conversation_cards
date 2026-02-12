import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/streak_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StreakBanner extends StatefulWidget {
  const StreakBanner({super.key});

  @override
  State<StreakBanner> createState() => _StreakBannerState();
}

class _StreakBannerState extends State<StreakBanner> {
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
              Text(
                streak > 0 ? '🔥' : '💤',
                style: const TextStyle(fontSize: 32),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scaleXY(
                    begin: 1.0,
                    end: 1.2,
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scaleXY(
                    begin: 1.2,
                    end: 1.0,
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
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
                          streak == 1 ? '$streak dia' : '$streak dias',
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
                )
                    .animate()
                    .scale(duration: 400.ms, curve: Curves.elasticOut)
                    .fadeIn(duration: 400.ms),
            ],
          ),
        )
            .animate(target: practicedToday ? 1 : 0)
            .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.2));
      },
    );
  }
}
