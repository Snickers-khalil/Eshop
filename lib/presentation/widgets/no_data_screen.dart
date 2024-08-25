import 'package:flutter/material.dart';

class NoDataFoundScreen extends StatelessWidget {
  final bool? fromHome;
  const  NoDataFoundScreen({super.key, this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    return fromHome! ?  noDataWidget(context) : SizedBox(height: MediaQuery.of(context).size.height * 0.6, child: noDataWidget(context));
  }

  Padding noDataWidget(BuildContext context) {
    return Padding(
    padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/no_data.png', width: 150, height: 150),

          const SizedBox(height: 5),
          Text(
             'no data found', textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

        ],
      ),
    ),
  );
  }
}
