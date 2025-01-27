import 'package:flutter/material.dart';
import 'package:pirahesh_shop/common/utils.dart';
import 'package:pirahesh_shop/data/common/constants.dart';
import 'package:pirahesh_shop/screens/widgets/image.dart';
import '../../../data/model/order.dart';

class FactorScreen extends StatelessWidget {
  const FactorScreen({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Invoice'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Number: ${order.orderNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Order Date: ${order.orderDate}'),
                    const SizedBox(height: 8),
                    Text('Order Status: ${order.orderStatus}'),
                    const SizedBox(height: 8),
                    Text('Total Items: ${order.count}'),
                    const SizedBox(height: 8),
                    Text(
                      'Total Amount: \$${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Order Items Section
              Expanded(
                child: ListView.builder(
                  itemCount: order.orderItems.length,
                  itemBuilder: (context, index) {
                    final item = order.orderItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ImageLoadingService(
                          imageUrl:
                              Constants.baseImageUrl + item.product.imageUrl,
                          width: 50,
                        ),
                        title: Text(item.product.title),
                        subtitle: Text('Quantity: ${item.count}'),
                        trailing: Text(
                          '${(item.product.price * item.count).withPriceLabel}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Thank You Message Section
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Thank you for your purchase! We hope to see you again soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
