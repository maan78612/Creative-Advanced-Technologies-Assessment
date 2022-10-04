import 'package:assessment/env/prod.dart';
import 'package:assessment/main.dart' as app;
import 'package:assessment/model_classes/app_config_env.dart';


void main() {

  String env = AppConfigEnv.fromJson(configPro).env;
  app.main(env: env);
}
