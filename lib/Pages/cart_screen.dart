import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'order_success_screen.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("cart")
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Cart is empty ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final items = snapshot.data!.docs;

          double total = 0;

          for (var item in items) {
            total += (double.parse(item["price"].toString()) *
                (item["quantity"] ?? 1));
          }

          return Column(
            children: [

              /// LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),

                  itemCount: items.length,

                  itemBuilder: (context, index) {

                    final item = items[index];
                    int qty = item["quantity"] ?? 1;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ],
                      ),

                      child: Row(
                        children: [

                          /// IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),

                            child: Image.network(
                              item["image"],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  item["name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "\$${item["price"]}",
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Quantity: $qty",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ACTIONS
                          Column(
                            children: [

                              Row(
                                children: [

                                  /// MINUS
                                  GestureDetector(
                                    onTap: () async {

                                      if (qty > 1) {
                                        await FirebaseFirestore
                                            .instance
                                            .collection("cart")
                                            .doc(item.id)
                                            .update({
                                          "quantity": qty - 1,
                                        });
                                      } else {
                                        await FirebaseFirestore
                                            .instance
                                            .collection("cart")
                                            .doc(item.id)
                                            .delete();
                                      }
                                    },

                                    child: Container(
                                      padding: const EdgeInsets.all(6),

                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      child: const Icon(
                                        Icons.remove,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    "$qty",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  /// PLUS
                                  GestureDetector(
                                    onTap: () async {

                                      await FirebaseFirestore
                                          .instance
                                          .collection("cart")
                                          .doc(item.id)
                                          .update({
                                        "quantity": qty + 1,
                                      });
                                    },

                                    child: Container(
                                      padding: const EdgeInsets.all(6),

                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      child: const Icon(
                                        Icons.add,
                                        size: 18,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              /// DELETE
                              GestureDetector(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection("cart")
                                      .doc(item.id)
                                      .delete();
                                },

                                child: Container(
                                  padding: const EdgeInsets.all(6),

                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// BOTTOM BAR
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                    )
                  ],
                ),

                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderSuccessScreen(),
                            ),
                          );
                        },

                        child: const Text(
                          "Checkout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}