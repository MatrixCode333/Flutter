import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projrct/presentation/home/view%20/widget/doctor_list_widget.dart';
import 'package:projrct/utils/common_widget/common_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final doctors = [
    {
      'name': 'Dr. Alfredo Maia',
      'specialty': 'Cardiologist',
      'rating': 4.2,
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Dr. Mark Hius',
      'specialty': 'Psychiatrist',
      'rating': 4.8,
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Dr. Mark Hius',
      'specialty': 'Psychiatrist',
      'rating': 4.8,
      'image': 'https://via.placeholder.com/150'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(90),
        child: CommonAppBar(title: 'Profile'),
      ),
      body: Column(
        children: [
        SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return Container(
              width: 260,
              margin: const EdgeInsets.only(right: 16),
              child: DoctorCard(
                onTap: (){},
                name: doctor['name'].toString()!,
                specialty: doctor['specialty'].toString()!,
                rating: doctor['rating'] as double,
                imageUrl: doctor['image'].toString()!,
              ),
            );
          },
        ),
      )
        ],
      ),
    );
  }
}
