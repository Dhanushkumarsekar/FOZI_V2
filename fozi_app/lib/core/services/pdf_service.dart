import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateInvoice(Map order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24)),

            pw.SizedBox(height: 10),

            pw.Text("Customer: ${order['customerDetails']['name']}"),
            pw.Text("Phone: ${order['customerDetails']['phone']}"),
            pw.Text("Address: ${order['customerDetails']['address']}"),

            pw.SizedBox(height: 10),

            pw.Text("Products:"),

            ...order['products'].map<pw.Widget>((p) {
              return pw.Text(
                "${p['name']} x${p['quantity']} - ₹${p['price']}",
              );
            }).toList(),

            pw.SizedBox(height: 10),

            pw.Text("Total: ₹${order['totalAmount']}"),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}