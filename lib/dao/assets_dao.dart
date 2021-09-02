import 'package:cryptotracker/model/assets_model.dart';
import 'package:cryptotracker/model/config.dart';
import 'package:dio/dio.dart';

class AssetDao {
  Future<AssetsEntity> getAssets() async {
    Response response = await Dio().get(Config.HOST + "assets?limit2000");
    return AssetsEntity.fromJson(response.data);
  }


}
