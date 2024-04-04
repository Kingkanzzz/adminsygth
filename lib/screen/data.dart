import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('save-data')
            .orderBy('Date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text('Date: ${data['Date']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Part No: ${data['Part No']}'),
                        Text('Supplier: ${data['Supplier']}'),
                        Text('Quantity(KG): ${data['Quantity(KG)']}'),
                        Text(
                            'Calculated quantity per pack(KG): ${data['Calculated quantity per pack(KG)']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditDataPage(
                                        date: data['Date'],
                                        partNo: data['Part No'],
                                        supplier: data['Supplier'],
                                        quantityKG:
                                            data['Quantity(KG)'].toInt(),
                                        calculatedQuantity: data[
                                                'Calculated quantity per pack(KG)']
                                            .toInt(),
                                        documentID:
                                            snapshot.data!.docs[index].id,
                                      )),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteData(snapshot.data!.docs[index].id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteData(String documentID) async {
    try {
      await FirebaseFirestore.instance
          .collection('save-data')
          .doc(documentID)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data deleted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data: $error')),
      );
    }
  }
}

class EditDataPage extends StatefulWidget {
  final String documentID;
  final String date;
  final String partNo;
  final String supplier;
  final int quantityKG;
  final int calculatedQuantity;

  const EditDataPage({
    Key? key,
    required this.documentID,
    required this.date,
    required this.partNo,
    required this.supplier,
    required this.quantityKG,
    required this.calculatedQuantity,
  }) : super(key: key);

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _quantityCalController = TextEditingController();
  String? _selectedSupplier;
  String? _selectedPartNo;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2024, 1, 1),
        firstDate: DateTime(2024, 1, 1),
        lastDate: DateTime(DateTime.now().year + 10));
    if (picked != null)
      setState(() {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      _dateController.text = dateFormat.format(picked);
      });
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.date;
    _selectedPartNo = widget.partNo;
    _quantityController.text = widget.quantityKG.toString();
    FirebaseFirestore.instance
      .collection('save-data')
      .doc(widget.documentID)
      .get()
      .then((snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      _quantityCalController.text =
          data['Calculated quantity per pack(KG)'].toString();
    });
  }).catchError((error) {
    print("Failed to fetch data: $error");
  });
    _selectedSupplier = widget.supplier;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    prefixIcon: IconButton(icon: Icon(Icons.calendar_month_outlined,size: 34,),
                    onPressed: () => _selectDate(context),)
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('component')
                  .orderBy('Part No')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final partNos = snapshot.data!.docs
                    .map((doc) => doc['Part No'] as String)
                    .toList();
                partNos.sort();
                return DropdownButtonFormField<String>(
                  value: _selectedPartNo,
                  // hint: Text('Part No'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPartNo = newValue;
                    });
                  },
                  items: partNos
                      .map((partNo) => DropdownMenuItem<String>(
                            child: Text(partNo),
                            value: partNo,
                          ))
                      .toList(),
                );
              },
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity(KG)'),
            ),
            TextField(
              controller: _quantityCalController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: 'Calculated quantity per pack(KG)'),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            ),
            DropdownButtonFormField<String>(
              value: _selectedSupplier,
              onChanged: (newValue) {
                setState(() {
                  _selectedSupplier = newValue;
                });
              },
              items: ['KC RUBBER', 'TMT', 'VINLY BASE']
                  .map((supplier) => DropdownMenuItem<String>(
                        child: Text(supplier),
                        value: supplier,
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Supplier'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _updateData();
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

  void _updateData() {
    // Update data in Firestore
    FirebaseFirestore.instance
        .collection('save-data')
        .doc(widget.documentID)
        .set({
      'Date': _dateController.text,
      'Part No': _selectedPartNo,
      'Supplier': _selectedSupplier,
      'Quantity(KG)': int.tryParse(_quantityController.text) ?? 0,
      'Calculated quantity per pack(KG)':
          double.tryParse(_quantityCalController.text) ?? 0.0,
    }, SetOptions(merge: true)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data updated successfully')),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Data()),
        );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data: $error')),
      );
    });
  }
}
