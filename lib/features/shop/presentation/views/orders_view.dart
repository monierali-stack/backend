import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/data/models/order_model.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/cubit/orders/orders_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/orders/orders_state.dart';
import 'package:shop/features/shop/presentation/views/order_details_view.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/features/shop/presentation/views/widgets/order_card.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
    MainCubit.get(context).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, mainState) {
          var mainCubit = MainCubit.get(context);
          return BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              var cubit = OrdersCubit.get(context);
              var orders = mainCubit.ordersByStatus(cubit.selectedStatus);
              return Scaffold(
                backgroundColor: AppColors.scaffoldBackground,
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios_new,
                                  color: AppColors.black, size: 20),
                            ),
                            Expanded(
                              child: Text(
                                'My Orders',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            _StatusPill(
                              label: 'Active',
                              selected: cubit.selectedStatus == OrderStatus.active,
                              onTap: () => cubit.selectStatus(OrderStatus.active),
                            ),
                            const SizedBox(width: 10),
                            _StatusPill(
                              label: 'Completed',
                              selected: cubit.selectedStatus == OrderStatus.completed,
                              onTap: () => cubit.selectStatus(OrderStatus.completed),
                            ),
                            const SizedBox(width: 10),
                            _StatusPill(
                              label: 'Cancelled',
                              selected: cubit.selectedStatus == OrderStatus.cancelled,
                              onTap: () => cubit.selectStatus(OrderStatus.cancelled),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: mainCubit.isLoadingOrders
                            ? const Center(child: CircularProgressIndicator())
                            : mainCubit.ordersError != null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: Text(
                                        mainCubit.ordersError!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.darkGery, fontSize: 13),
                                      ),
                                    ),
                                  )
                                : orders.isEmpty
                                    ? _EmptyState(status: cubit.selectedStatus)
                                    : RefreshIndicator(
                                        color: AppColors.primary,
                                        onRefresh: mainCubit.loadOrders,
                                        child: ListView(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          children: [
                                            for (final order in orders)
                                              OrderCard(
                                                order: order,
                                                onTap: () => goTo(context,
                                                    toPage:
                                                        OrderDetailsView(order: order)),
                                                onCancel: () =>
                                                    mainCubit.cancelOrder(order.id),
                                                onTrackDriver: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                          'Driver tracking coming soon'),
                                                      backgroundColor: AppColors.primary,
                                                      behavior: SnackBarBehavior.floating,
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      OrderStatus.active => 'active',
      OrderStatus.completed => 'completed',
      OrderStatus.cancelled => 'cancelled',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              "You don't have any $label orders at this time",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
