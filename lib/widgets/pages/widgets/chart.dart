
import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/models/bought_product.dart';

class Chart extends StatefulWidget {
  Chart(this.boughtProducts, {Key? key})  : super(key: key) 
  {
    boughtProducts.sort((first, next) => first.boughtDate!.compareTo(next.boughtDate!));
  }

  final List<BoughtProduct> boughtProducts;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late int showingTooltipSpot;

  @override
  void initState(){
    showingTooltipSpot = -1;
    super.initState();
  }


  List<double> get maxDimValues {
    var prcies = widget.boughtProducts.map((e) => e.price).toList();
    prcies.sort();
    double maxValue = 0;
    double minValue = 0;

    if(prcies.first!.roundToDouble() > prcies.first!) {
      minValue = prcies.first!.roundToDouble() - 0.5;
    } else {
      minValue = prcies.first!.roundToDouble();
    }

    if(prcies.last!.roundToDouble() < prcies.last!) {
      maxValue = prcies.last!.roundToDouble() + 0.5;
    } else {
      maxValue = prcies.last!.roundToDouble();
    }

    return [minValue, maxValue];
  }

  Map<int, int> get daysInMonths {
    Map<int, int> result = {};
    var dateUtility = DateUtil();
    for(int i = 0; i < widget.boughtProducts.length; i++) {
      var month = widget.boughtProducts[i].boughtDate!.month;
      var year = widget.boughtProducts[i].boughtDate!.year;
      var days = dateUtility.daysInMonth(month, year);
      result[month] = days;
      if(i == widget.boughtProducts.length - 1) {
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
    
    for (var product in widget.boughtProducts) {
      if(product.boughtDate!.isAfter(widget.boughtProducts.first.boughtDate!)) {
        int initial = 0;
        int closing = 0;
        if(widget.boughtProducts.first.boughtDate!.month > product.boughtDate!.month) {
          monthIndex++;
          initial = 1;
          closing = product.boughtDate!.month;
        } else {
          initial = widget.boughtProducts.first.boughtDate!.month;
          closing = product.boughtDate!.month;
        }

        for(int i = initial; i < closing; i++) {
          monthIndex++;
          if(i == closing - 1) {
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
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: daysInMonths.length.toDouble() - 1,
        maxY: maxDimValues[1],
        minY: maxDimValues[0],
        gridData: FlGridData(show: false),
        showingTooltipIndicators: showingTooltipSpot != -1 ? [ShowingTooltipIndicators([
          LineBarSpot(lineChartBarData[0], showingTooltipSpot, lineChartBarData[0].spots[showingTooltipSpot])
        ])] : [],
        lineTouchData: lineTouchData,
        lineBarsData: lineChartBarData,
        titlesData: tilesData,
        borderData: botderData
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
    );
  }

  FlBorderData get botderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 4),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  FlTitlesData get tilesData => FlTitlesData(
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
    ),
  );

  LineTouchData get lineTouchData => LineTouchData(
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey,
      tooltipRoundedRadius: 10.0,
      fitInsideHorizontally: true,
      tooltipMargin: 10,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map(
          (LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              );
             return LineTooltipItem(
                "",
                textStyle,
                children: [
                  TextSpan(text: "${widget.boughtProducts[touchedSpot.spotIndex].price!.toStringAsFixed(2)} PLN\n"),
                  TextSpan(text: DateFormat("MMMMd", "pl").format(widget.boughtProducts[touchedSpot.spotIndex].boughtDate!))] 
              );
            },
          ).toList();
        },
      ),
      handleBuiltInTouches: false,
      touchCallback: (evnet, respons) {
        if(respons?.lineBarSpots != null && evnet is FlTapUpEvent) {
          setState(() {
            final spotIndex = respons?.lineBarSpots?[0].spotIndex ?? -1;
            if(spotIndex == showingTooltipSpot) {
              showingTooltipSpot = -1;
            } 
            else {
              showingTooltipSpot = spotIndex;
            }
          });
        }
      }

    );

  List<LineChartBarData> get lineChartBarData => [
    LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: const Color(0x444af699),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        checkToShowDot: (spot, barData) {
          if(showingTooltipSpot != -1) {
            if(barData.spots[showingTooltipSpot].x == spot.x && barData.spots[showingTooltipSpot].y == spot.y) {
              return true;
            }
          }     
          return false;
        },),
      spots: [
        ...drawChart()
      ],
    )
  ];

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
      interval: 0.5,
      reservedSize: 40,
    );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = "${value.toStringAsFixed(1)} PLN";

    return Text(text, style: style, textAlign: TextAlign.center);
  }
}