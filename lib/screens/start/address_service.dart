import 'package:dio/dio.dart';
import 'package:dongmarket/constants/keys.dart';
import 'package:dongmarket/data/address_model.dart';
import 'package:dongmarket/utils/logger.dart';

class AddressService {

  Future<AddressModel> searchAddressByStr(String text) async {
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'type': 'ADDRESS',
      'category': 'ROAD',
      'query': text,
      'size': 30,
    };

    final response = await Dio()
        .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .catchError((e) {
      logger.e(e);
    });

    // logger.d(response.data is Map);          // Dio가 json을 map으로 자동으로 변환해줬다
    AddressModel addressModel = AddressModel.fromJson(
        response.data['response']);
    logger.d(addressModel);
    return addressModel;
  }

  Future<void> findAddressByCoordinate({required double log, required double lat}) async {
    final Map<String, dynamic> formData = {
      'key': VWORLD_KEY,
      'request': 'getAddress',
      'point': '${log},${lat}',
      'type': 'BOTH',
      'service':'address',
    };

    final response = await Dio()
        .get('http://api.vworld.kr/req/address', queryParameters: formData)
        .catchError((e) {
      logger.e(e);
    });
    logger.d(response);
    return;
  }
}