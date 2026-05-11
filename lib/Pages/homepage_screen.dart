import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart';
import 'category_products_screen.dart';
class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {

  List<String> categories = [
    "Men",
    "Women",
    "Shoes",
    "Baby",
  ];

  int selectedCategory = 0;

  String searchText = "";

  Stream<List<ProductModel>> getProducts() {

    return FirebaseFirestore.instance
        .collection("products")
        .where(
      "category",
      isEqualTo: categories[selectedCategory],
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ProductModel.fromJson(
          doc.data(),
          doc.id,
        ),
      )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF4F6F8),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF4F6F8),
        elevation: 0,


        title: const Text(
          "JO Market",
          style: TextStyle(
            color: Color.fromRGBO(47, 80, 76, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1,
          ),
        ),

        actions: [

          /// FAVORITE BUTTON
          Container(
            margin: const EdgeInsets.only(right: 10),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),

            child: IconButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const FavoriteScreen(),
                  ),
                );
              },

              icon: const Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),

          /// CART BUTTON
          Container(
            margin: const EdgeInsets.only(right: 10),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),

            child: IconButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const CartScreen(),
                  ),
                );
              },

              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.teal,
              ),
            ),
          ),

          /// LOGOUT BUTTON
          Container(
            margin: const EdgeInsets.only(right: 15),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),

            child: IconButton(
              onPressed: () async {

                /// Logout Dialog
                showDialog(
                  context: context,

                  builder: (context) {

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                      ),

                      title: const Text(
                        "Logout",style: TextStyle(color: Colors.black),
                      ),

                      content: const Text(
                        "Are you sure you want to logout?",
                      ),

                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: const Text(
                            "Cancel",style: TextStyle(color: Colors.black),
                          ),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),

                          onPressed: () async {

                            final SharedPreferences prefs =
                            await SharedPreferences.getInstance();


                            await prefs.remove("userID");


                            Navigator.pop(context);


                            Navigator.pushAndRemoveUntil(
                              context,

                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),

                                  (route) => false,
                            );
                          },

                          child: const Text(
                            "Logout",
                          ),
                        ),
                      ],
                    );
                  },
                );
              },

              icon: const Icon(
                Icons.logout,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(18),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [



              const SizedBox(height: 5),

              Text(
                "Find your best outfit style",

                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              /// Search Bar
              Container(

                decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [

                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),

                child: TextField(

                  onChanged: (value) {

                    setState(() {
                      searchText = value.toLowerCase();
                    });
                  },

                  decoration: InputDecoration(

                    hintText: "Search clothes...",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),

                    prefixIcon: const Icon(Icons.search),

                    border: InputBorder.none,

                    contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Banner
              Container(

                height: 180,
                width: double.infinity,

                decoration: BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(25),

                  image: const DecorationImage(
                    image: AssetImage(
                        "assets/banner.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Container(

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(25),

                    gradient: LinearGradient(

                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],

                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),

                  child: const Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    mainAxisAlignment:
                    MainAxisAlignment.end,

                    children: [

                      Text(
                        "New Collection",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Summer 2026",

                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Categories
              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: const [

                  Text(
                    "Categories",

                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "See All",

                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(

                height: 50,

                child: ListView.builder(

                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,

                  itemBuilder: (context, index) {

                    bool isSelected =
                        selectedCategory == index;

                    return GestureDetector(

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (context) => CategoryProductsScreen(
                              category: categories[index],
                            ),
                          ),
                        );
                      },

                      child: AnimatedContainer(

                        duration:
                        const Duration(milliseconds: 300),

                        margin:
                        const EdgeInsets.only(right: 12),

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),

                        decoration: BoxDecoration(

                          color: isSelected
                              ? Colors.teal
                              : Colors.white,

                          borderRadius:
                          BorderRadius.circular(15),

                          boxShadow: [

                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.08),

                              blurRadius: 8,
                            ),
                          ],
                        ),

                        child: Text(

                          categories[index],

                          style: TextStyle(

                            color: isSelected
                                ? Colors.white
                                : Colors.black,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// Products Title
              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: const [

                  Text(
                    "New Arrivals",

                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "View More",

                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Products
              StreamBuilder<List<ProductModel>>(

                stream: getProducts(),

                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {

                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child:
                        CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {

                    return const Center(
                      child:
                      Text("Something went wrong"),
                    );
                  }

                  final products =
                      snapshot.data ?? [];

                  final filteredProducts =
                  products.where((product) {

                    return product.name
                        .toLowerCase()
                        .contains(searchText);

                  }).toList();

                  if (filteredProducts.isEmpty) {

                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text("No Products"),
                      ),
                    );
                  }

                  return GridView.builder(

                    shrinkWrap: true,

                    physics:
                    const NeverScrollableScrollPhysics(),

                    itemCount:
                    filteredProducts.length,

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.68,
                    ),

                    itemBuilder: (context, index) {

                      final product =
                      filteredProducts[index];

                      return Container(

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(22),

                          boxShadow: [

                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.08),

                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            /// Image
                            Expanded(

                              child: Stack(

                                children: [

                                  Container(

                                    decoration: BoxDecoration(

                                      borderRadius:
                                      const BorderRadius.only(
                                        topLeft:
                                        Radius.circular(22),
                                        topRight:
                                        Radius.circular(22),
                                      ),

                                      image: DecorationImage(

                                        image: NetworkImage(
                                            product.image),

                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

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
                                          !product.isFavorite,
                                        });
                                      },

                                      child: Container(

                                        padding:
                                        const EdgeInsets
                                            .all(8),

                                        decoration:
                                        BoxDecoration(

                                          color: Colors.white,

                                          borderRadius:
                                          BorderRadius
                                              .circular(12),
                                        ),

                                        child: Icon(

                                          product.isFavorite
                                              ? Icons.favorite
                                              : Icons
                                              .favorite_border,

                                          color:
                                          product.isFavorite
                                              ? Colors.red
                                              : Colors.black,

                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Info
                            Padding(

                              padding:
                              const EdgeInsets.all(12),

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    product.name,

                                    maxLines: 1,

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(

                                    product.description,

                                    maxLines: 2,

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style: TextStyle(
                                      color:
                                      Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Row(

                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,

                                    children: [

                                      Text(

                                        "\$${product.price}",

                                        style:
                                        const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      GestureDetector(

                                        onTap: () async {

                                          await FirebaseFirestore
                                              .instance
                                              .collection(
                                              "cart")
                                              .add({

                                            "name":
                                            product.name,

                                            "price":
                                            product.price,

                                            "image":
                                            product.image,

                                            "description":
                                            product.description,

                                            "quantity": 1,
                                          });

                                          ScaffoldMessenger.of(
                                              context)
                                              .showSnackBar(

                                            const SnackBar(
                                              content: Text(
                                                  "Added To Cart"),
                                            ),
                                          );
                                        },

                                        child: Container(

                                          padding:
                                          const EdgeInsets
                                              .all(8),

                                          decoration:
                                          BoxDecoration(

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
            ],
          ),
        ),
      ),
    );
  }
}