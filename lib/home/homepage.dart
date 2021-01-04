import 'package:expire_item/home/detail_page.dart';
import 'package:expire_item/models/device_data.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  final List<DeviceData> deviceData;
  const HomePage({Key key, this.deviceData}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<DeviceData> deviceData = widget.deviceData;
    String _calculateTimeLeft(int y, int m, int d) {
      String timeLeft;
      if (!(y <= 0)) {
        timeLeft = '$y Year\'s Left';
      } else if (!(m <= 0)) {
        timeLeft = '$m Month\'s Left';
      } else if (!(d <= 0)) {
        timeLeft = '$d Day\'s Left';
      } else {
        timeLeft = 'Expired';
      }
      return timeLeft;
    }

    return Scaffold(
      backgroundColor: c3,
      body: SafeArea(
          child: Stack(children: [
        Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/icons/dire.png', fit: BoxFit.cover)),
        Container(
            margin: EdgeInsets.all(10.0),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: deviceData.length,
              itemBuilder: (BuildContext context, int index) {
                int i = deviceData[index].deviceName.indexOf('#');
                Jiffy jiffy1 = Jiffy(deviceData[index].expeiryDate);
                Jiffy jiffy2 = Jiffy(DateTime.now().toString());
                jiffy1.add(duration: Duration(days: 1));

                int yearLeft = jiffy1.diff(jiffy2, Units.YEAR).toInt();
                int monthLeft = jiffy1.diff(jiffy2, Units.MONTH).toInt();
                int dayLeft = jiffy1.diff(jiffy2, Units.DAY).toInt();

                return GestureDetector(
                  onTap: () {
                    print(index);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  deviceData: deviceData[index],
                                  timeLeft: _calculateTimeLeft(
                                      yearLeft, monthLeft, dayLeft),
                                  name: deviceData[index]
                                      .deviceName
                                      .substring(0, i),
                                  dayLeft: dayLeft,
                                )));
                  },
                  child: Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: [
                        Stack(children: [
                          SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: deviceData[index].deviceImageUrl != null
                                  ? Image.network(
                                      deviceData[index].deviceImageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/icons/Default_Device.png'),
                            ),
                          ),
                          Positioned(
                              right: 10.0,
                              bottom: 10.0,
                              child: Image.asset(
                                'assets/icons/multi image.png',
                                fit: BoxFit.cover,
                                color: c1,
                                height: 20.0,
                                width: 20.0,
                              ))
                        ]),
                        Container(
                          alignment: Alignment.center,
                          child: Card(
                            elevation: 0.0,
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                    deviceData[index]
                                        .deviceName
                                        .substring(0, i),
                                    style: TextStyle(
                                        color: c1,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                    _calculateTimeLeft(
                                        yearLeft, monthLeft, dayLeft),
                                    style: TextStyle(
                                        color: dayLeft <= 0
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )),
      ])),
    );
  }
}
