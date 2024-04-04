import 'package:adminsygth/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _partNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _partWeightController = TextEditingController();
  final CollectionReference _componentsCollection =
      FirebaseFirestore.instance.collection('component');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Component', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _partNoController,
              decoration: InputDecoration(labelText: 'Part NO'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _partWeightController,
              decoration: InputDecoration(labelText: 'Part Wgt(g)'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _addComponent();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                  child: Text('Add',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }

  void _addComponent() async {
    String partNo = _partNoController.text.trim();
    String description = _descriptionController.text.trim();
    String partWeight = _partWeightController.text.trim();

    if (partNo.isNotEmpty && description.isNotEmpty && partWeight.isNotEmpty) {
      try {
        await _componentsCollection.add({
          'Part No': partNo,
          'Description': description,
          'Part Wgt(g)': partWeight,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Component added successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add component: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }
}
