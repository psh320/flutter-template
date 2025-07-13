
import 'package:get_it/get_it.dart';
import 'package:profitable_flutter_app/config.dart';
import 'package:profitable_flutter_app/core/services/api_service.dart';
import 'package:profitable_flutter_app/core/services/in_app_purchase_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => ApiService());

  if (useInAppPurchases) {
    getIt.registerLazySingleton(() => InAppPurchaseService());
  }
}
