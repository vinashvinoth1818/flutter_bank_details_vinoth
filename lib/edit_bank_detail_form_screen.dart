import 'package:flutter/material.dart';
import 'package:flutter_bank_details_vinoth/bank_detail_list_screen.dart';
import 'package:flutter_bank_details_vinoth/bank_detail_model.dart';
import 'package:flutter_bank_details_vinoth/main.dart';
import 'dbhelper_bankdetails.dart';

class EditBankDetailsFormScreen extends StatefulWidget {
  const EditBankDetailsFormScreen({super.key});

  @override
  State<EditBankDetailsFormScreen> createState() =>
      _BankDetailsFormScreenState();
}

class _BankDetailsFormScreenState extends State<EditBankDetailsFormScreen> {
  var _bankNameController = TextEditingController();
  var _branchNameController = TextEditingController();
  var _accountTypeController = TextEditingController();
  var _accountNoController = TextEditingController();
  var _IFSCCodeController = TextEditingController();

  //Edit mode
  bool firstTimeFlag = false;
  int _selectedId = 0;

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('--------------> Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('---------->once execute');

      firstTimeFlag = true;

      final bankDetails =
          ModalRoute.of(context)!.settings.arguments as BankDetailsModel;

      print('----------->Received Data');

      print(bankDetails.id);
      print(bankDetails.bankName);
      print(bankDetails.branchName);
      print(bankDetails.accountType);
      print(bankDetails.accountNo);
      print(bankDetails.IFSCCode);

      _selectedId = bankDetails.id!;

      _bankNameController.text = bankDetails.bankName;
      _branchNameController.text = bankDetails.branchName;
      _accountTypeController.text = bankDetails.accountType;
      _accountNoController.text = bankDetails.accountNo;
      _IFSCCodeController.text = bankDetails.IFSCCode;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Details Form Screen'),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text("Delete")),
            ],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                print('Delete option clicked');
                _deleteFormDialog(context);
              }
            },
          ),
        ],
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
                    print('------------>update Button Clicked');
                    _update();
                  },
                  child: Text('Update'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _update() async {
    print('------------>_update');
    print('-------------> Bank Name:${_bankNameController.text}');
    print('-------------> Branch Name:${_branchNameController.text}');
    print('-------------> Account Type:${_accountTypeController.text}');
    print('-------------> Account No:${_accountNoController.text}');
    print('-------------> IFSC COde:${_IFSCCodeController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.columnId: _selectedId,
      DatabaseHelper.columnBankName: _bankNameController.text,
      DatabaseHelper.columnBranchName: _branchNameController.text,
      DatabaseHelper.columnAccountType: _accountTypeController.text,
      DatabaseHelper.columnAccountNo: _accountNoController.text,
      DatabaseHelper.columnIFSCCode: _IFSCCodeController.text,
    };

    final result =
        await dbHelper.updateBankDetails(row, DatabaseHelper.bankDetailsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'updated');
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

  void _delete() async {
    print('--------------> _delete');

    final result = await dbHelper.deleteBankDetails(
        _selectedId, DatabaseHelper.bankDetailsTable);

    debugPrint('-----------------> Deleted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Deleted.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankDetailListScreen()));
    });
  }
}
