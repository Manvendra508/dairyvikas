import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/plan_subscription/presentation/controllers/subscription_plan_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class PaymentCotnroller extends GetxController {
  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    playSound();
  }

  playSound() {
    if (AppState.isPaymentSuccess) {
      playPaymentSuccessSound();
    } else {
      playPaymentFailedSound();
    }
  }

  playPaymentSuccessSound() async {
    await player.play(AssetSource('audios/payment_success.mp3'));
  }

  playPaymentFailedSound() async {
    await player.play(AssetSource('audios/payment_failed.mp3'));
  }

  retryPayment() {
    AppNavigation.goBack();
    final subscriptionController = Get.find<SubscriptionPlanController>();

    subscriptionController.startPayment(subscriptionController.selectedPlan);
  }
}
