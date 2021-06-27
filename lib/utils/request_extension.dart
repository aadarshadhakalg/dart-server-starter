import 'dart:convert';

import 'package:dartserverstarter/utils/error.dart';
import 'package:dartz/dartz.dart';
import 'package:shelf/src/request.dart';

extension AppRequest on Request{
  
  Future<Either<Map<String,dynamic>,AppError>> data()async{
    try{
      return Left(jsonDecode(await readAsString()));
    } catch(e){
      return Right(InvalidDataError());
    }
  }

}