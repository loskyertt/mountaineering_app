import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF98B1BF),
      appBar: AppBar(title: Text("设置")),
      body: ListView(
        children: [
          ListTile(title: Text("用户信息"), onTap: () {}),
          ListTile(title: Text("装备建议"), onTap: () {}),
          ListTile(title: Text("数据同步设置"), onTap: () {}),
          ListTile(title: Text("安全提醒设置"), onTap: () {}),
        ],
      ),
    );
  }
}
