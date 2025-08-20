import 'dart:developer';
import 'dart:io';
import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/info/cart_list.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cx_final_project/block/cubit/login_cubit.dart';
import 'package:cx_final_project/block/cubit_state/user_data_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataCubit extends Cubit<UserDataStates> {
  UserDataCubit() : super(UserDataInitial());
  final ImagePicker _picker = ImagePicker();
  File? userImage;
  String? imageURL;
  String? token;

  Map<String, dynamic> userData = {
    'name': 'not-found',
    'email': 'not-found',
    'phone': 'not-found',
    'favoriteProducts': null,
    'cartProducts': null,
  };

  Map<String, dynamic>? favoriteProducts;
  Map<String, dynamic>? cartProducts;

  Future<void> setUserData(
    UserCredential user,
    String name,
    String phone,
    String email,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .set({
        'name': name,
        'phone': phone,
        'email': email,
        'favoriteProducts': null,
        'cartProducts': null,
      });
      // log('Done');
    } catch (e) {
      log('Error: $e');
    }
  }

  void fetchUserData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = await pref.getString("login");

    // log(token!);
    emit(UserDataLoading());
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(token).get();

      await getProfilePic(token!);

      // log(userDoc!.exists.toString());
      // log(token!);
      if (userDoc.exists) {
        // log('stop here');
        emit(UserDataLoading());
        userData['name'] = userDoc.get('name');
        userData['email'] = userDoc.get('email');
        userData['phone'] = userDoc.get('phone');
        // favoriteChoosed =await userData['favoriteProducts'];
        emit(FetechedDataSuccess());
        // cartProductCount =await userData['cartProducts'];
        // log("111" + userData.toString());
        // log(userData.toString());
        // print("im heeeeeeeeeeeeere!!!!!");
        // print(userData);
      } else {
        emit(FetechedDataSuccess());
        // log('got here ');

        userData = await {
          'name': 'not-found',
          'email': 'not-found',
          'phone': 'not-found',
          'favoriteProducts': favoriteProducts,
          'cartProducts': cartProducts,
        };
      }
    } catch (e) {
      emit(FetechedDataFailuer());
      userData = await {
        'name': 'not-found',
        'email': 'not-found',
        'phone': 'not-found',
        'favoriteProducts': favoriteProducts,
        'cartProducts': cartProducts,
      };
    }
  }

  Future<void> updateUserData(newValue, String key) async {
    emit(UserDataLoading());
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      key = (key != "favoriteProducts" && key != "cartProducts")
          ? key.toLowerCase()
          : key;
      if (currentUser != null) {
        String userId = currentUser.uid;
        await getProfilePic(currentUser.uid);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          key: newValue,
        });
        emit(UpdatedDataSuccess());
      } else {
        emit(UpdateddDataFailuer());
      }
    } catch (e) {
      emit(UpdateddDataFailuer());
    }
  }

  void setProducts() {
    try {
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference documentReference =
          collectionReference.doc(token);
      // print(cartProductCount);
      documentReference.update({
        'favoriteProducts': favoriteChoosed,
        'cartProducts': cartProductCount,
      });
      emit(SetDataSuccess());
      // log('updated maps successfully');
    } on FirebaseException catch (e) {
      log(e.code);
      emit(SetDataFailuer());
    }
  }

  bool getCartCountOnce = false;

  void resetBoleanCart() {
    getCartCountOnce = false;
  }

  Future<void> fetchProducts(BuildContext context, tempProducts) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(token).get();

      if (userDoc.exists) {
        Map<String, dynamic> userDataTemp =
            userDoc.data() as Map<String, dynamic>;
        if (userDataTemp.containsKey('favoriteProducts')) {
          favoriteProducts =
              await userDataTemp['favoriteProducts'] ?? favoriteChoosed;
        }
        if (userDataTemp.containsKey('cartProducts')) {
          cartProducts = await userDataTemp['cartProducts'] ?? cartProducts;
        }
        // log('fetched products data successfully');
        // log(favoriteProducts.toString());
        // log(cartProducts.toString());
        if (!getCartCountOnce) {
          BlocProvider.of<CartCubit>(context).fetchCartCount(cartProducts);
          getCartCountOnce = true;
        }
        // tempAllProducts=await tempProducts ;
        emit(FetechedDataSuccess());
      }
    } on FirebaseException catch (e) {
      // log('here');
      log(e.code);
      emit(FetechedDataFailuer());
    }
  }

  Future<void> pickImageFromGallery() async {
    emit(SetImageLoading());
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        userImage = File(image.path);
        await uploadImageToFirebase(userImage!);
      }
      emit(SetImageSuccess());
    } catch (e) {
      emit(SetImageFailuer());
    }
  }

  Future<void> pickImageFromCamera() async {
    emit(SetImageLoading());
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        userImage = File(image.path);
        // log(userImage.toString());
        await uploadImageToFirebase(userImage!);
      }
      emit(SetImageSuccess());
    } catch (e) {
      emit(SetImageFailuer());
    }
  }

  void removePic() {
    userImage = null;
    removePic();
    emit(SetImageFailuer());
  }

  Future<void> updatePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    emit(UserDataLoading());
    UserCredential user = BlocProvider.of<LoginCubit>(context).getUser!;
    try {
      AuthCredential cred = EmailAuthProvider.credential(
          email: user.user!.email!, password: oldPassword);

      await user.user!.reauthenticateWithCredential(cred);

      await user.user!.updatePassword(newPassword);

      emit(UpdatePasswordSuccess());
    } catch (e) {
      emit(UpdatePasswordFailuer());
    }
  }

  Future<void> uploadImageToFirebase(File imageFile) async {
    emit(SetImageLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('$userId/images/profilePic');

      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;
      // final Directory appDocDir = await getApplicationDocumentsDirectory();
      // final File temp = File('${appDocDir.path}/profilePic.jpg');
      await taskSnapshot.ref.writeToFile(imageFile);

      userImage = imageFile;
      // print(userImage);
      emit(UploadedImageSuccess());
    } catch (e) {
      emit(UploadedImageFailuer());
    }
  }

  Future<void> getProfilePic(String userToken) async {
    emit(SetImageLoading());

    emit(UserDataLoading());
    try {
      // log(userToken);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('${userToken}/images/profilePic');
      // log('1');
      final Directory appDocDir = await getTemporaryDirectory();
      // log('2');

      final File temp = File('${appDocDir.path}/${userToken}.jpg');
      // log('3');

      if (await temp.exists()) {
        temp.deleteSync();
        // print('Existing file deleted.');
      }
      await firebaseStorageRef.writeToFile(temp);

      // log('4');
      userImage = temp;
      // print(userImage);
      // log("fetched");
      // print(userToken);
      emit(UploadedImageSuccess());
    } catch (e) {
      // Emit failure state if an error occurs
      log(e.toString());
      emit(UploadedImageFailuer());
    }
  }

  Future<void> deleteImageFromFirebase(String token) async {
    emit(SetImageLoading());
    try {
      // final userId =await FirebaseAuth.instance.currentUser!.uid;

      final storageRef =
          FirebaseStorage.instance.ref().child('${token}/images/profilePic');

      // log(token);

      await storageRef.delete();
      userImage = null;
      imageURL = null;
      emit(UploadedImageSuccess());
    } catch (e) {
      log(e.toString());
      emit(UploadedImageFailuer());
    }
  }
}
