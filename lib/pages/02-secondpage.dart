import 'package:flutter/material.dart';
import 'package:nirut_final_app/component/bottombar.dart';

class Secondpage extends StatelessWidget {
  const Secondpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Second page'),
        // '($maincontext.$pdescription)',  ),

        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.forward),
            onPressed: () {
              Navigator.pushNamed(context, '/second');
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
