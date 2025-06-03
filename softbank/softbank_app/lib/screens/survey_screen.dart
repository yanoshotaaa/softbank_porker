import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int satisfaction = 3;
  int atmosphere = 3;
  int staff = 3;
  String feedback = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アンケート'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('今日の満足度',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: satisfaction.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: satisfaction.toString(),
                onChanged: (value) {
                  setState(() => satisfaction = value.toInt());
                },
              ),
              const SizedBox(height: 16),
              const Text('お店の雰囲気',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: atmosphere.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: atmosphere.toString(),
                onChanged: (value) {
                  setState(() => atmosphere = value.toInt());
                },
              ),
              const SizedBox(height: 16),
              const Text('スタッフ対応',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: staff.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: staff.toString(),
                onChanged: (value) {
                  setState(() => staff = value.toInt());
                },
              ),
              const SizedBox(height: 16),
              const Text('ご意見・ご要望',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '自由にご記入ください',
                ),
                onChanged: (value) => feedback = value,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: 回答保存処理
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('送信完了'),
                        content: const Text('ご協力ありがとうございました！'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('閉じる'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('送信'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
