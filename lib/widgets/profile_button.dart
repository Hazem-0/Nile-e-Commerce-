import 'package:cx_final_project/block/cubit/passwordSecure_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/passwordSecure_State.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileButton extends StatelessWidget {
  final Icon icon;
  final String name;

  final String status;
  final Color color;

  final int id;
  final editingFormkey = GlobalKey<FormState>();
  final changePasswordFormkey = GlobalKey<FormState>();
  final Map<String, Color> colors;
  ProfileButton(
      {required this.id,
      required this.icon,
      required this.name,
      required this.status,
      required this.color,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (id == 1 || id == 0) {
          showEditingDialog(context, name, status, colors);
        }
        if (id == 3) {
          showChangePasswordDialog(context, colors);
        }
      },
      child: Container(
        height: 75,
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            CircleAvatar(
              child: icon,
              backgroundColor: color,
              foregroundColor: Colors.white,
              radius: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: TextStyle(
                color: colors['fontColor'],
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Expanded(
              child: Text(
                status,
                style: TextStyle(color: colors['fontColor']),
                maxLines: null,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
                onPressed: () => null,
                icon: const Icon(
                  Icons.navigate_next,
                  color: Colors.black26,
                )),
          ],
        ),
      ),
    );
  }

  showEditingDialog(BuildContext context, String type, String value,
      Map<String, Color> colors) {
    TextEditingController valueConteroller = TextEditingController();
    valueConteroller.text = (value == 'not-found') ? "" : value;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: colors['bgColor'],
            title: Text(
              "Enter you new ${type}",
              style: TextStyle(
                color: (colors['mainColor'] == AppColors.mainDarkColor)
                    ? colors['fontColor']
                    : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Container(
              height: 140,
              width: 350,
              child: Form(
                key: editingFormkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      keyboardType: (type == 'Phone')
                          ? TextInputType.number
                          : TextInputType.text,
                      style: TextStyle(color: colors['fontColor']),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: colors['mainColor']!, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: colors['mainColor']!, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: colors['mainColor']!, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: colors['mainColor']!, width: 2),
                        ),
                      ),
                      controller: valueConteroller,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 137, 39, 39),
                              ),
                            )),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                colors['mainColor']!),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                AppColors.bgColor),
                          ),
                          onPressed: () async {
                            if (editingFormkey.currentState!.validate()) {
                              await BlocProvider.of<UserDataCubit>(context)
                                  .updateUserData(valueConteroller.text, type);
                              BlocProvider.of<UserDataCubit>(context)
                                  .fetchUserData();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            "submit",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  showChangePasswordDialog(BuildContext context, Map<String, Color> colors) {
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    Color oldSecureColor = colors['mainColor']!;
    Color newSecureColor = colors['mainColor']!;
    bool isOldSecure = true;
    bool isNewSecure = true;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: colors['bgColor'],
            title: Text(
              "Change your password",
              style: TextStyle(
                color: (colors['mainColor'] == AppColors.mainDarkColor)
                    ? colors['fontColor']
                    : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: BlocConsumer<PasswordsecureCubit, PasswordsecureState>(
              listener: (context, state) {
                if (state is PasswordsecureOff) {
                  if (state.confirm == 0) {
                    oldSecureColor = AppColors.color4;
                    isOldSecure = false;
                  } else {
                    newSecureColor = AppColors.color4;
                    isNewSecure = false;
                  }
                } else if (state is PasswordsecureOn) {
                  if (state.confirm == 0) {
                    oldSecureColor = colors['mainColor']!;
                    isOldSecure = true;
                  } else {
                    newSecureColor = colors['mainColor']!;
                    isNewSecure = true;
                  }
                }
              },
              builder: (context, state) {
                return Container(
                  height: 210,
                  width: 350,
                  child: Form(
                    key: changePasswordFormkey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            obscureText: isOldSecure,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            style: TextStyle(color: colors['fontColor']),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: colors['fontColor'],
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: oldSecureColor,
                                ),
                                onPressed: () {
                                  BlocProvider.of<PasswordsecureCubit>(context)
                                      .toggleState(isOldSecure, 0);
                                },
                              ),
                              hintText: "Old password",
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                            ),
                            controller: oldPassword,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(color: colors['fontColor']),
                            obscureText: isNewSecure,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your new password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: newSecureColor,
                                ),
                                onPressed: () {
                                  BlocProvider.of<PasswordsecureCubit>(context)
                                      .toggleState(isNewSecure, 1);
                                },
                              ),
                              hintText: "New password",
                              hintStyle: TextStyle(
                                color: colors['fontColor'],
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: colors['mainColor']!, width: 2),
                              ),
                            ),
                            controller: newPassword,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  )),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          colors['mainColor']!),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          AppColors.offWhite),
                                ),
                                onPressed: () {
                                  if (changePasswordFormkey.currentState!
                                      .validate()) {
                                    BlocProvider.of<UserDataCubit>(context)
                                        .updatePassword(context,
                                            oldPassword.text, newPassword.text);
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "submit",
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
