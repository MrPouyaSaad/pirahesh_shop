import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pirahesh_shop/common/utils.dart';
import 'package:pirahesh_shop/data/repo/profile_repository.dart';
import 'package:pirahesh_shop/screens/profile/bloc/profile_bloc.dart';
import 'package:pirahesh_shop/screens/widgets/image.dart';

import '../../data/common/constants.dart';
import '../../data/model/order.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            ProfileBloc(profileRepository)..add(ProfileOrderStarted()),
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileOrderLoading || state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileOrderSuccess) {
            return SafeArea(
              child: ListView.builder(
                itemCount: state.order.length,
                itemBuilder: (context, index) {
                  final orderItem = state.order[index];
                  return OrderItemWidget(
                    order: state.order[index], // آیتم سفارش
                  );
                },
              ),
            );
          } else if (state is ProfilOrderError) {
            return Center(child: Text('خطا در بارگذاری سفارشات'));
          } else {
            throw UnimplementedError();
          }
        }),
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    final currentStatus = order.orderStatus == 'PENDING'
        ? 0
        : order.orderStatus == 'COMPLETED'
            ? 1
            : order.orderStatus == 'SHIPPED'
                ? 2
                : 3;

    final List<int> completedSteps = order.orderStatus == 'PENDING'
        ? []
        : order.orderStatus == 'COMPLETED'
            ? [0]
            : order.orderStatus == 'SHIPPED'
                ? [1, 2]
                : [1, 2, 3];
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(CupertinoPageRoute(
        //   builder: (context) => const OrderDetailsScreen(),
        // ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(Constants.primaryPadding),
        decoration: BoxDecoration(
          borderRadius: Constants.primaryRadius,
          color: Theme.of(context).colorScheme.surface,
          boxShadow: Constants.primaryBoxShadow(context),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 68,
                    child: ListView.builder(
                      itemCount: order.orderItems.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 4),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: Constants.primaryRadius,
                                  child: ImageLoadingService(
                                      // width: 42,
                                      imageUrl: Constants.baseImageUrl +
                                          order.orderItems[index].product
                                              .imageUrl),
                                ),
                              ),
                              Text(
                                '×${order.orderItems[index].count}',
                                style: TextStyle(fontSize: 11),
                              )
                            ],
                          ).marginSymmetric(horizontal: 2),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: Constants.primaryPadding * 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(order.orderDate.substring(0, 10)),
                    SizedBox(height: 8),
                    Text(order.totalAmount.withPriceLabel),
                  ],
                ),
              ],
            ).paddingOnly(
              right: Constants.primaryPadding + 8,
              left: Constants.primaryPadding + 8,
              top: Constants.primaryPadding,
            ),
            const SizedBox(height: Constants.primaryPadding),
            CustomStepper(
              currentStep: currentStatus,
              completedSteps: completedSteps,
            ),
            const SizedBox(height: Constants.primaryPadding),
          ],
        ),
      ),
    );
  }
}

class CustomStepper extends StatefulWidget {
  final int currentStep;
  final List<int> completedSteps;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.completedSteps,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  final List<String> labels = ['PENDING', 'COMPLETED', 'SHIPPED', 'DELIVERED'];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(labels.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          final bool isCompleted = widget.completedSteps.contains(stepIndex);
          final bool isCurrent = stepIndex == widget.currentStep;

          return Column(
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: Constants.primaryRadius,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : isCurrent
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.2),
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.timelapse,
                  color: Theme.of(context).colorScheme.surface,
                  size: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[stepIndex],
                style: TextStyle(
                  fontSize: 12,
                  color: isCurrent || isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                ),
              ),
            ],
          );
        } else {
          int stepIndex = index ~/ 2;

          final bool isCompleted = widget.completedSteps.contains(stepIndex);
          final bool isCurrent = stepIndex == widget.currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 2,
              color: isCompleted
                  ? Theme.of(context).colorScheme.primary
                  : isCurrent
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.2), // Adjust color as needed
            ),
          );
        }
      }),
    ).marginSymmetric(horizontal: Constants.primaryPadding);
  }
}
