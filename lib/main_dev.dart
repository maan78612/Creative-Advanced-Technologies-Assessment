import 'package:assessment/env/dev.dart';
import 'package:assessment/model_classes/app_config_env.dart';
import 'package:assessment/main.dart' as app;

void main() {
  String env = AppConfigEnv.fromJson(configDev).env;
  app.main(env: env);
}
