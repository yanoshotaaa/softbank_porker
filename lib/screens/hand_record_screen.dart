import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/poker_hand.dart';
import '../repositories/poker_hand_repository.dart';

class HandRecordScreen extends StatefulWidget {
  const HandRecordScreen({super.key});

  @override
  State<HandRecordScreen> createState() => _HandRecordScreenState();
}

class _HandRecordScreenState extends State<HandRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  Position _selectedPosition = Position.btn;
  String _shopName = '';
  String _tableName = '';
  final List<PokerAction> _actions = [];
  Street _currentStreet = Street.preflop;
  int _currentAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ハンド記録'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // ショップ情報
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ショップ名',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ショップ名を入力してください';
                }
                return null;
              },
              onSaved: (value) => _shopName = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'テーブル名',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'テーブル名を入力してください';
                }
                return null;
              },
              onSaved: (value) => _tableName = value!,
            ),
            const SizedBox(height: 16),

            // ポジション選択
            DropdownButtonFormField<Position>(
              decoration: const InputDecoration(
                labelText: 'ポジション',
                border: OutlineInputBorder(),
              ),
              value: _selectedPosition,
              items: Position.values.map((position) {
                return DropdownMenuItem(
                  value: position,
                  child: Text(position.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPosition = value);
                }
              },
            ),
            const SizedBox(height: 24),

            // アクション記録
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'アクション記録',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Street>(
                            decoration: const InputDecoration(
                              labelText: 'ストリート',
                              border: OutlineInputBorder(),
                            ),
                            value: _currentStreet,
                            items: Street.values.map((street) {
                              return DropdownMenuItem(
                                value: street,
                                child: Text(street.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _currentStreet = value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<PokerActionType>(
                            decoration: const InputDecoration(
                              labelText: 'アクション',
                              border: OutlineInputBorder(),
                            ),
                            items: PokerActionType.values.map((action) {
                              return DropdownMenuItem(
                                value: action,
                                child: Text(action.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _actions.add(PokerAction(
                                    action: value,
                                    amount: _currentAmount,
                                    street: _currentStreet,
                                  ));
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'ベット額',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _currentAmount = int.tryParse(value) ?? 0;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 記録されたアクションの表示
            if (_actions.isNotEmpty) ...[
              const Text(
                '記録されたアクション',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _actions.length,
                itemBuilder: (context, index) {
                  final action = _actions[index];
                  return ListTile(
                    title: Text(
                        '${action.street.toString().split('.').last}: ${action.action.toString().split('.').last}'),
                    subtitle: Text('${action.amount}円'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _actions.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveHand,
              child: const Text('ハンドを保存'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHand() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final hand = PokerHand(
        id: const Uuid().v4(),
        startTime: DateTime.now(),
        position: _selectedPosition,
        actions: List.from(_actions),
        shopName: _shopName,
        tableName: _tableName,
      );

      final repository = context.read<PokerHandRepository>();
      await repository.saveHand(hand);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ハンドを保存しました')),
        );
        Navigator.pop(context);
      }
    }
  }
}
