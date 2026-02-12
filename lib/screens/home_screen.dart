import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/cards_provider.dart';
import '../providers/streak_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_card_dialog.dart';
import '../widgets/streak_banner.dart';
import 'category_tab.dart';

import 'package:confetti/confetti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardsProvider = context.read<CardsProvider>();
      final streakProvider = context.read<StreakProvider>();

      cardsProvider.loadCards();
      streakProvider.loadStreak();

      cardsProvider.onCardPracticed = () {
        final alreadyPracticed = streakProvider.practicedToday;
        streakProvider.recordPractice();
        
        if (!alreadyPracticed) {
          _confettiController.play();
        }
      };
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  CardCategory get _currentCategory {
    return CardCategory.values[_tabController.index];
  }

  Color get _currentColor {
    return AppTheme.getCategoryColor(_tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'English Conversation Cards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'reset_all') {
                _confirmResetAll(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset_all',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 12),
                    Text('Resetar todas'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _currentColor,
          indicatorWeight: 3,
          labelColor: _currentColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.greenCard,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Green'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.blueCard,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Blue'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.orangeCard,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Orange'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const StreakBanner(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: CardCategory.values.map((category) {
                    return CategoryTab(category: category);
                  }).toList(),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewCard(context),
        backgroundColor: _currentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addNewCard(BuildContext context) async {
    final provider = context.read<CardsProvider>();
    
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => AddCardDialog(category: _currentCategory),
    );

    if (result != null) {
      provider.addCard(
        result['phrase']!,
        _currentCategory,
        translation: result['translation'],
      );
    }
  }

  void _confirmResetAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Resetar todas as frases'),
          content: const Text(
            'Deseja desmarcar todas as frases de todas as categorias?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<CardsProvider>().resetAllCardsGlobally();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Resetar todas'),
            ),
          ],
        );
      },
    );
  }
}
