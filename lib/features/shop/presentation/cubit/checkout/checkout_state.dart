abstract class CheckoutState {}

class CheckoutInitState extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {}

class CheckoutOrderPlacedState extends CheckoutState {}

class CheckoutErrorState extends CheckoutState {
  CheckoutErrorState(this.message);
  final String message;
}
