import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_todo/features/home/view_models/task_view_model.dart';
import 'package:my_todo/features/sing_in/view_models/sing_in_view_model.dart';
import 'package:my_todo/features/sing_up/view_models/sing_up_view_model.dart';
import 'package:my_todo/repositories/sing_in/sing_in_repo.dart';
import 'package:my_todo/repositories/sing_up/sing_up_repo.dart';
import 'package:my_todo/repositories/task/task_repo.dart';
import 'package:my_todo/resources/constants/constant_url.dart';
import 'package:my_todo/services/secure_storage/secure_storage.dart';
import 'package:my_todo/services/token/token_service.dart';
import 'package:my_todo/state/global_state_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;

Future<void> initialized() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: serverURL,
    anonKey: anonKey,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

Future<void> setUp() async {
  /// registerSingleton locator
  locator.registerSingleton<SecureStorageService>(SecureStorageService());
  final tokenService = await TokenService.create();
  locator.registerSingleton<TokenService>(tokenService);

  locator.registerSingleton<GlobalStateStore>(GlobalStateStore());
  locator.registerSingleton<SingInRepo>(SingInRepo());
  locator.registerSingleton<SingUpRepo>(SingUpRepo());
  locator.registerSingleton<TaskRepo>(TaskRepo());

  /// registerLazySingleton locator
  locator.registerLazySingleton<TaskViewModel>(
    () => TaskViewModel(),
  );
  locator.registerLazySingleton<SingInViewModel>(
    () => SingInViewModel(),
  );
  locator.registerLazySingleton<SingUpViewModel>(
    () => SingUpViewModel(),
  );
}
