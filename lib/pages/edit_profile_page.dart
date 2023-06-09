import 'dart:io';
import 'package:blog_app/blocs/blog_user_bloc/blog_user_bloc.dart';
import 'package:blog_app/blocs/blog_user_bloc/blog_user_event.dart';
import 'package:blog_app/constants/color_constants.dart';
import 'package:blog_app/constants/dimension_constants.dart';
import 'package:blog_app/helpers/image_helper.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:blog_app/repositories/user_repository.dart';
import 'package:blog_app/utils/image_upload.dart';
import 'package:blog_app/widgets/common/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileUserPage extends StatefulWidget {
  static const String routeName = '/edit_profile_user_page';
  final UserModel user;
  final String accessToken;
  final Function(Map<String, String>) updateUser;
  const EditProfileUserPage({super.key, required this.user, required this.accessToken, required this.updateUser});

  @override
  State<EditProfileUserPage> createState() => _EditProfileUserPageState();
}

class _EditProfileUserPageState extends State<EditProfileUserPage> {
  File? image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final nameFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name!;
    _accountController.text = widget.user.account!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('pickImage error: $e');
    }
  }
  

  Future<dynamic> saveEditProfile(BuildContext context) async {
      showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    final UserRepository userRepository = UserRepository();
    String msg;
    if (image == null) {
      msg = await userRepository.updateUser(
        _nameController.text,
        widget.user.avatar!,
        widget.accessToken,
      );
      widget.updateUser({
        'name': _nameController.text,
        'avatar': widget.user.avatar!,
      });
    } else {
      String photoUrl = await imageUpload(image);
      msg = await userRepository.updateUser(
        _nameController.text,
        photoUrl,
        widget.accessToken,
      );
      widget.updateUser({
        'name': _nameController.text,
        'avatar': photoUrl,
      });
    }
    if(!mounted) return;
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
    Get.snackbar('Success', msg, backgroundColor: Colors.green, colorText: Colors.white);
    Get.back();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          title: Text("Choose option?"),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(ColorPalette.primaryColor),
              ),
              child: Row(
                children: const [
                  Icon(FontAwesomeIcons.camera),
                  SizedBox(width: kDefaultPadding),
                  Text("Camera"),
                ],
              ),
              onPressed: () {
                pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Row(
                children: const [
                  Icon(FontAwesomeIcons.image),
                  SizedBox(width: kDefaultPadding),
                  Text("Gallery"),
                ],
              ),
              onPressed: () {
                pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: ColorPalette.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: kMediumPadding),
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  width: size.height / 6,
                  height: size.height / 6,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ColorPalette.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: image != null
                      ? ImageHelper.loadImageFile(image!,
                          borderRadius: BorderRadius.circular(500),
                          fit: BoxFit.cover)
                      : ImageHelper.loadImageNetWork(widget.user.avatar!,
                          borderRadius: BorderRadius.circular(500),
                          fit: BoxFit.cover),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      _showDialog(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: Colors.white),
                        color: ColorPalette.primaryColor,
                      ),
                      child: Icon(
                        FontAwesomeIcons.pen,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: kMediumPadding),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                enabled: false,
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: 'Account',
                ),
              ),
              const SizedBox(height: kDefaultPadding * 2),
              Row(
                children: [
                  Expanded(
                      child: ButtonWidget(
                          color: Colors.grey.withOpacity(.1),
                          title: 'Cancel',
                          onPressed: () {
                            Get.back();
                          })),
                  const SizedBox(width: kDefaultPadding),
                  Expanded(
                      child: ButtonWidget(
                          title: 'Save',
                          onPressed: () {
                            saveEditProfile(context);
                          })),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
