import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),

      appBar: AppBar(
        backgroundColor: const Color(0xffF4F6F8),
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: Text(
          category,
          style: const TextStyle(
            color: Color.fromRGBO(47, 80, 76, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "$category Collection",

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),


              ],
            ),
          ),

          /// PRODUCTS
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where(
                "category",
                isEqualTo: category,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {

                  return Center(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "No Products Found",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Try another category",

                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(15),

                  itemCount: products.length,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.67,
                  ),

                  itemBuilder: (context, index) {

                    final product = products[index];

                    bool isFavorite =
                        product["isFavorite"] ?? false;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(24),

                        boxShadow: [

                          BoxShadow(
                            color:
                            Colors.black.withOpacity(0.05),

                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          /// IMAGE
                          Expanded(
                            child: Stack(
                              children: [

                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.only(
                                    topLeft:
                                    Radius.circular(24),

                                    topRight:
                                    Radius.circular(24),
                                  ),

                                  child: Image.network(
                                    product["image"],

                                    width: double.infinity,

                                    fit: BoxFit.cover,
                                  ),
                                ),

                                /// FAVORITE
                                Positioned(
                                  top: 10,
                                  right: 10,

                                  child: GestureDetector(
                                    onTap: () async {

                                      await FirebaseFirestore
                                          .instance
                                          .collection(
                                          "products")
                                          .doc(product.id)
                                          .update({

                                        "isFavorite":
                                        !isFavorite,
                                      });
                                    },

                                    child: Container(
                                      padding:
                                      const EdgeInsets.all(8),

                                      decoration: BoxDecoration(
                                        color: Colors.white,

                                        borderRadius:
                                        BorderRadius.circular(
                                            12),
                                      ),

                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons
                                            .favorite_border,

                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// INFO
                          Padding(
                            padding:
                            const EdgeInsets.all(12),

                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  product["name"],

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize: 17,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  product["description"],

                                  maxLines: 2,

                                  overflow:
                                  TextOverflow.ellipsis,

                                  style: TextStyle(
                                    color:
                                    Colors.grey.shade600,

                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                                  children: [

                                    Text(
                                      "\$${product["price"]}",

                                      style: const TextStyle(
                                        color: Colors.teal,

                                        fontWeight:
                                        FontWeight.bold,

                                        fontSize: 18,
                                      ),
                                    ),

                                    /// ADD TO CART
                                    GestureDetector(
                                      onTap: () async {

                                        final cart = FirebaseFirestore
                                            .instance
                                            .collection("cart");

                                        final existItem =
                                        await cart
                                            .where(
                                          "name",
                                          isEqualTo:
                                          product["name"],
                                        )
                                            .get();

                                        if (existItem.docs
                                            .isNotEmpty) {

                                          final doc =
                                              existItem.docs.first;

                                          int oldQty =
                                              doc["quantity"] ?? 1;

                                          await cart
                                              .doc(doc.id)
                                              .update({

                                            "quantity":
                                            oldQty + 1,
                                          });

                                        } else {

                                          await cart.add({

                                            "name":
                                            product["name"],

                                            "price":
                                            product["price"],

                                            "image":
                                            product["image"],

                                            "description":
                                            product[
                                            "description"],

                                            "quantity": 1,
                                          });
                                        }

                                        ScaffoldMessenger.of(
                                            context)
                                            .showSnackBar(

                                          SnackBar(
                                            backgroundColor:
                                            Colors.teal,

                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  12),
                                            ),

                                            behavior:
                                            SnackBarBehavior
                                                .floating,

                                            content: const Text(
                                              "Added To Cart 🛒",
                                            ),
                                          ),
                                        );
                                      },

                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(8),

                                        decoration: BoxDecoration(
                                          color: Colors.teal,

                                          borderRadius:
                                          BorderRadius
                                              .circular(12),
                                        ),

                                        child: const Icon(
                                          Icons.add,

                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}