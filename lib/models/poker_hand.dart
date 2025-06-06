import 'package:flutter/foundation.dart';

enum Position {
  sb, // スモールブラインド
  bb, // ビッグブラインド
  utg, // アンダーザガン
  utg1,
  mp, // ミドルポジション
  mp1,
  hj, // ハイジャック
  co, // カットオフ
  btn, // ボタン
}

enum PokerActionType {
  fold,
  check,
  call,
  bet,
  raise,
  allIn,
}

enum Street {
  preflop,
  flop,
  turn,
  river,
}

class PokerAction {
  final PokerActionType action;
  final int amount;
  final Street street;

  PokerAction({
    required this.action,
    required this.amount,
    required this.street,
  });
}

class PokerHand {
  final String id;
  final DateTime startTime;
  final Position position;
  final List<PokerAction> actions;
  final int? result; // 正の値が勝ち、負の値が負け
  final String shopName;
  final String tableName;

  PokerHand({
    required this.id,
    required this.startTime,
    required this.position,
    required this.actions,
    this.result,
    required this.shopName,
    required this.tableName,
  });

  // 統計情報を計算するメソッド
  int get totalBet => actions.fold(0, (sum, action) => sum + action.amount);

  bool get isWin => result != null && result! > 0;

  // JSON変換メソッド
  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'position': position.toString(),
        'actions': actions
            .map((a) => {
                  'action': a.action.toString(),
                  'amount': a.amount,
                  'street': a.street.toString(),
                })
            .toList(),
        'result': result,
        'shopName': shopName,
        'tableName': tableName,
      };

  factory PokerHand.fromJson(Map<String, dynamic> json) {
    return PokerHand(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      position: Position.values.firstWhere(
        (e) => e.toString() == json['position'],
      ),
      actions: (json['actions'] as List)
          .map((a) => PokerAction(
                action: PokerActionType.values.firstWhere(
                  (e) => e.toString() == a['action'],
                ),
                amount: a['amount'],
                street: Street.values.firstWhere(
                  (e) => e.toString() == a['street'],
                ),
              ))
          .toList(),
      result: json['result'],
      shopName: json['shopName'],
      tableName: json['tableName'],
    );
  }
}
