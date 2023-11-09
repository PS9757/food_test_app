import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/remote/homeWidgetController/homeWidgetController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService locationService = LocationService();
  bool isLoading = false;
  var addressFuture; // Future for the address

  @override
  void initState() {
    super.initState();
    print("Initiating fetchLocationAndAddress");
    // fetchLocationAndAddress();
    fetchRestaurantData();
  }

  Future<void> fetchRestaurantData() async {
    try {
      isLoading = true;
      await locationService.fetchLastKnownLocation();
      if (locationService.locationHistory.isNotEmpty) {
        final locationData = locationService.locationHistory.last;
        var restaurantData = await locationService.getRestaurantdata(
          locationData.latitude ?? 0.0,
          locationData.longitude ?? 0.0,
        );
        setState(() {
          restaurantData = Future.value(restaurantData);
          fetchLocationAndAddress();
        });
        isLoading = false;
      }
    } catch (e) {
      print("----------------------------------------");
      print('Error fetching restaurant data: $e');
    }
  }

  Future<void> fetchLocationAndAddress() async {
    try {
      await locationService.fetchLastKnownLocation();
      print("23545236");
      if (locationService.locationHistory.isNotEmpty) {
        final locationData = locationService.locationHistory.last;
        final address = await locationService.getAddressFromCoordinates(
          locationData.latitude ?? 0.0,
          locationData.longitude ?? 0.0,
        );
        setState(() {
          addressFuture = Future.value(address);
        });
      } else {
        print('No location history available.');
      }
    } catch (e) {
      print("----------------------------------------");
      print('Error fetching location and address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 225, 225, 1),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                if (locationService.locationHistory.isNotEmpty)
                  // Text('Last Known Location:'),
                  if (locationService.locationHistory.isNotEmpty)
                    // Text(
                    //     'Latitude: ${locationService.locationHistory.last.latitude}'),
                    if (locationService.locationHistory.isNotEmpty)
                      // Text(
                      //     'Longitude: ${locationService.locationHistory.last.longitude}'),
                      FutureBuilder<String>(
                        future: addressFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on),
                                Text(
                                  '${snapshot.data}',
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff000000),
                                    height: 21 / 14,
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Container();
                        },
                      ),
                //search bar
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(29.5),
                  ),
                  child: TextField(
                    onTapOutside: (focusNode) {
                      FocusScope.of(context).unfocus();
                    },
                    cursorColor: Color.fromRGBO(218, 88, 88, 1.0),
                    decoration: InputDecoration(
                      hintText: "Search",
                      icon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nearby Restaurants",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: isLoading,
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
                Visibility(
                  visible: locationService.restaurantData.isNotEmpty,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      itemCount: locationService.restaurantData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            locationService.restaurantData[index]
                                                ["primary_image"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            locationService.restaurantData[index]
                                                ["name"],
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000),
                                              height: 24 / 16,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.percent_rounded,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              "${locationService.restaurantData[index]["discount"]}% FLAT OFF",
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.red,
                                                height: 18 / 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                bottom: 65,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 9),
                                  height: 25,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        locationService.restaurantData[index]
                                                ["rating"]
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                Visibility(
                  visible: locationService.restaurantData.isEmpty&&isLoading==false,
                  child: Center(
                    child: Text("No Restaurants Found"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
