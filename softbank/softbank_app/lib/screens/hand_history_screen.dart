import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/poker_hand.dart';
import '../repositories/poker_hand_repository.dart';

class HandHistoryScreen extends StatelessWidget {
  const HandHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('ハンド履歴'),
      ),
      child: SafeArea(
        child: FutureBuilder<List<PokerHand>>(
          future: context.read<PokerHandRepository>().getHands(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'エラーが発生しました: ${snapshot.error}',
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              );
            }

            final hands = snapshot.data ?? [];
            if (hands.isEmpty) {
              return const Center(
                child: Text(
                  '記録されたハンドはありません',
                  style: TextStyle(color: CupertinoColors.systemGrey),
                ),
              );
            }

            return ListView.builder(
              itemCount: hands.length,
              itemBuilder: (context, index) {
                final hand = hands[index];
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
                    '${DateFormat('yyyy/MM/dd HH:mm').format(hand.startTime)} - ${hand.shopName}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'テーブル: ${hand.tableName} - ポジション: ${hand.position.toString().split('.').last}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text('アクション履歴'),
                        message: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...hand.actions.map((action) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    '${action.street.toString().split('.').last}: ${action.action.toString().split('.').last} - ${action.amount}円',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )),
                            const Divider(),
                            Text(
                              '合計ベット額: ${hand.totalBet}円',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (hand.result != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                '結果: ${hand.result! > 0 ? '+' : ''}${hand.result}円',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: hand.result! > 0
                                      ? CupertinoColors.systemGreen
                                      : CupertinoColors.systemRed,
                                ),
                              ),
                            ],
                          ],
                        ),
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('閉じる'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
