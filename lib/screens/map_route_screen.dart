import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';
import '../components/button.dart';

class MapRouteScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;

  const MapRouteScreen({
    Key? key,
    required this.destinationLat,
    required this.destinationLng,
  }) : super(key: key);

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentLocation;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  Future<void> _getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    final permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      if (await location.requestPermission() != PermissionStatus.granted)
        return;
    }

    final currentLoc = await location.getLocation();
    setState(() {
      _currentLocation = currentLoc;
    });

    await _setRoutePolyline();
  }

  Future<void> _setRoutePolyline() async {
    if (_currentLocation == null) return;

    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBs4fyc_D7rmDe_nvEjWZ31MbhIwvZjMSE',
      PointLatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      PointLatLng(widget.destinationLat, widget.destinationLng),
    );

    if (result.points.isNotEmpty) {
      final List<LatLng> routeCoords =
          result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('delivery_route'),
            color: AppColors.primary,
            width: 5,
            points: routeCoords,
          ),
        };

        _markers = {
          Marker(
            markerId: const MarkerId('courier'),
            position: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            infoWindow: const InfoWindow(title: 'Kurir'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(widget.destinationLat, widget.destinationLng),
            infoWindow: const InfoWindow(title: 'Pelanggan'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        };
      });

      final controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(_getBounds(routeCoords), 80),
      );
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _launchGoogleMaps() async {
    if (_currentLocation == null) return;

    final originLat = _currentLocation!.latitude!;
    final originLng = _currentLocation!.longitude!;
    final destLat = widget.destinationLat;
    final destLng = widget.destinationLng;

    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng&travelmode=driving';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Rute Pengantaran',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
                      zoom: 14.0,
                    ),
                    onMapCreated:
                        (controller) => _controller.complete(controller),
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                  Positioned(
                    bottom: 50,
                    left: 20,
                    right: 20,
                    child: CustomButton(
                      text: 'Mulai Navigasi',
                      onPressed: _launchGoogleMaps,
                    ),
                  ),
                ],
              ),
    );
  }
}
