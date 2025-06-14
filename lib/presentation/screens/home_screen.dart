import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_app/models/product.dart';
import 'package:your_app/screens/product_details_screen.dart';
import 'package:your_app/widgets/product_card.dart';
import 'package:your_app/widgets/product_card_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() {
    // Simulate network call
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        products = List.generate(10, (index) => Product(id: index.toString()));
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 210.h,
            child: isLoading
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: const ProductCardShimmer(),
                      );
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length > 5 ? products.length - 5 : 0,
                    itemBuilder: (context, index) {
                      final product = products[index + 5];
                      return Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: SizedBox(
                          width: 160.w,
                          height: 245.h,
                          child: ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 