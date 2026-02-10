import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/cards_provider.dart';
import '../providers/streak_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_card_dialog.dart';
import '../widgets/streak_banner.dart';
import 'category_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    
    // Load cards and streak when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardsProvider = context.read<CardsProvider>();
      final streakProvider = context.read<StreakProvider>();

      cardsProvider.loadCards();
      streakProvider.loadStreak();

      // Connect streak recording to card practice
      cardsProvider.onCardPracticed = () {
        streakProvider.recordPractice();
      };
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      body: Column(
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
