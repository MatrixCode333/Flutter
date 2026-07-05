import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_bloc.dart';
import '../../bloc/home_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        elevation: 0,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final categories = [
                'Electronics',
                'Fashion',
                'Home',
                'Sports',
                'Beauty',
                'Books',
              ];
              return Card(
                child: Center(
                  child: Text(
                    categories[index],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

