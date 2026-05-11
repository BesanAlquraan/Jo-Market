import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("isFavorite", isEqualTo: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites Yet ",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final favItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favItems.length,

            itemBuilder: (context, index) {

              final item = favItems[index];

              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 8),

                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),

                child: Row(
                  children: [

                    /// IMAGE
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(12),

                      child: Image.network(
                        item["image"],
                        width: 70,
                        height: 70,
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
                            overflow:
                            TextOverflow.ellipsis,

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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ACTIONS
                    Row(
                      children: [

                        /// ADD TO CART
                        GestureDetector(
                          onTap: () async {

                            await FirebaseFirestore.instance
                                .collection("cart")
                                .add({

                              "name": item["name"],
                              "price": item["price"],
                              "image": item["image"],
                              "description":
                              item["description"],
                              "quantity": 1,
                            });

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Added to Cart 🛒"),
                              ),
                            );
                          },

                          child: Container(
                            padding:
                            const EdgeInsets.all(6),

                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),

                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// REMOVE FROM FAVORITE
                        GestureDetector(
                          onTap: () async {

                            await FirebaseFirestore.instance
                                .collection("products")
                                .doc(item.id)
                                .update({
                              "isFavorite": false,
                            });
                          },

                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}