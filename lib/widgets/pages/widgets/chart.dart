import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';

class Chart extends StatelessWidget {
  Chart(this.boughtProducts, {Key? key})  : super(key: key) 
  {
    boughtProducts.sort((first,next) => first.price!.compareTo(next.price!));
  }

  final List<BoughtProduct> boughtProducts;

  double get getMaxY => boughtProducts.last.price!.roundToDouble() + 1;
  double get getMinY => boughtProducts.first.price!.roundToDouble() - 1;

  List<int> get months {
    final result = <int>[];

    for (var product in boughtProducts) {
        result.add(product.boughtDate!.month);
    }
  
    return result.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: months.length.toDouble() - 1,
          maxY: getMaxY,
          minY: getMinY,
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
              spots: const [
                // FlSpot(0.033, 1),
                // FlSpot(0.066, 3),
                // FlSpot(0.123, 1.8),
                // FlSpot(0.153, 2.14),
                // FlSpot(0.12, 1.8),
                // FlSpot(0.12, 1.8),
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
    switch (months[value.toInt()]) {
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