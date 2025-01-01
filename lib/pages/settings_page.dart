// import 'package:flutter/material.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF98B1BF),
//       appBar: AppBar(title: Text("设置")),
//       body: ListView(
//         children: [
//           ListTile(title: Text("用户信息"), onTap: () {}),
//           ListTile(title: Text("装备建议"), onTap: () {}),
//           ListTile(title: Text("数据同步设置"), onTap: () {}),
//           ListTile(title: Text("安全提醒设置"), onTap: () {}),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 示例数据
  double userHeight = 170.0;
  double userWeight = 65.0;
  String medicalHistory = "";
  double safetyThreshold = 90.0; // 血氧阈值示例
  String equipmentSuggestion = "建议穿着保暖衣物，携带足够水源和食物。";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置'), centerTitle: true),
      body: ListView(
        children: [
          _buildUserInfoTile(),
          _buildEquipmentSuggestionTile(),
          _buildDataSyncTile(),
          _buildSafetyReminderTile(),
        ],
      ),
    );
  }

  // 用户信息模块
  Widget _buildUserInfoTile() {
    return ExpansionTile(
      title: Text('用户信息'),
      leading: Icon(Icons.person),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildSlider(
                label: "身高 (cm)",
                value: userHeight,
                min: 100,
                max: 220,
                onChanged: (newValue) {
                  setState(() {
                    userHeight = newValue;
                  });
                },
              ),
              _buildSlider(
                label: "体重 (kg)",
                value: userWeight,
                min: 30,
                max: 150,
                onChanged: (newValue) {
                  setState(() {
                    userWeight = newValue;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: '过往病史',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    medicalHistory = value;
                  });
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  // 装备建议模块
  Widget _buildEquipmentSuggestionTile() {
    return ListTile(
      title: Text('装备建议'),
      leading: Icon(Icons.backpack),
      subtitle: Text(equipmentSuggestion),
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('装备建议'),
                content: Text(equipmentSuggestion),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('确定'),
                  ),
                ],
              ),
        );
      },
    );
  }

  // 数据同步设置模块
  Widget _buildDataSyncTile() {
    return ListTile(
      title: Text('数据同步设置'),
      leading: Icon(Icons.sync),
      trailing: Switch(
        value: true,
        onChanged: (value) {
          // 示例实现
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('数据同步功能尚未实现')));
        },
      ),
    );
  }

  // 安全提醒模块
  Widget _buildSafetyReminderTile() {
    return ExpansionTile(
      title: Text('安全提醒设置'),
      leading: Icon(Icons.warning),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildSlider(
                label: "血氧阈值 (%)",
                value: safetyThreshold,
                min: 50,
                max: 100,
                onChanged: (newValue) {
                  setState(() {
                    safetyThreshold = newValue;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                "设置低于 $safetyThreshold% 时的血氧提醒阈值。",
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  // 通用滑块构建
  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toStringAsFixed(1)}",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
