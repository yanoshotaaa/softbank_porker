import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'models/poker_hand.dart';
import 'repositories/poker_hand_repository.dart';
import 'screens/hand_record_screen.dart';
import 'screens/hand_history_screen.dart';
import 'screens/survey_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    Provider(
      create: (_) => PokerHandRepository(prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'White Porker',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,
        textTheme: CupertinoTextThemeData(
          primaryColor: CupertinoColors.label,
          textStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            color: CupertinoColors.label,
          ),
          navTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: CupertinoColors.label,
          ),
        ),
      ),
      home: const MainTabScreen(),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});
  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_text)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_bar)),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.device_phone_portrait)),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_crop_circle)),
        ], // ダミー（非表示）
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return const HomeTab();
              case 1:
                return const HandHistoryScreen();
              case 2:
                return const ChipRankingTab();
              case 3:
                return const PlanDiagnosisScreen();
              case 4:
                return const AccountTab();
              default:
                return const HomeTab();
            }
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildTabBar(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: _MainTabBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _MainTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _MainTabBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF7B61FF);
    const inactiveColor = Color(0xFFB0B0B0);
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabBarItem(
            icon: CupertinoIcons.home,
            label: 'ホーム',
            selected: currentIndex == 0,
            onTap: () => onTap(0),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _TabBarItem(
            icon: CupertinoIcons.doc_text,
            label: 'ログ',
            selected: currentIndex == 1,
            onTap: () => onTap(1),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _TabBarItem(
            icon: CupertinoIcons.chart_bar,
            label: 'ショップランキング',
            selected: currentIndex == 2,
            onTap: () => onTap(2),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _TabBarItem(
            icon: CupertinoIcons.device_phone_portrait,
            label: 'プラン診断',
            selected: currentIndex == 3,
            onTap: () => onTap(3),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _TabBarItem(
            icon: CupertinoIcons.person_crop_circle,
            label: 'アカウント',
            selected: currentIndex == 4,
            onTap: () => onTap(4),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  const _TabBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selected ? activeColor : inactiveColor, size: 28),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected ? activeColor : inactiveColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: '.SF Pro Text',
            ),
          ),
          const SizedBox(height: 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 4,
            width: selected ? 16 : 0,
            decoration: BoxDecoration(
              color: selected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // グラデーション背景
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FBFF),
                Color(0xFFE3F0FF),
                Color(0xFFF8E6FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          navigationBar: const CupertinoNavigationBar(
            leading: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                '＝SoftBank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: '.SF Pro Display',
                  color: CupertinoColors.label,
                ),
              ),
            ),
            middle: null,
            trailing: _NavBarIcons(),
            backgroundColor: Colors.transparent,
            border: null,
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // プロフィールヘッダー
                        const _ProfileHeader(),
                        const SizedBox(height: 20),
                        // サマリーカード
                        SizedBox(
                          height: 170,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              _RichSummaryCard(
                                icon: CupertinoIcons.money_dollar_circle,
                                title: '総チップ',
                                value: '¥0',
                                color1: Color(0xFFB388FF),
                                color2: Color(0xFF81D4FA),
                              ),
                              _RichSummaryCard(
                                icon: CupertinoIcons.doc_text,
                                title: '総ハンド数',
                                value: '0',
                                color1: Color(0xFF9575CD),
                                color2: Color(0xFFFFF176),
                              ),
                              _RichSummaryCard(
                                icon: CupertinoIcons.chart_bar,
                                title: '平均チップ',
                                value: '¥0',
                                color1: Color(0xFF80DEEA),
                                color2: Color(0xFFFF8A65),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // リッチなバナー1
                        _RichBanner(
                          title: 'SoftBankshop porker',
                          subtitle: '情報を確認',
                          buttonText: '予約はこちら',
                          gradient: LinearGradient(
                            colors: [Color(0xFFB388FF), Color(0xFF81D4FA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 12),
                        // リッチなバナー2
                        _RootsStyleBanner(),
                        const SizedBox(height: 24),
                        // リッチな予約ボタン
                        _RichMainButton(
                          text: '予約する',
                          onPressed: () {},
                        ),
                        const SizedBox(height: 16),
                        // 最近のハンド
                        const Text(
                          '最近のハンド',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: '.SF Pro Display',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<List<PokerHand>>(
                          future:
                              context.read<PokerHandRepository>().getHands(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'エラーが発生しました',
                                  style: TextStyle(
                                    color: CupertinoColors.systemRed,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }

                            final recentHands = snapshot.data ?? [];
                            if (recentHands.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text(
                                    'まだハンドが記録されていません',
                                    style: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recentHands.length,
                              itemBuilder: (context, index) {
                                final hand = recentHands[index];
                                return CupertinoListTile(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemGrey6,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.doc_text,
                                      color: CupertinoColors.systemBlue,
                                    ),
                                  ),
                                  title: Text(
                                    '${DateFormat('M/d').format(hand.startTime)} ${hand.shopName}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'チップ: ¥${hand.totalBet}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                  trailing: const CupertinoListTileChevron(),
                                  onTap: () {
                                    // TODO: ハンド詳細画面への遷移
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB388FF), Color(0xFF81D4FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFB388FF).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.add,
                color: CupertinoColors.white,
                size: 32,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const HandRecordScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// リッチなサマリーカード
class _RichSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color1;
  final Color color2;

  const _RichSummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      builder: (context, valueAnim, child) {
        return Opacity(
          opacity: valueAnim,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - valueAnim)),
            child: child,
          ),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: CupertinoColors.white, size: 36),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.white,
                  fontFamily: '.SF Pro Display',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// リッチなバナーWidget
class _RichBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Gradient gradient;
  final VoidCallback? onPressed;

  const _RichBanner({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.gradient,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: '.SF Pro Display',
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (buttonText.isNotEmpty && onPressed != null)
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: CupertinoButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// リッチなメインボタン
class _RichMainButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _RichMainButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB388FF), Color(0xFF81D4FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB388FF).withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: '.SF Pro Display',
            ),
          ),
        ),
      ),
    );
  }
}

class ChipRankingTab extends StatelessWidget {
  const ChipRankingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<PokerHand>>(
          future: context.read<PokerHandRepository>().getHands(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final hands = snapshot.data ?? [];
            if (hands.isEmpty) {
              return const Center(
                child: Text('記録がありません',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              );
            }
            // ショップごとに集計
            final Map<String, int> shopTotalBet = {};
            final Map<String, int> shopTotalProfit = {};
            final Map<String, int> shopHandCount = {};
            for (final hand in hands) {
              shopTotalBet[hand.shopName] =
                  (shopTotalBet[hand.shopName] ?? 0) + hand.totalBet;
              shopTotalProfit[hand.shopName] =
                  (shopTotalProfit[hand.shopName] ?? 0) + (hand.result ?? 0);
              shopHandCount[hand.shopName] =
                  (shopHandCount[hand.shopName] ?? 0) + 1;
            }
            final shops = shopTotalBet.keys.toList();
            shops.sort((a, b) => shopTotalBet[b]!.compareTo(shopTotalBet[a]!));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ショップ別チップ量ランキング',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF007AFF))),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      final shop = shops[index];
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: index == 0
                                ? Colors.amber
                                : (index == 1
                                    ? Colors.grey
                                    : (index == 2
                                        ? Colors.brown
                                        : Colors.blue[100])),
                            child: Text('${index + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          title: Text(shop,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('合計ベット額: ${shopTotalBet[shop]}円'),
                              Text('合計収支: ${shopTotalProfit[shop]}円'),
                              Text('ハンド数: ${shopHandCount[shop]}'),
                            ],
                          ),
                          trailing: const Icon(Icons.casino,
                              color: Color(0xFF007AFF)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SettingTab extends StatelessWidget {
  const SettingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('設定',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007AFF))),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007AFF),
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlanDiagnosisScreen()),
                );
              },
              label: const Text('携帯プラン診断'),
            ),
            const SizedBox(height: 32),
            const Text('※この診断は簡易的な目安です。詳細はソフトバンクショップでご相談ください。',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class PlanDiagnosisScreen extends StatefulWidget {
  const PlanDiagnosisScreen({super.key});
  @override
  State<PlanDiagnosisScreen> createState() => _PlanDiagnosisScreenState();
}

class _PlanDiagnosisScreenState extends State<PlanDiagnosisScreen> {
  int step = 0;
  int dataUsage = 1;
  int callUsage = 1;
  int family = 0;
  int age = 2;
  int device = 0;
  int carrier = 0;
  int service = 1;
  int discount = 0;
  String? result;
  List<String> planCandidates = [];

  final List<String> questions = [
    '月のデータ通信量は？',
    '通話はどのくらい使う？',
    '家族でまとめて契約したい？',
    '年齢は？',
    '端末の購入も検討している？',
    '他社からの乗り換え？',
    'よく使うサービスは？',
    '割引やキャンペーン希望は？',
  ];

  @override
  Widget build(BuildContext context) {
    final totalSteps = 8;
    return Stack(
      children: [
        // 背景グラデーション
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FBFF), Color(0xFFE3F0FF), Color(0xFFF8E6FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          navigationBar: const CupertinoNavigationBar(
            middle:
                Text('携帯プラン診断', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            border: null,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // 進捗バー＋ステップ番号
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (result == null ? step + 1 : totalSteps) /
                                totalSteps,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor:
                                const AlwaysStoppedAnimation(Color(0xFFB388FF)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        result == null ? 'STEP ${step + 1}/$totalSteps' : '完了',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: '.SF Pro Display',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: result == null
                        ? _buildStep(context)
                        : _buildResult(context),
                  ),
                ),
                // 下部ナビゲーションボタン
                if (result == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _RichMainButton(
                            text: step > 0 ? '前へ' : '',
                            onPressed:
                                step > 0 ? () => setState(() => step--) : () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _RichMainButton(
                            text: step == totalSteps - 1 ? '診断結果を見る' : '次へ',
                            onPressed: () {
                              if (step == totalSteps - 1) {
                                setState(() {
                                  result = _diagnose();
                                });
                              } else {
                                setState(() => step++);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    switch (step) {
      case 0:
        return _SystemQuestionCard(
          icon: CupertinoIcons.chart_bar,
          question: questions[0],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) =>
                setState(() => dataUsage = index + 1),
            children: const [
              Text('1GB未満'),
              Text('1〜5GB'),
              Text('5〜20GB'),
              Text('20GB以上'),
            ],
          ),
          width: width,
        );
      case 1:
        return _SystemQuestionCard(
          icon: CupertinoIcons.phone,
          question: questions[1],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) =>
                setState(() => callUsage = index + 1),
            children: const [
              Text('ほとんどしない'),
              Text('たまに'),
              Text('よく使う'),
            ],
          ),
          width: width,
        );
      case 2:
        return _SystemQuestionCard(
          icon: CupertinoIcons.group,
          question: questions[2],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) => setState(() => family = index),
            children: const [
              Text('いいえ'),
              Text('はい'),
            ],
          ),
          width: width,
        );
      case 3:
        return _SystemQuestionCard(
          icon: CupertinoIcons.person,
          question: questions[3],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) => setState(() => age = index),
            children: const [
              Text('18歳未満'),
              Text('18〜29歳'),
              Text('30〜59歳'),
              Text('60歳以上'),
            ],
          ),
          width: width,
        );
      case 4:
        return _SystemQuestionCard(
          icon: CupertinoIcons.device_phone_portrait,
          question: questions[4],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) => setState(() => device = index),
            children: const [
              Text('いいえ'),
              Text('はい'),
            ],
          ),
          width: width,
        );
      case 5:
        return _SystemQuestionCard(
          icon: CupertinoIcons.person_2,
          question: questions[5],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) => setState(() => carrier = index),
            children: const [
              Text('ソフトバンク'),
              Text('他社から乗り換え'),
            ],
          ),
          width: width,
        );
      case 6:
        return _SystemQuestionCard(
          icon: CupertinoIcons.heart,
          question: questions[6],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) =>
                setState(() => service = index + 1),
            children: const [
              Text('動画・音楽'),
              Text('SNS・チャット'),
              Text('ゲーム'),
              Text('メール・通話のみ'),
            ],
          ),
          width: width,
        );
      case 7:
        return _SystemQuestionCard(
          icon: CupertinoIcons.percent,
          question: questions[7],
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (index) => setState(() => discount = index),
            children: const [
              Text('特に希望なし'),
              Text('家族割'),
              Text('学割'),
              Text('おうち割'),
              Text('基本無料'),
            ],
          ),
          width: width,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildResult(BuildContext context) {
    final List<Map<String, String>> plans = _planDetails(result ?? '');
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 40 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFB388FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(CupertinoIcons.star_fill,
                            color: Colors.white, size: 32),
                        SizedBox(width: 10),
                        Text(
                          'おすすめプラン',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: '.SF Pro Display',
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ...plans.map((plan) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.star_fill,
                                        color: Colors.amber[700], size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      plan['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: '.SF Pro Display',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  plan['desc'] ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (plan['price'] != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '月額目安: ${plan['price']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                                if (plan['url'] != null) ...[
                                  const SizedBox(height: 8),
                                  _RichMainButton(
                                    text: '公式サイトで詳細を見る',
                                    onPressed: () async {
                                      final url = Uri.parse(plan['url']!);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url,
                                            mode:
                                                LaunchMode.externalApplication);
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 32),
                    _RichMainButton(
                      text: 'もう一度診断する',
                      onPressed: () => setState(() {
                        step = 0;
                        result = null;
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _diagnose() {
    // より本格的な診断ロジック例
    if (age == 0) {
      return 'スマホデビュープラン';
    } else if (dataUsage == 1 && callUsage == 1 && family == 0) {
      return 'ミニフィットプラン';
    } else if (dataUsage >= 3 && family == 1) {
      return 'メリハリ無制限';
    } else if (callUsage == 3) {
      return 'スマホデビュープラン';
    } else if (device == 1) {
      return '新トクするサポート';
    } else if (discount == 1) {
      return '家族割';
    } else if (discount == 2) {
      return '学割';
    } else if (discount == 3) {
      return 'おうち割';
    } else {
      return 'ソフトバンクショップで最適なプランをご相談ください！';
    }
  }

  List<Map<String, String>> _planDetails(String plan) {
    switch (plan) {
      case 'スマホデビュープラン':
        return [
          {
            'name': 'スマホデビュープラン',
            'desc': '18歳以下やスマホ初心者向け。小容量・かけ放題も選べる。',
            'price': '1,078円〜',
            'url':
                'https://www.softbank.jp/mobile/price_plan/smartphone_debut/',
          },
        ];
      case 'ミニフィットプラン':
        return [
          {
            'name': 'ミニフィットプラン＋',
            'desc': 'データ通信が少なめの方向け。使った分だけお得。',
            'price': '2,178円〜',
            'url': 'https://www.softbank.jp/mobile/price_plan/minifitplus/',
          },
        ];
      case 'メリハリ無制限':
        return [
          {
            'name': 'メリハリ無制限＋',
            'desc': '家族でたっぷり使いたい方や動画・SNSヘビーユーザー向け。',
            'price': '7,238円〜',
            'url': 'https://www.softbank.jp/mobile/price_plan/merihari/',
          },
        ];
      case '新トクするサポート':
        return [
          {
            'name': '新トクするサポート＋',
            'desc': '端末購入もお得に！分割払い＋返却で割引。',
            'price': '端末により異なる',
            'url':
                'https://www.softbank.jp/mobile/campaigns/list/shintoku-support/',
          },
        ];
      case '家族割':
        return [
          {
            'name': '家族割引',
            'desc': '家族でまとめて契約すると割引。',
            'price': 'プランにより異なる',
            'url': 'https://www.softbank.jp/mobile/campaigns/list/kazoku/',
          },
        ];
      case '学割':
        return [
          {
            'name': '学割',
            'desc': '学生・若者向けの割引プラン。',
            'price': 'プランにより異なる',
            'url': 'https://www.softbank.jp/mobile/campaigns/list/gakuwari/',
          },
        ];
      case 'おうち割':
        return [
          {
            'name': 'おうち割 光セット',
            'desc': '自宅のネットとセットでスマホ料金割引。',
            'price': 'プランにより異なる',
            'url': 'https://www.softbank.jp/mobile/campaigns/list/ouchiwari/',
          },
        ];
      default:
        return [
          {
            'name': '最適なプランをご相談ください',
            'desc': 'ショップスタッフがあなたにぴったりのプランをご提案します。',
            'url': 'https://www.softbank.jp/mobile/price_plan/',
          },
        ];
    }
  }
}

// 本格的なシステム風質問カードWidget
class _SystemQuestionCard extends StatelessWidget {
  final IconData icon;
  final String question;
  final Widget child;
  final double width;

  const _SystemQuestionCard({
    required this.icon,
    required this.question,
    required this.child,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Stack(
        children: [
          // サイド装飾
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB388FF), Color(0xFF81D4FA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF81D4FA), Color(0xFFB388FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
            ),
          ),
          Container(
            width: width - 16,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB388FF), Color(0xFF81D4FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFB388FF).withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 32),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: '.SF Pro Display',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// プロフィールヘッダーWidget
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // プロフィールアイコン
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFE3F0FF),
            child: Icon(CupertinoIcons.person_solid,
                size: 36, color: Color(0xFF7B61FF)),
          ),
          const SizedBox(width: 12),
          // ユーザー名と進捗バー
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SHOOTER',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: '.SF Pro Display',
                  ),
                ),
                const SizedBox(height: 6),
                // 進捗バー（仮）
                Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFFB388FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 右側は何も表示しない
        ],
      ),
    );
  }
}

// ルーツアプリ風バナーWidget
class _RootsStyleBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E24AA), Color(0xFFFFD700)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border(
          top: BorderSide(color: Color(0xFFFFD700), width: 3),
          bottom: BorderSide(color: Color(0xFFFFD700), width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // キラキラ装飾（仮: 絵文字やアイコン）
          Positioned(
            top: 0,
            left: 0,
            child:
                Icon(CupertinoIcons.sparkles, color: Colors.white70, size: 32),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(CupertinoIcons.cube_box,
                color: Colors.amberAccent, size: 32),
          ),
          // メインテキスト
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'TITLEを獲得しよう',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: '.SF Pro Display',
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                '豪華報酬をゲット！',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 右上アイコン群Widget
class _NavBarIcons extends StatelessWidget {
  const _NavBarIcons();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(CupertinoIcons.mail, color: Color(0xFF7B61FF), size: 26),
        const SizedBox(width: 10),
        Stack(
          children: [
            Icon(CupertinoIcons.mail, color: Color(0xFF7B61FF), size: 26),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Color(0xFF7B61FF),
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Icon(CupertinoIcons.rosette, color: Color(0xFF7B61FF), size: 26),
      ],
    );
  }
}

// アカウントタブ画面（仮）
class AccountTab extends StatelessWidget {
  const AccountTab({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('アカウント'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(CupertinoIcons.person_crop_circle,
                size: 80, color: Color(0xFF7B61FF)),
            SizedBox(height: 16),
            Text('アカウント情報',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('ここにアカウント情報や設定を表示'),
          ],
        ),
      ),
    );
  }
}
