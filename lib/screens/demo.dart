// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:kabadi/screens/upcoming_matches.dart';

class PointsTablePage extends StatefulWidget {
  // ignore: use_super_parameters
  const PointsTablePage({Key? key}) : super(key: key);

  @override
  State<PointsTablePage> createState() => _PointsTablePageState();
}

class _PointsTablePageState extends State<PointsTablePage> {
  IconData _selectedFilterIcon = Icons.filter_list; // Initially set filter icon
  String _selectedFilter = 'All'; // Initially set the filter to 'All'



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFf7f2f0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFf7f2f0),
          title: const Row(
            children: [
              Text(
                'Kabadi ',
                style: TextStyle(
                  color: Color(0xFFfc5607),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                '     Matches ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text('Filter: '),
                        ),
                        const SizedBox(
                          width: 120,
                        ),
                        DropdownButton<String>(
                          value: _selectedFilter,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue!;
                              // Update the icon based on the selected filter
                              _selectedFilterIcon = newValue == 'All'
                                  ? Icons.filter_list
                                  : Icons.filter_alt;
                            });
                          },
                          items: <String>[
                            'All',
                            'Filter 1',
                            'Filter 2',
                            'Filter 3'
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    // ignore: unnecessary_null_comparison
                                    _selectedFilterIcon != null
                                        ? Icon(_selectedFilterIcon)
                                        : Text(value),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.refresh),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const TabBar(
                  
                  labelColor: Colors.black, // Change label text color
                  indicator: BoxDecoration(
                    color: const Color(0xFFfc5607), // Fill entire area around the selected tab with orange
                    // Optional: Add border radius to the indicator
                  ),
                  // Change indicator color
                  tabs: [
                    Tab(
                      text: 'Live',
                    ),
                    Tab(
                      text: 'Upcoming',
                    ),
                    Tab(
                      text: 'Points',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 1,
                  child: TabBarView(
                    children: [
                      const Center(child: Text('Live content')),
                      Upcoming(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                        
                          columns: const [
                            DataColumn(
                              
                                label: Text(
                              'Rank',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                  
                                label: Text(' Team',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Played',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('W',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('L',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('T',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('P',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: [
                            
                            DataRow(cells: [
                              const DataCell(Text('1')),
                              DataCell(
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/tamilThalaivas.png',
                                      width: 30,
                                      height: 55,
                                    ),
                                    const Text('Tamil Thalaivas'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('10')),
                              const DataCell(Text('8')),
                              const DataCell(Text('2')),
                              const DataCell(Text('0')),
                              const DataCell(Text('16')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('2')),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      'images/punneriPaltan.png',
                                      width: 30,
                                      height: 55,
                                    ),
                                    const Text('Punneri Paltan'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('10')),
                              const DataCell(Text('7')),
                              const DataCell(Text('3')),
                              const DataCell(Text('0')),
                              const DataCell(Text('14')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('3')),
                              DataCell(
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/bengal.png',
                                      width: 30,
                                      height: 55,
                                    ),
                                    const Text('Tamil Thalaivas'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('10')),
                              const DataCell(Text('6')),
                              const DataCell(Text('4')),
                              const DataCell(Text('0')),
                              const DataCell(Text('12')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('4')),
                              DataCell(
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/tamilThalaivas.png',
                                      width: 30,
                                      height: 55,
                                    ),
                                    const Text('Tamil Thalaivas'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('10')),
                              const DataCell(Text('5')),
                              const DataCell(Text('5')),
                              const DataCell(Text('0')),
                              const DataCell(Text('10')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('5')),
                              DataCell(
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/tamilThalaivas.png',
                                      width: 30,
                                      height: 55,
                                    ),
                                    const Text('Tamil Thalaivas'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('10')),
                              const DataCell(Text('5')),
                              const DataCell(Text('5')),
                              const DataCell(Text('0')),
                              const DataCell(Text('10')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('6')),
                              DataCell(
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/tamilThalaivas.png',
                                      width: 30,
                                      height: 55,
                                    ),
                                    const Text('Tamil Thalaivas'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('10')),
                              const DataCell(Text('5')),
                              const DataCell(Text('5')),
                              const DataCell(Text('0')),
                              const DataCell(Text('10')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('7')),
                              DataCell(
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/tamilThalaivas.png',
                                      width: 30,
                                      height: 55,
                                    ),
                                    const Text('Tamil Thalaivas'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('10')),
                              const DataCell(Text('5')),
                              const DataCell(Text('5')),
                              const DataCell(Text('0')),
                              const DataCell(Text('10')),
                            ]),
                          ],
                        ),
                      )
                      // Place the table here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PointsTablePage(),
  ));
}
