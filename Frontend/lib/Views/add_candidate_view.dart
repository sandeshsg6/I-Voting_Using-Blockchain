import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ivote/App/admin_data.dart';
import 'package:ivote/App/constants.dart';
import 'package:ivote/App/location.dart';
import 'package:ivote/App/routes.dart';
import 'package:http/http.dart' as http;

class AddCandidateView extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  _AddCandidateViewState createState() => _AddCandidateViewState();
}

class _AddCandidateViewState extends State<AddCandidateView> {
  String _candidateName, _state, _district;
  int _ward, _candidateId;

  List<String> _states = ["Choose a state"];
  List<String> _districts = ["Choose a district"];
  List<String> _wards = [
    "Choose a ward",
    "Ward 1",
    "Ward 2",
    "Ward 3",
    "Ward 4",
    "Ward 5",
    "Ward 6"
  ];
  String _selectedState = "Choose a state";
  String _selectedDistrict = "Choose a district";
  String _selectedWard = "Choose a ward";

  @override
  void initState() {
    _states = List.from(_states)..addAll(Location.getAllStates());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        shadowColor: Colors.blueAccent,
        title: Text("Add Candidate"),
        leading: Offstage(),
        actions: <Widget>[
          TextButton.icon(
            label: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            // tooltip: 'Logout',
            onPressed: () {
              // await Navigator.pushNamed(context, Routes.voterLoginView);
              Navigator.popUntil(
                  context, ModalRoute.withName(Routes.voterLoginView));
            },
          ),
          // Text('\n Logout   '),
          const Padding(padding: const EdgeInsets.only(right: 30.0))
        ],
      ),
      key: Key(Routes.addCandidateView),
      body: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30.0),
              child: Text(
                'Add Candidate',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 250.0,
                  width: 250.0,
                  color: Colors.grey[400],
                  child: Icon(Icons.person_outline_outlined),
                ),
                Container(
                  width: 500.0,
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 480,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) {
                            if (name == null || name.isEmpty)
                              return 'Please enter Candidate Name';

                            return null;
                          },
                          onSaved: (name) {
                            if (name != null || name.isNotEmpty)
                              _candidateName = name;
                          },
                          decoration: InputDecoration(
                            labelText: 'Candidate\'s Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.9),
                            ),
                            // contentPadding: EdgeInsets.all(4.0),
                          ),
                          scrollPadding: EdgeInsets.all(4.0),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 480,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (candidateId) {
                            if (candidateId == null || candidateId.isEmpty)
                              return 'Please enter Candidate Id';
                            if (int.tryParse(candidateId) == null)
                              return "Please Enter numeric data";

                            return null;
                          },
                          onSaved: (candidateId) {
                            if (candidateId != null || candidateId.isNotEmpty)
                              _candidateId = int.parse(candidateId);
                          },
                          decoration: InputDecoration(
                              labelText: 'Candidate\'s Id',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.9))),
                        ),
                      ),
                      Container(
                        height: 70.0,
                        width: 500.0,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelStyle: Theme.of(context)
                                  .primaryTextTheme
                                  .caption
                                  .copyWith(color: Colors.black),
                              border: const OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (state) {
                              if (state == "Choose a state")
                                return 'Please Select state';

                              return null;
                            },
                            onSaved: (state) {
                              if (state != null ||
                                  state.isNotEmpty && state != "Choose a state")
                                _state = state;
                            },
                            items: _states.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedState(value),
                            value: _selectedState,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        height: 70.0,
                        width: 500.0,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelStyle: Theme.of(context)
                                  .primaryTextTheme
                                  .caption
                                  .copyWith(color: Colors.black),
                              border: const OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (district) {
                              if (district == "Choose a district")
                                return 'Please Select district';

                              return null;
                            },
                            onSaved: (district) {
                              if (district != null ||
                                  district.isNotEmpty &&
                                      district != "Choose a district")
                                _district = district;
                            },
                            items: _districts.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedDistrict(value),
                            value: _selectedDistrict,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        height: 70.0,
                        width: 500.0,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelStyle: Theme.of(context)
                                  .primaryTextTheme
                                  .caption
                                  .copyWith(color: Colors.black),
                              border: const OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (ward) {
                              if (ward == "Choose a ward")
                                return 'Please Select ward';

                              return null;
                            },
                            onSaved: (ward) {
                              print('SAved Ward');
                              print(ward);

                              if ((ward != null || ward.isNotEmpty) &&
                                  ward != "Choose a ward") {
                                switch (ward) {
                                  case "Ward 1":
                                    _ward = 1;
                                    break;
                                  case "Ward 2":
                                    _ward = 2;
                                    break;
                                  case "Ward 3":
                                    _ward = 3;
                                    break;
                                  case "Ward 4":
                                    _ward = 4;
                                    break;
                                  case "Ward 5":
                                    _ward = 5;
                                    break;
                                  case "Ward 6":
                                    _ward = 6;
                                    break;
                                }
                              }
                            },
                            items: _wards.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedWard(value),
                            value: _selectedWard,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 50.0,
              width: 350.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
              child: ElevatedButton.icon(
                style: ButtonStyle(),
                onPressed: () async {
                  if (widget.formKey.currentState.validate()) {
                    widget.formKey.currentState.save();

                    print('Name: $_candidateName');
                    print('Id : $_candidateId');

                    print('State : $_state');
                    print('District: $_district');
                    print('Ward : $_ward');

                    await requestServer();
                  } else
                    print('Validation Failed');
                },
                icon: Icon(Icons.add),
                label: Text('Add Candidate', style: TextStyle(fontSize: 23.0)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 40,
              color: Colors.grey[50],
              padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
              child: Text(
                "Made with ❤️ in India",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
              ))),
    );
  }

  void _onSelectedState(String value) {
    setState(() {
      _selectedDistrict = "Choose a district";
      _districts = ["Choose a district"];
      _selectedState = value;
      _districts = List.from(_districts)
        ..addAll(Location.getLocalByState(value));
    });
  }

  void _onSelectedDistrict(String value) {
    setState(() => _selectedDistrict = value);
  }

  void _onSelectedWard(String value) {
    setState(() => _selectedWard = value);
  }

  Future<void> requestServer() async {
    try {
      String jsonBody = json.encode({
        'candidateName': _candidateName,
        'candidateId': _candidateId,
        'state': _state,
        'district': _district,
        'ward': _ward
      });

      http.Response response = await http.post(
        Uri.parse(baseAPIUrl + apiAddCandidate),
        // Uri(
        //   host: hostUrl,
        //   port: hostUrlPort,
        //   path: apiAddCandidate,
        //   // scheme: 'http',
        // ),
        headers: postHeadersWithJWT(kAdminJWTToken),
        body: jsonBody,
      );

      print('RESPONSE: ');
      print(response.body);

      Map<String, dynamic> decodedJsonData = jsonDecode(response.body);

      if (decodedJsonData['result']) {
        print('Candidate added Successfully');

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Candidate Added Successfully'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          ),
        );

        widget.formKey.currentState.reset();
      } else {
        print('Failed to add candidate');

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Failed'),
                  content: Text('Adding Candidate Failed\n' +
                          decodedJsonData['message'] ??
                      ''),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'))
                  ],
                ));
      }
    } on SocketException {
      print('failed to add candidate, network error');

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Network Error'),
                content: Text(
                    "Connection Error, Please check your internet connection"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('RETRY'))
                ],
              ));
    } catch (error) {
      print('failed to add candidate');

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error Occured'),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('RETRY'))
                ],
              ));
    }
  }
}
