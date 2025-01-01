// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class RiskMapPage extends StatefulWidget {
//   const RiskMapPage({super.key});

//   @override
//   _RiskMapPageState createState() => _RiskMapPageState();
// }

// class _RiskMapPageState extends State<RiskMapPage> {
//   final MapController _mapController = MapController();

//   // 示例数据
//   final LatLng userLocation = LatLng(30.6586, 104.0647); // 用户位置
//   final List<LatLng> trailPoints = [
//     LatLng(30.6570, 104.0600),
//     LatLng(30.6590, 104.0630),
//     LatLng(30.6620, 104.0650),
//   ]; // 示例步道

//   final List<LatLng> riskZones = [
//     LatLng(30.6600, 104.0620),
//     LatLng(30.6610, 104.0660),
//   ]; // 示例风险区域

//   final List<LatLng> rescueResources = [
//     LatLng(30.6630, 104.0680), // 救援站
//     LatLng(30.6580, 104.0610), // 医疗站
//   ]; // 示例资源点

//   // 地图图层开关
//   bool showTrail = true;
//   bool showRescueResources = true;
//   bool showWeatherLayer = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('风险地图'), centerTitle: true),
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: userLocation,
//               initialZoom: 13.0,
//               maxZoom: 18.0,
//               minZoom: 5.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 subdomains: ['a', 'b', 'c'],
//               ),
//               if (showTrail) _buildTrailLayer(),
//               _buildRiskZoneLayer(),
//               if (showRescueResources) _buildRescueResourceLayer(),
//             ],
//           ),
//           _buildMapControls(),
//         ],
//       ),
//     );
//   }

//   // 步道图层
//   PolylineLayer _buildTrailLayer() {
//     return PolylineLayer(
//       polylines: [
//         Polyline(points: trailPoints, color: Colors.green, strokeWidth: 4.0),
//       ],
//     );
//   }

//   // 风险区域图层
//   CircleLayer _buildRiskZoneLayer() {
//     return CircleLayer(
//       circles:
//           riskZones
//               .map(
//                 (zone) => CircleMarker(
//                   point: zone,
//                   radius: 40.0,
//                   color: Colors.red,
//                   useRadiusInMeter: true,
//                 ),
//               )
//               .toList(),
//     );
//   }

//   // 资源点图层
//   MarkerLayer _buildRescueResourceLayer() {
//     return MarkerLayer(
//       markers:
//           rescueResources
//               .map(
//                 (resource) => Marker(
//                   point: resource,
//                   width: 40.0,
//                   height: 40.0,
//                   child: Icon(
//                     Icons.local_hospital,
//                     color: Colors.blue,
//                     size: 30.0,
//                   ),
//                 ),
//               )
//               .toList(),
//     );
//   }

//   // 地图控制面板
//   Positioned _buildMapControls() {
//     return Positioned(
//       top: 10,
//       right: 10,
//       child: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 showTrail = !showTrail;
//               });
//             },
//             child: Text(showTrail ? '隐藏步道' : '显示步道'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 showRescueResources = !showRescueResources;
//               });
//             },
//             child: Text(showRescueResources ? '隐藏资源点' : '显示资源点'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 showWeatherLayer = !showWeatherLayer;
//               });
//             },
//             child: Text(showWeatherLayer ? '隐藏天气' : '显示天气'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class RiskMapPage extends StatefulWidget {
  const RiskMapPage({super.key});

  @override
  _RiskMapPageState createState() => _RiskMapPageState();
}

class _RiskMapPageState extends State<RiskMapPage> {
  final MapController _mapController = MapController();

  // 示例数据
  LatLng? userLocation; // 用户位置
  final List<LatLng> trailPoints = [
    LatLng(30.6570, 104.0600),
    LatLng(30.6590, 104.0630),
    LatLng(30.6620, 104.0650),
  ]; // 示例步道

  final List<LatLng> riskZones = [
    LatLng(30.6600, 104.0620),
    LatLng(30.6610, 104.0660),
  ]; // 示例风险区域

  final List<LatLng> rescueResources = [
    LatLng(30.6630, 104.0680), // 救援站
    LatLng(30.6580, 104.0610), // 医疗站
  ]; // 示例资源点

  // 地图图层开关
  bool showTrail = true;
  bool showRescueResources = true;
  bool showWeatherLayer = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 检查位置服务是否启用
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 位置服务未启用，无法获取位置
      return;
    }

    // 检查权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 权限被拒绝，无法获取位置
        return;
      }
    }

    // 获取当前位置
    if (permission == LocationPermission.deniedForever) {
      // 权限被永久拒绝，我们无法请求权限
      return;
    } else {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          13.0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('风险地图'), centerTitle: true),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  userLocation ??
                  LatLng(30.6586, 104.0647), // 如果没有获取到位置，则使用默认位置
              initialZoom: 13.0,
              maxZoom: 18.0,
              minZoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (showTrail) _buildTrailLayer(),
              _buildRiskZoneLayer(),
              if (showRescueResources) _buildRescueResourceLayer(),
              if (userLocation != null) _buildUserLocationMarker(),
            ],
          ),
          _buildMapControls(),
        ],
      ),
    );
  }

  // 步道图层
  PolylineLayer _buildTrailLayer() {
    return PolylineLayer(
      polylines: [
        Polyline(points: trailPoints, color: Colors.green, strokeWidth: 4.0),
      ],
    );
  }

  // 风险区域图层
  CircleLayer _buildRiskZoneLayer() {
    return CircleLayer(
      circles:
          riskZones
              .map(
                (zone) => CircleMarker(
                  point: zone,
                  radius: 40.0,
                  color: Colors.red,
                  useRadiusInMeter: true,
                ),
              )
              .toList(),
    );
  }

  // 资源点图层
  MarkerLayer _buildRescueResourceLayer() {
    return MarkerLayer(
      markers:
          rescueResources
              .map(
                (resource) => Marker(
                  point: resource,
                  width: 40.0,
                  height: 40.0,
                  child: Icon(
                    Icons.local_hospital,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),
              )
              .toList(),
    );
  }

  // 用户位置标记
  MarkerLayer _buildUserLocationMarker() {
    return MarkerLayer(
      markers: [
        Marker(
          point: userLocation!,
          width: 50.0,
          height: 50.0,
          child: Icon(Icons.location_pin, color: Colors.red, size: 30.0),
        ),
      ],
    );
  }

  // 地图控制面板
  Positioned _buildMapControls() {
    return Positioned(
      top: 10,
      right: 10,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                showTrail = !showTrail;
              });
            },
            child: Text(showTrail ? '隐藏步道' : '显示步道'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showRescueResources = !showRescueResources;
              });
            },
            child: Text(showRescueResources ? '隐藏资源点' : '显示资源点'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showWeatherLayer = !showWeatherLayer;
              });
            },
            child: Text(showWeatherLayer ? '隐藏天气' : '显示天气'),
          ),
        ],
      ),
    );
  }
}
