import 'package:dongmarket/constants/common_size.dart';
import 'package:dongmarket/data/address_model.dart';
import 'package:dongmarket/screens/start/address_service.dart';
import 'package:dongmarket/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left:common_padding, right: common_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (text) async {
              _addressModel = await AddressService().searchAddressByStr(text);
              setState(() {

              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintText: '도로명으로 검색',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 24, minHeight: 24),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
          ),
              TextButton.icon(
                onPressed: () async {
                  Location location = new Location();

                  bool _serviceEnabled;
                  PermissionStatus _permissionGranted;
                  LocationData _locationData;

                  _serviceEnabled = await location.serviceEnabled();
                  if (!_serviceEnabled) {
                    _serviceEnabled = await location.requestService();
                    if (!_serviceEnabled) {
                      return;
                    }
                  }

                  _permissionGranted = await location.hasPermission();
                  if (_permissionGranted == PermissionStatus.denied) {
                    _permissionGranted = await location.requestPermission();
                    if (_permissionGranted != PermissionStatus.granted) {
                      return;
                    }
                  }

                  _locationData = await location.getLocation();
                  logger.d(_locationData);
                  AddressService().findAddressByCoordinate(log: _locationData.longitude!, lat: _locationData.latitude!);
                },
                icon: const Icon(CupertinoIcons.compass, color: Colors.white,size: 20,),
                label: Text(
                  '현재위치 찾기',
                  style: Theme.of(context).textTheme.button,
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor, minimumSize: Size(10, 48)),
              ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: common_padding),
              itemBuilder: (context, index) {
                if(_addressModel==null || _addressModel!.result==null || _addressModel!.result!.items==null || _addressModel!.result!.items![index].address==null)
                  return Container();
              logger.d('index:$index');
              return ListTile(
                title: Text(_addressModel!.result!.items![index].address!.road??''),
                subtitle: Text(_addressModel!.result!.items![index].address!.parcel??''),
              );
            },itemCount: (_addressModel==null || _addressModel!.result==null || _addressModel!.result!.items==null)?0:_addressModel!.result!.items!.length,),
          )
        ],
      ),
    );
  }
}
