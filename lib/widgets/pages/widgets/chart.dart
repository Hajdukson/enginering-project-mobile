
import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:path/path.dart';

class Chart extends StatelessWidget {
  Chart(this.boughtProducts, {Key? key})  : super(key: key) 
  {
    boughtProducts.sort((first, next) => first.boughtDate!.compareTo(next.boughtDate!));
  }

  final List<BoughtProduct> boughtProducts;

  List<double> get maxDimValues {
    var prcies = boughtProducts.map((e) => e.price).toList();
    prcies.sort();
    return [prcies.first!.roundToDouble() - 1, prcies.last!.roundToDouble() + 1];
  }
  
  Map<int, int> get daysInMonths {
    Map<int, int> result = {};
    var dateUtility = DateUtil();
    for(int i = 0; i < boughtProducts.length; i++) {
      var month = boughtProducts[i].boughtDate!.month;
      var year = boughtProducts[i].boughtDate!.year;
      var days = dateUtility.daysInMonth(month, year);
      result[month] = days;
      if(i == boughtProducts.length - 1) {
        days = dateUtility.daysInMonth(month + 1, month == 12 ? year + 1 : year);
        result[month + 1] = days;
      }
    }
    return result;
  }

  List<FlSpot> drawChart() {
    List<FlSpot> chartValues = [];
    var dateUtility = DateUtil();

    double monthIndex = 0;
    double monthFactor = 0;
    for (var product in boughtProducts) {
      if(product.boughtDate!.month > daysInMonths.keys.first) {
        for(int i = daysInMonths.keys.first; i < product.boughtDate!.month; i++) {
          monthIndex++;
          if(i == product.boughtDate!.month - 1) {
            monthFactor = 1 / dateUtility.daysInMonth(i, product.boughtDate!.year);
          }
        }
        chartValues.add(FlSpot((product.boughtDate!.day * monthFactor) + monthIndex, product.price!));  
      }
      else {
        monthFactor = 1 / dateUtility.daysInMonth(product.boughtDate!.month, product.boughtDate!.year);
        chartValues.add(FlSpot(product.boughtDate!.day * monthFactor, product.price!));
      }
      monthIndex = 0;
    }
    return chartValues;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: daysInMonths.length.toDouble() - 1,
          maxY: maxDimValues[1],
          minY: maxDimValues[0],
          gridData: FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0,
              color: const Color(0x444af699),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              spots: [
                ...drawChart()
              ],
            )
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
              ),),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: leftTitles(),
            ),),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Color(0xff4e4965), width: 4),
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          )
        )
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (daysInMonths.keys.toList()[value.toInt()]) {
      case 1:
        text = const Text('st', style: style);
        break;
      case 2:
        text = const Text('lut', style: style);
        break;
      case 3:
        text = const Text('mrz', style: style);
        break;
      case 4:
        text = const Text('kw', style: style);
        break;
      case 5:
        text = const Text('maj', style: style);
        break;
      case 6:
        text = const Text('cz', style: style);
        break;
      case 7:
        text = const Text('lip', style: style);
        break;
      case 8:
        text = const Text('sier', style: style);
        break;
      case 9:
        text = const Text('wrz', style: style);
        break;
      case 10:
        text = const Text('paź', style: style);
        break;
      case 11:
        text = const Text('lis', style: style);
        break;
      case 12:
        text = const Text('gr', style: style);
        break;
      default:
        text = const Text('');
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,);
  }

  SideTitles leftTitles() => SideTitles(
      getTitlesWidget: leftTitleWidgets,
      showTitles: true,
      interval: 1,
      reservedSize: 40,
    );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = "${value.toStringAsFixed(0)} PLN";

    return Text(text, style: style, textAlign: TextAlign.center);
  }
}