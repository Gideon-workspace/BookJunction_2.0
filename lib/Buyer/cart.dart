import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:bookjunction2_0/Buyer/shop.dart';
import 'package:bookjunction2_0/model/books.dart';
import 'package:bookjunction2_0/model/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});
  @override
  State<Cart> createState() => _CartState();
}


class _CartState extends State<Cart> {
  String buyername ="";
  String sellername ="";
  String buyeremail ="";
  String selleremail ="";
  String buyercontact ="";
  String sellercontact ="";


  @override
  void initState() {
    super.initState();
    fetchBuyerData();
  }


  void removeFromCart(BuildContext context, Books book) {
    final store = context.read<Store>();
    store.removeItem(book);
  }

  void sendBoughtEmail(String sellerEmail, String bookName, String bookPrice, String buyerContact, String buyerName) async {
    String username = 'bookjunction1000@gmail.com';
    String password = 'piuz pvgd ewra wphf';
    final purchaseDate = DateTime.now();

    // Load the image as bytes
    final byteData = await rootBundle.load('assets/congratulation.png');
    final imageBytes = byteData.buffer.asUint8List();

    // Create a temporary file for the image
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/congratulation.png');
    await tempFile.writeAsBytes(imageBytes);

    // Define SMTP server
    final smtpServer = gmail(username, password);

    // Create the email message
    final message = Message()
      ..from = Address(username, 'BookJunction')
      ..recipients.add(sellerEmail)
      ..subject = 'TextBook Sold'
      ..html = """
    <!DOCTYPE html>
    <html>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="text-align: center; margin-bottom: 20px;">
        <img src="cid:congratsImage" 
             alt="Congratulations" 
             style="max-width: 100%; height: auto; text-decoration: none; border: none; outline: none;">
      </div>
      <h2 style="color: #2e86de; text-align: center;">Congratulations!</h2>
      <p>Dear Seller,</p>
      <p>We are thrilled to inform you that your textbook <strong>${bookName}</strong> has been sold!</p>
      <p>Details of the transaction:</p>
      <ul>
        <li><strong>Sold on:</strong> ${purchaseDate.toLocal().toString().split(' ')[0]}</li>
        <li><strong>Price:</strong> R${bookPrice}</li>
        <li><strong>Buyer Name:</strong> ${buyerName}</li>
        <li><strong>Buyer Contact:</strong> 0${buyerContact}</li>
      </ul>
      <p>Note we only charge you upon withdrawals</p>
      <p>Thank you for using <strong>BookJunction</strong>. We look forward to serving you again!</p>
      <p style="text-align: center; color: #999;">&copy; 2025 BookJunction. All rights reserved.</p>
    </body>
    </html>
    """
    // Attach the image with a Content-ID
      ..attachments.add(FileAttachment(tempFile)
        ..fileName = 'congratulation.png'
        ..contentType = 'image/png'
        ..cid = 'congratulationImage');

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } catch (e) {
      print('Message not sent. Error: $e');
    }
  }



  void sendPurchaseEmail(String buyerEmail, String bookName, String bookPrice, String sellerContact, String sellerName,String bookId) async {
    String username = 'bookjunction1000@gmail.com';
    String password = 'piuz pvgd ewra wphf';
    final purchaseDate = DateTime.now();

    // Load the image as bytes
    final byteData = await rootBundle.load('assets/congratulation.png');
    final imageBytes = byteData.buffer.asUint8List();

    // Create a temporary file for the image
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/congratulation.png');
    await tempFile.writeAsBytes(imageBytes);

    // Define SMTP server
    final smtpServer = gmail(username, password);

    // Create the email message
    final message = Message()
      ..from = Address(username, 'BookJunction')
      ..recipients.add(buyerEmail)
      ..subject = 'Purchase Confirmation: TextBook Acquired'
      ..html = """
    <!DOCTYPE html>
    <html>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="text-align: center; margin-bottom: 20px;">
        <img src="cid:congratulationImage" 
             alt="Congratulations" 
             style="max-width: 100%; height: auto; text-decoration: none; border: none; outline: none;">
      </div>
      <h2 style="color: #2e86de; text-align: center;">Congratulations on Your Purchase!</h2>
      <p>Dear Buyer,</p>
      <p>We are excited to inform you that you have successfully purchased the textbook <strong>${bookName}</strong>!</p>
      <p>Details of the transaction:</p>
      <ul>
        <li><strong>Purchased on:</strong> ${purchaseDate.toLocal().toString().split(' ')[0]}</li>
        <li><strong>Price:</strong> R${bookPrice}</li>
        <li><strong>Seller Name:</strong> ${sellerName}</li>
        <li><strong>Seller Contact:</strong> 0${sellerContact}</li>
      </ul>
      <p>Please use the following to confirm on the app that you have received your textbook from ${sellerName} :</p>
      <ul>
        <li><strong>Book name:</strong> ${bookName}</li>
        <li><strong>Price:</strong> R${bookPrice}</li>
        <li><strong>The code of the book:</strong> ${bookId}</li>
      </ul>
      <p>Thank you for using <strong>BookJunction</strong>. We hope you enjoy your new textbook!</p>
      <p style="text-align: center; color: #999;">&copy; 2025 BookJunction. All rights reserved.</p>
    </body>
    </html>
    """
      ..attachments.add(FileAttachment(tempFile)
        ..fileName = 'congratulation.png'
        ..contentType = 'image/png'
        ..cid = 'congratulationImage'); // Set the Content-ID (CID)

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Message not sent. Error: $e');
    }
  }







  Future<void> fetchBuyerData() async {


    try {
      final user = Supabase.instance.client.auth.currentUser;
      //final firebaseUid = firebaseUser?.id;

      if (user != null) {
        final response = await Supabase.instance.client.from('Buyers')
            .select('firstname,student_email,contact')
            .eq('User_ID', user.id)
            .single();

        if (response != null && response['firstname'] != null) {
          setState(() {
            buyername = response['firstname'];
            buyeremail = response['student_email'];
            buyercontact = response['contact'];

          });

        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void>addTransaction(BuildContext context, Books book)async{
    try{
      final buyer = Supabase.instance.client.auth.currentUser;
      //final firebaseUid = firebaseUser?.id;


      if(buyer !=null){
        final response = await Supabase.instance.client.from('Transaction').insert(
            {
              'buyer_id': buyer.id,
              'seller_id':book.id,
              'product_name': book.name,
              'price':book.price,
              'quantity':book.quantity,
              'status': "Not Completed",
            }).select().single();
        if(response!=null){
          print('Transaction added');
        }
      }
    }catch(e){
      print('Error adding Transaction: $e');
    }
  }



  Future<void>deleteProduct(BuildContext context, Books book, int count) async {
    try {
      // Get the current quantity of the book in the database
      final response = await Supabase.instance.client
          .from('Products')
          .select('quantity')
          .eq('seller_id', book.id)
          .single();

     int currentQuantity = response['quantity'];

      if (currentQuantity == count) {
        // If quantity is less than or equal to the count, delete the book
        await Supabase.instance.client.from('Products')
            .delete()
            .eq('seller_id', book.id);
        print('Deleted ${book.name} from the database.');
      } else {
        // Otherwise, decrement the quantity
        int newQuantity = currentQuantity - count;
        await Supabase.instance.client.from('Products')
            .update({'quantity': newQuantity})
            .eq('seller_id', book.id);
        print('Updated quantity of ${book.name} to $newQuantity.');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }







  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    //use real  account

    Future<double> fetchExchangeRate() async {
      const apiUrl = "https://api.exchangerate-api.com/v4/latest/ZAR"; // Example API
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["rates"]["USD"];
      } else {
        throw Exception("Failed to fetch exchange rate");
      }
    }


    return Consumer<Store>(
      builder: (context, Store value, Widget? child) {

        double totalPrice = value.cart.fold(
          0.0,
              (sum, book) => sum + (double.tryParse(book.price) ?? 0.0),
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(LineAwesomeIcons.angle_left),
            ),
            title:  Padding(
              padding: EdgeInsets.only(right: 60),
              child: Center(
                child: Text(
                  'CART',
                  style: GoogleFonts.abel(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: screenSize.width * 0.03,
                  right: screenSize.width * 0.03,
                  top: 5),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.cart.length,
                      itemBuilder: (context, index) {
                        final Books book = value.cart[index];
                        final String name = book.name;
                        final String price = book.price;

                        return Container(
                          height: 100,
                          decoration: BoxDecoration(color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(left: screenSize.width * 0.03,
                              right: screenSize.width * 0.03,
                              top: 10),
                          child: ListTile(

                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('R$price', style: const TextStyle(),),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => removeFromCart(context, book),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  //sum the total price in he cart
                  Container(
                    width: screenSize.width * 0.95,
                    height: 100,
                    decoration: BoxDecoration(color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(45)),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 35),
                          child: Text('Total Amount:', style: GoogleFonts.abel(
                              fontSize: 18, fontWeight: FontWeight.bold),),
                        ),

                        //Here I am supposed to access the price in each cart and add the total
                        Padding(
                          padding: EdgeInsets.only(left: 90),
                          child: Text(
                              'R${totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.abel(
                              fontSize: 18, fontWeight: FontWeight.bold),),
                        ),

                      ],),
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 20, top: 30),
                    child: ElevatedButton(onPressed: () async {

                        final store = context.read<Store>();
                        final exchangeRate = await fetchExchangeRate();

                        // Map cart items to PayPal item list format
                        final List<Map<String, dynamic>> items = store.cart.map((book) {
                          final priceInUSD =
                              (double.tryParse(book.price) ?? 0.0) * exchangeRate;
                          return {
                            "name": book.name,
                            "quantity": book.quantity, // Adjust if quantity can be more than 1
                            "price": priceInUSD.toStringAsFixed(2),
                            "currency": "USD"
                          };
                        }).toList();

                        // Calculate total price
                        double totalPrice = store.cart.fold(
                          0.0,
                              (sum, book) => sum + (double.tryParse(book.price) ?? 0.0)* exchangeRate,
                        );

                        // Build the transaction object
                        final Map<String, dynamic> transaction = {
                          "amount": {
                            "total": totalPrice.toStringAsFixed(2),
                            "currency": "USD",
                            "details": {
                              "subtotal": totalPrice.toStringAsFixed(2),
                              "shipping": '0',
                              "shipping_discount": 0
                            }
                          },
                          "description": "Your order description.",
                          "item_list": {
                            "items": items,
                          }
                        };

                        //I need to use correct keys(use real account) when I push it to production

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PaypalCheckoutView(
                            sandboxMode: false,
                            clientId: "AdQaRUmbvLszbJRO8eS6VdiEgU38-2LnNGEwpjVIziQS7iEZDifQYDxCGMrP0G8ddpsBVeAoxwgH39nk",
                            secretKey: "EKksAvlsjmiGvpHdrT2WVHSPPcedG6Jg6XQVViyI2LxfLKeGcQLg__Kfvcp7VyBW7Va__6TGvHlm19XP",
                            transactions: [transaction],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              //after the payment is done remove from database and for such seller it will be removed
                              final store = context.read<Store>();
                              Map<String, int> bookCountMap = {};

                              for (var book in store.cart) {
                                print(book.id);

                                if (bookCountMap.containsKey(book.id)) {
                                  bookCountMap[book.id] = bookCountMap[book.id]! + 1;
                                } else {
                                  bookCountMap[book.id] = 1;
                                }
                              }
                              for (var book in store.cart) {
                                final count = bookCountMap[book.id] ?? 0;
                                final response = await Supabase.instance.client.from('Sellers')
                                    .select('firstname,student_email,contact')
                                    .eq('User_ID', book.id)
                                    .single();

                                if (response != null && response['contact'] != null) {
                                  setState(() {
                                    sellername=response['firstname'];
                                    selleremail =response['student_email'];
                                    sellercontact = response['contact'];
                                  });

                                }
                                if (count > 0) {
                                  await deleteProduct(context, book, count);
                                   await addTransaction(context, book);
                                   sendPurchaseEmail(buyeremail,book.name,book.price,sellercontact,sellername,book.id);
                                   sendBoughtEmail(selleremail,book.name,book.price,buyercontact,buyername);
                                }
                              }

                              await Future.delayed(const Duration(milliseconds: 500));

                              // Navigate to the Shop page
                              Navigator.of(context).push(CustomPageRoute(child: const Shop()));

                              // Show a SnackBar for quick user feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Payment Successful! Your order is being processed.",
                                    style: GoogleFonts.abel(fontSize: 14),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                              // Clear the cart after successful payment
                              store.clear();
                            },


                            onError: (error) {
                              print("onError: $error");
                              Navigator.pop(context);
                            },
                            onCancel: () {
                              print('cancelled:');
                            },
                          ),
                        ));


                    },

                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,

                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(5),
                          ),

                        ),
                        child:  Text('CHECKOUT',style: GoogleFonts.abel(fontSize: 16),)
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }

}
