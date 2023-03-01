import 'package:flutter/material.dart';

class NoDataModal extends StatelessWidget {
  const NoDataModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(20),
        child: const Text('Sin datos')
      )
    );
  }
}