import 'package:dartserverstarter/apps/users/user.model.dart';
import 'package:dartserverstarter/utils/database.dart';
import 'package:dartserverstarter/utils/error.dart';
import 'package:dartz/dartz.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserServices {
  static UserServices? _instance;
  UserServices._internal(){
    userCollection = DatabaseSetupConnection.instance.db?.collection('users');
  }
  static UserServices get instance => _instance ??= UserServices._internal();
  DbCollection? userCollection;

  Future<Either<Map<String,dynamic>?,AppError>> addUser(User user) async {
    try{
    var resp = await userCollection?.insertOne(user.toMap());
    return Left(resp?.document);
    }catch (e){
      return Right(DatabaseInsertionError());
    }
  }

  Future<dynamic> updateUser(User user) async {
  }


  Future<bool> checkForDuplicateEmail(String email) async {
    var res = await userCollection?.findOne({'email':'$email'});
    if(res == null){
      return false;
    }
    return true;
  }

}