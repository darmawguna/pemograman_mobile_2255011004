import 'package:flutter/material.dart';
import 'package:pemograman_mobile_2255011004/models/customer_service_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.data});
  final CustomerService data;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.data.titleIssue}"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ignore: sized_box_for_whitespace
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  "${widget.data.image}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        Text('Gambar tidak dapat diakses'),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ID Penjual: ${widget.data.idCustomerService}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('ID description Target: ${widget.data.idDivisionTarget}'),
              const SizedBox(height: 16),
              Text('ID priority : ${widget.data.idPriority}'),
              const SizedBox(height: 16),
              Text(
                'Title Issue: ${widget.data.titleIssue}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Description Issue: ${widget.data.descriptionIssues}'),
              const SizedBox(height: 8),
              Text('Rating: ${widget.data.rating}'),
              const SizedBox(height: 8),
              // Text('No. Telp: ${widget.data.telp}'),
              const SizedBox(height: 16),
              // Text(
              //   'Foto: ${widget.data.foto}',
              //   style:
              //       const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              const SizedBox(height: 8),
              Text('Division Name: ${widget.data.divisionDepartmentName}'),
              const SizedBox(height: 16),
              Text(
                'Priority Name: ${widget.data.priorityName}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }
}
