import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poker_hand.dart';

class PokerHandRepository {
  static const String _storageKey = 'poker_hands';
  final SharedPreferences _prefs;

  PokerHandRepository(this._prefs);

  // ハンドの保存
  Future<void> saveHand(PokerHand hand) async {
    final hands = await getHands();
    hands.add(hand);
    await _saveHands(hands);
  }

  // 全ハンドの取得
  Future<List<PokerHand>> getHands() async {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => PokerHand.fromJson(json)).toList();
  }

  // 日付範囲でハンドを取得
  Future<List<PokerHand>> getHandsByDateRange(
      DateTime start, DateTime end) async {
    final hands = await getHands();
    return hands
        .where((hand) =>
            hand.startTime.isAfter(start) && hand.startTime.isBefore(end))
        .toList();
  }

  // ショップ名でハンドを取得
  Future<List<PokerHand>> getHandsByShop(String shopName) async {
    final hands = await getHands();
    return hands.where((hand) => hand.shopName == shopName).toList();
  }

  // ハンドの削除
  Future<void> deleteHand(String id) async {
    final hands = await getHands();
    hands.removeWhere((hand) => hand.id == id);
    await _saveHands(hands);
  }

  // 統計情報の取得
  Future<Map<String, dynamic>> getStatistics() async {
    final hands = await getHands();
    if (hands.isEmpty) {
      return {
        'totalHands': 0,
        'winRate': 0.0,
        'totalProfit': 0,
        'averageProfit': 0.0,
      };
    }

    final winningHands = hands.where((hand) => hand.isWin).length;
    final totalProfit =
        hands.fold<int>(0, (sum, hand) => sum + (hand.result ?? 0));

    return {
      'totalHands': hands.length,
      'winRate': winningHands / hands.length,
      'totalProfit': totalProfit,
      'averageProfit': totalProfit / hands.length,
    };
  }

  // 内部メソッド：ハンドの保存
  Future<void> _saveHands(List<PokerHand> hands) async {
    final jsonList = hands.map((hand) => hand.toJson()).toList();
    await _prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
