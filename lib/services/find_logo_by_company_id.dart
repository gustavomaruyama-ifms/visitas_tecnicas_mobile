import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<CachedNetworkImage> findLogoByCompanyId(id, width, height) async{
  final user =  await getUserData();
  return CachedNetworkImage(
    imageUrl: "http://$API_URL/$COMPANY_URI/id/$id/logo",
    placeholder: (context, url) => Icon(Icons.business),
    errorWidget: (context, url, error) {
      print(error.toString());
      return Icon(Icons.error);
    } ,
    width: width,
    height: height,
    httpHeaders: <String,String>{'x-auth-token': user.token},
  );
}

