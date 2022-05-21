import 'package:bot_md/constants.dart';
import 'package:bot_md/globals_.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

const List<Color> availableColors = [
  Colors.purpleAccent,
  Colors.yellow,
  Colors.lightBlue,
  Colors.orange,
  Colors.pink,
  Colors.redAccent,
];
const Color barBackgroundColor = Color(0xff72d8bf);
const Duration animDuration = Duration(milliseconds: 250);

RxInt touchedIndex = RxInt(-1);

showBarData() {
  return InkWell(
    onTap: () {
      print(vaccData.value);
    },
    child: AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [boxShad(5, 5, 20)],
          borderRadius: BorderRadius.circular(21),
          gradient: LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    montserratText(
                      text: "Vaccinations",
                      weight: FontWeight.w500,
                      size: 22,
                      align: TextAlign.start,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    montserratText(
                      text:
                          "Vaccinations where cases of ReCovid have been recorded",
                      weight: FontWeight.w400,
                      size: 14,
                      align: TextAlign.start,
                      color: Colors.white54,
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

BarChartGroupData makeGroupData(
  int x,
  double y, {
  bool isTouched = false,
  Color barColor = Colors.white,
  double width = 22,
  List<int> showTooltips = const [],
}) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: isTouched ? y + 1 : y,
        color: isTouched ? Colors.yellow[300] : Colors.white,
        width: width,
        borderSide: isTouched
            ? BorderSide(color: Colors.yellow[300]!, width: 1)
            : const BorderSide(color: Colors.white, width: 0),
        // backDrawRodData: BackgroundBarChartRodData(
        //   show: true,
        //   toY: 20,
        //   color: primaryColor,
        // ),
      ),
    ],
    showingTooltipIndicators: showTooltips,
  );
}

// List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
//       switch (i) {
//         case 0:
//           return makeGroupData(0, 5, isTouched: i == touchedIndex.value);
//         case 1:
//           return makeGroupData(1, 6.5, isTouched: i == touchedIndex.value);
//         case 2:
//           return makeGroupData(2, 5, isTouched: i == touchedIndex.value);
//         case 3:
//           return makeGroupData(3, 7.5, isTouched: i == touchedIndex.value);
//         case 4:
//           return makeGroupData(4, 9, isTouched: i == touchedIndex.value);
//         case 5:
//           return makeGroupData(5, 11.5, isTouched: i == touchedIndex.value);
//         case 6:
//           return makeGroupData(6, 6.5, isTouched: i == touchedIndex.value);
//         default:
//           return throw Error();
//       }
//     });

List<BarChartGroupData> showingGroups() => vaccData.value.keys.map((e) {
      return makeGroupData(
          vaccData.value.keys.toList().indexOf(e), vaccData.value[e].toDouble(),
          isTouched:
              vaccData.value.keys.toList().indexOf(e) == touchedIndex.value);
    }).toList();

BarChartData mainBarData() {
  return BarChartData(
    barTouchData: BarTouchData(
      touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x.toInt()) {
              case 0:
                weekDay = 'Moderna';
                break;
              case 1:
                weekDay = 'Pfizer';
                break;
              case 2:
                weekDay = 'Cansino';
                break;
              case 3:
                weekDay = 'Gamaleya';
                break;
              case 4:
                weekDay = 'AstraZeneca';
                break;
              case 5:
                weekDay = 'Sinopharm';
                break;
              case 6:
                weekDay = 'Sinovac';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              weekDay + '\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),
      touchCallback: (FlTouchEvent event, barTouchResponse) {
        // setState(() {
        if (!event.isInterestedForInteractions ||
            barTouchResponse == null ||
            barTouchResponse.spot == null) {
          touchedIndex.value = -1;
          return;
        }
        touchedIndex.value = barTouchResponse.spot!.touchedBarGroupIndex;
        // });
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: getTitles,
          reservedSize: 38,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    barGroups: showingGroups(),
    gridData: FlGridData(show: false),
  );
}

Widget getTitles(double value, TitleMeta meta) {
  // print(meta.);
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  // List.generate(7, (i) {
  switch (value.toInt()) {
    case 0:
      text = const Text('M', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
    case 1:
      text = const Text('P', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
    case 2:
      text = const Text('C', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
    case 3:
      text = const Text('G', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
    case 4:
      text = const Text('A', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
    case 5:
      text = const Text('SP', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
    case 6:
      text = const Text('SV', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
    default:
      text = const Text('', style: style);
      return Padding(padding: const EdgeInsets.only(top: 16), child: text);
  }
  // });
  return Text('');
}
