import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/personalization/screens/address/widgets/single_address.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/helpers/network_manager.dart';
import 'package:shopping_store/utils/popups/full_screen_loader.dart';
import '../../../common/widgets/loader/circular_loader.dart';
import '../../../data/modal/addressModal/addressModal.dart';
import '../../../data/repositories/profileRepositories/addressRepositories.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;

  final _addressRepo = AddressRepository();

  RxList<AddressModel> allAddresses = <AddressModel>[].obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;

  @override
  void onInit() {
    getAllUserAddresses();
    super.onInit();
  }

  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await _addressRepo.fetchAllAddresses();
      allAddresses.assignAll(addresses);

      if (selectedAddress.value.id.isEmpty && addresses.isNotEmpty) {
        selectedAddress.value = addresses.firstWhere(
              (element) => element.selectedAddress,
          orElse: () => addresses.first,
        );
      }
      return addresses;
    } catch (e) {
      HkHelperFunctions.errorSnackBar(title: 'Error Loading Addresses', message: e.toString());
      return [];
    }
  }

  Future<void> selectAddress(AddressModel newSelectedAddress) async {
    try {
      bool isSuccess = await _addressRepo.toggleAddressSelection(newSelectedAddress.id);

      if (isSuccess) {
        for (var address in allAddresses) {
          address.selectedAddress = (address.id == newSelectedAddress.id);
        }
        selectedAddress.value = newSelectedAddress;
        refreshData.toggle();
      }
    } catch (e) {
      HkHelperFunctions.errorSnackBar(title: 'Error in Selection', message: e.toString());
    }
  }

  Future<void> addNewAddress() async {
    try {
      HkFullScreenLoader.openLoadingDialog('Storing Address...', HkImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) { HkFullScreenLoader.stopLoading(); return; }

      if (!addressFormKey.currentState!.validate()) { HkFullScreenLoader.stopLoading(); return; }

      final newAddressData = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        selectedAddress: true,
      );

      final savedAddress = await _addressRepo.addAddress(newAddressData);
      selectedAddress.value = savedAddress;

      await Future.delayed(const Duration(seconds: 4));
      await getAllUserAddresses();

      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.successSnackBar(title: 'Congratulations', message: 'Address Saved!');

      resetFormFields();

      Navigator.of(Get.context!).pop();

    } catch (e) {
      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Bottom Sheet Selection Popup
  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(HkSizes.lg),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HkSectionHeading(title: 'Select Address'),
              const SizedBox(height: HkSizes.spaceBtwSections),
              Expanded(
                child: Obx(
                      () => FutureBuilder(
                    key: Key(refreshData.value.toString()),
                    future: getAllUserAddresses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: HkCircularLoader());
                      }
                      if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                        return const Center(child: Text('No Address Found!'));
                      }

                      final addresses = snapshot.data as List<AddressModel>;

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: addresses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: HkSizes.spaceBtwItems),
                        itemBuilder: (_, index) => HkSingleAddress(
                          address: addresses[index],
                          onTap: () async {
                            await selectAddress(addresses[index]);
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {  },
                  child: const Text('Add new address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetFormFields() {
    name.clear(); phoneNumber.clear(); street.clear();
    postalCode.clear(); city.clear(); state.clear(); country.clear();
    addressFormKey.currentState?.reset();
  }
}
