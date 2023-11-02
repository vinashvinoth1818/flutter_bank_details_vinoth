import 'package:flutter/material.dart';
import 'package:flutter_bank_details_vinoth/bank_detail_list_screen.dart';
import 'package:flutter_bank_details_vinoth/main.dart';
import 'dbhelper_bankdetails.dart';

class BankDetailsFormScreen extends StatefulWidget {
  const BankDetailsFormScreen({super.key});

  @override
  State<BankDetailsFormScreen> createState() => _BankDetailsFormScreenState();
}

class _BankDetailsFormScreenState extends State<BankDetailsFormScreen> {
  var _bankNameController = TextEditingController();
  var _branchNameController = TextEditingController();
  var _accountTypeController = TextEditingController();
  var _accountNoController = TextEditingController();
  var _IFSCCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Details Form Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Bank Name',
                      hintText: 'Enter Bank Name'),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _branchNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Branch Name',
                      hintText: 'Enter Branch Name'),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _accountTypeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Account Type',
                      hintText: 'Enter Account Type'),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _accountNoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Account No',
                      hintText: 'Enter Account No'),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _IFSCCodeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'IFSCCode',
                      hintText: 'Enter IFSCCode'),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () {
                    print('------------>Save Button Clicked');
                    _save();
                  },
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    print('------------>_Save');
    print('-------------> Bank Name:${_bankNameController.text}');
    print('-------------> Branch Name:${_branchNameController.text}');
    print('-------------> Account Type:${_accountTypeController.text}');
    print('-------------> Account No:${_accountNoController.text}');
    print('-------------> IFSC COde:${_IFSCCodeController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.columnBankName: _bankNameController.text,
      DatabaseHelper.columnBranchName: _branchNameController.text,
      DatabaseHelper.columnAccountType: _accountTypeController.text,
      DatabaseHelper.columnAccountNo: _accountNoController.text,
      DatabaseHelper.columnIFSCCode: _IFSCCodeController.text,
    };

    final result =
        await dbHelper.insertBankDetails(row, DatabaseHelper.bankDetailsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }

    setState(() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BankDetailListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
