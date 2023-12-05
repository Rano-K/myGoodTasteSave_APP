import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPlace extends StatefulWidget {
  final double lat;
  final double lng;
  const MapPlace({super.key, required this.lat, required this.lng});

  @override
  State<MapPlace> createState() => _MapPlaceState();
}

class _MapPlaceState extends State<MapPlace> {
  late MapController mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('map')),
      body: Center(
        child: Column(
          children: [
            Text('위도 : ${widget.lat}'),
            Text('경도 : ${widget.lng}'),
          ],
        ),
      ),
    );
  }
}