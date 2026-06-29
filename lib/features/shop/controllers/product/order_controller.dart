import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/success_screen/success_screen.dart';
import 'package:shopping_store/features/personalization/controllers/address_controller.dart';
import 'package:shopping_store/features/shop/controllers/product/cart_controller.dart';
import 'package:shopping_store/features/shop/controllers/product/checkout_controller.dart';
import 'package:shopping_store/utils/constants/enums.dart' hide OrderStatus;
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/popups/full_screen_loader.dart';
import '../../../../data/modal/orderModal/orderModal.dart';
import '../../../../data/repositories/orderRepositories/orderRepositories.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/image_strings.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  var userOrders = <OrderModel>[].obs;
  var isLoading = false.obs;

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      isLoading.value = true;

      final userId = _getLoggedInUserId();

      final orders = await orderRepository.fetchUserOrders(userId);
      userOrders.assignAll(orders);
      return orders;
    } catch (e) {
      print(e);
      HkHelperFunctions.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  void processOrder(double totalAmount) async {
    try {
      HkFullScreenLoader.openLoadingDialog('Processing your order...', HkImages.pencilAnimation);

      final usedId = _getLoggedInUserId();
      if (usedId.isEmpty) {
        HkFullScreenLoader.stopLoading();
        return;
      }

      OrderModel order = OrderModel(
        id: UniqueKey().toString(),
        status: OrderStatus.pending,
        items: cartController.cartItems.toList(),
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        userId: usedId,
        paymentMethod: checkoutController.selectedPaymentMethod.value['name'].toString(),
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 4)),
      );

      final savedOrder = await orderRepository.createOrder(order);

      HkFullScreenLoader.stopLoading();

      if (savedOrder != null) {
        userOrders.add(savedOrder);
        cartController.clearCart();

        Get.off(() => SuccessScreen(
          image: HkImages.successfulPaymentIcon,
          title: 'Payment Success!',
          subtitle: 'Your item will be shipped soon!',
          onPress: () => Get.offAll(() => const NavigationMenu()),
        ));
      } else {
        HkHelperFunctions.errorSnackBar(
          title: 'Database Error',
          message: 'Server par order save nahi ho paya, please retry.',
        );
      }
    } catch (e) {
      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  String _getLoggedInUserId() {
    try {
      if (Get.isRegistered<dynamic>(tag: 'UserController')) {
        final userController = Get.find<dynamic>(tag: 'UserController');
        if (userController.user.value.id != null) {
          return userController.user.value.id.toString();
        }
      }
    } catch (_) {}
    return "user_12345";
  }
}
