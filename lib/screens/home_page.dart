import 'package:flutter/material.dart';
import 'package:pemograman_mobile_2255011004/main.dart';
import 'package:pemograman_mobile_2255011004/models/customer_service_model.dart';
import 'package:pemograman_mobile_2255011004/models/department_model.dart';
import 'package:pemograman_mobile_2255011004/models/priority_issue_model.dart';
import 'package:pemograman_mobile_2255011004/screens/detail_page.dart';
import 'package:pemograman_mobile_2255011004/screens/form.dart';
import 'package:pemograman_mobile_2255011004/services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // sesuaikan bagian modelnya untuk mengambil nilai
  late Future<List<CustomerService>> futureDataCustomer;


  @override
  void initState() {
    super.initState();
    futureDataCustomer = APiService().fetchDataCustomer();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTS Page'),
      ),
      body: Center(
        // sesuaikan modelnya dengan API
        child: FutureBuilder<List<CustomerService>>(
          future: futureDataCustomer,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for the future
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Display an error message if there's an error
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Display the list of customer data if data is available
              final List<CustomerService> dataList = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    futureDataCustomer;
                  });
                },
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => DetailPage(
                                data: dataList[index],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // CircleAvatar(
                                //   backgroundImage:
                                //       NetworkImage("${dataList[index].foto}"),
                                //   radius: 20,
                                // ),
                                const SizedBox(width: 16),
                                Text(
                                  '${dataList[index].titleIssue}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${dataList[index].rating}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Add code for edit action here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // builder: (context) => InputFormPetani(
                                        //   petani: petaniList[index],
                                        // ),
                                        builder: (context) => FormData(
                                          customer: dataList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirmed = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text(
                                              'Are you sure you want to delete this petani?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () async {
                                                try {
                                                  final id = dataList[index]
                                                      .idCustomerService;
                                                  if (id != null) {
                                                    await APiService()
                                                        .deleteDataCustomer(id);
                                                    setState(() {});
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Failed to delete petani: $e'),
                                                    ),
                                                  );
                                                }
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyApp(),
                                                    // builder: (context) => HomePage(futurePetani: futurePetani),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmed) {
                                      // Add code for delete action here
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              // Default case: Display a message when there's no data
              return const Text('No data available');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => const TambahEditPetaniPage(),
              builder: (context) => const FormData(

                  // petani: Petani(),
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
