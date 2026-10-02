import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/shop/data/models/order_model.dart';
import 'package:shop/features/shop/presentation/cubit/orders/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitState());

  static OrdersCubit get(context) => BlocProvider.of(context);

  OrderStatus selectedStatus = OrderStatus.active;

  void selectStatus(OrderStatus status) {
    selectedStatus = status;
    emit(OrdersTabChangedState());
  }
}
