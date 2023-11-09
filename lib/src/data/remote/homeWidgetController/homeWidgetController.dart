import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart' as location_plugin;
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../core/api.dart';

class LocationService extends GetxController {
  location_plugin.Location? location;
  final RxList<LocationData> _locations = <LocationData>[].obs;
  var restaurantData = RxList();

  @override
  void onInit() {
    super.onInit();
    location = location_plugin.Location();
  }

  Future<void> fetchLastKnownLocation() async {
    try {
      location = location_plugin.Location();
      bool serviceEnabled;
      PermissionStatus permission;

      serviceEnabled = await location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location!.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permission = await location!.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location!.requestPermission();
        if (permission != PermissionStatus.granted) {
          return;
        }
      }

      final locationData = await location!.getLocation();
      _locations.assignAll([locationData]);
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<String> getAddressFromCoordinates(
      double? latitude, double? longitude) async {
    print("#################################");
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude!, longitude!);
    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];
      print("#################################");
      print(placemark.toJson());
      return '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}';
    } else {
      return 'No address found';
    }
  }

  Future<dynamic> getRestaurantdata(double? latitude,double? longitude) async {
    restaurantData.clear();
    final api = Api(); // Create an instance of your API class
    // Replace with the correct GetConnect call
    final response = await api.sendRequest.post("get_resturants", data: {
      "lat": latitude ?? 0.0,
      "lng": longitude ?? 0.0,
    });

    // Handle the response based on your GetConnect setup
    if (response.data["status"] == "failed") {
      throw "Failed to verify otp..!";
    } else {
      restaurantData.assignAll(response.data["data"]);
      print("----------------------------------------");
      print(restaurantData);
      return response.data;
    }
  }

  RxList<LocationData> get locationHistory => _locations;
}
