import 'package:flutter/material.dart';
import '/screens/stats/chart.dart';

class StatScreen extends StatelessWidget{
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(12,20,12,12),
                child: MyChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}