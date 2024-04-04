import 'package:adminsygth/screen/addpage.dart';
import 'package:adminsygth/screen/data.dart';
import 'package:adminsygth/screen/savedata.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Component List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search, color: Colors.white),
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => SearchPage()));
          //     // showSearch(context: context, delegate: CustomSearchDelegate());
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.description_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SaveData()));
            },
          ),
          IconButton(
            icon: Icon(Icons.folder_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Data()));
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => AddPage())));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('component')
            .orderBy('Part No')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Column(
                children: [
                  ListTile(
                    title: Text(data['Part No'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${data['Description']}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                        Text('Part Wgt(g): ${data['Part Wgt(g)']}',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => Detail(data))));
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editComponent(document.id, context);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteComponent(document.id, context);
                          },
                          // style: IconButton.styleFrom(
                          //   backgroundColor: Colors.red
                          // ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _deleteComponent(String documentID, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('component')
          .doc(documentID)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Component deleted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete component: $error')));
    }
  }

  void _editComponent(String documentID, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditComponentPage(documentID: documentID),
      ),
    );
  }
}

class EditComponentPage extends StatefulWidget {
  final String documentID;

  const EditComponentPage({Key? key, required this.documentID})
      : super(key: key);

  @override
  _EditComponentPageState createState() => _EditComponentPageState();
}

class _EditComponentPageState extends State<EditComponentPage> {
  TextEditingController _partNoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _partWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch current component data from Firestore and set it to controllers
    FirebaseFirestore.instance
        .collection('component')
        .doc(widget.documentID)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          _partNoController.text = doc['Part No'];
          _descriptionController.text = doc['Description'];
          _partWeightController.text = doc['Part Wgt(g)'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Component', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _partNoController,
              decoration: InputDecoration(labelText: 'Part No'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _partWeightController,
              decoration: InputDecoration(labelText: 'Part Weight (g)'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _updateComponent(widget.documentID);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: Text('Update',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateComponent(String documentID) async {
    try {
      await FirebaseFirestore.instance
          .collection('component')
          .doc(documentID)
          .update({
        'Part No': _partNoController.text,
        'Description': _descriptionController.text,
        'Part Wgt(g)': _partWeightController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Component updated successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update component: $error')),
      );
    }
  }
}

class Detail extends StatefulWidget {
  final Map<String, dynamic> data;

  Detail(this.data);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  double inputValue = 0.0;
  double result = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 10),
            Text(widget.data['Part No'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            // SizedBox(height: 10),
            Text(
              'Description: ${widget.data['Description']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Part Wgt(g): ${widget.data['Part Wgt(g)']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    inputValue = 0;
                  } else {
                    inputValue = double.parse(value);
                  }
                });
              },
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (inputValue != null && inputValue != 0) {
                      double partWgt = double.parse(widget.data['Part Wgt(g)']);
                      result = inputValue * (partWgt / 1000);
                    } else {
                      result = 0.0;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: Text('Calculate',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            // Text('Result: $result KG', style: TextStyle(fontSize: 18)),
            Text('Result: ${result.toStringAsFixed(2)} KG',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Center(
//       child: Text('Search results for: $query'),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Center(
//       child: Text('Search suggestions for: $query'),
//     );
//   }
// }