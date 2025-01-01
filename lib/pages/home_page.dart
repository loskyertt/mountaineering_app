import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCCD0CF),
      appBar: AppBar(
        title: Text("首页"),
        actions: [
          Icon(Icons.cloud), // 天气图标
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: Text("晴 / 1200m")),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: ListTile(
              title: Text("健康数据"),
              subtitle: Text("心率: 80次/分, 步数: 1200步, 血氧: 98%"),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                _buildQuickButton(Icons.share, "位置共享"),
                _buildQuickButton(Icons.warning, "风险预警"),
                _buildQuickButton(Icons.sos, "SOS求助"),
                _buildQuickButton(Icons.directions_walk, "登山记录"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(IconData icon, String label) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Color.fromARGB(255, 72, 105, 107),
      child: InkWell(
        onTap: () {}, // 添加功能事件
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, size: 40), SizedBox(height: 8), Text(label)],
        ),
      ),
    );
  }
}
