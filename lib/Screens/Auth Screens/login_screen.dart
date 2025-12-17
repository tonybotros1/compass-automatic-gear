import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../Controllers/Auth screen controllers/login_screen_controller.dart';
import '../../consts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginScreenController loginScreenController = Get.put(
    LoginScreenController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: KeyboardListener(
        autofocus: true,
        focusNode: loginScreenController.focusNode,
        onKeyEvent: (KeyEvent event) {
          // if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            loginScreenController
                .singIn(); // Call the login function when "Enter" is pressed
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: loginScreenController.formKeyForlogin,
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight / 20),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight > 400
                              ? constraints.maxHeight / 2
                              : constraints.maxHeight / 1.5,
                          maxWidth: constraints.maxWidth > 600
                              ? constraints.maxWidth / 2
                              : constraints.maxWidth / 1.5,
                        ),
                        // width: constraints.maxWidth > 600
                        //     ? 400
                        //     : Get.width * 0.8, // Responsive width
                        // height: 300,
                        child: Image.asset('assets/DATAHUB_LIGHT.png'),
                      ),
                      myTextFormField1(
                        constraints: constraints,
                        obscureText: false,
                        controller: loginScreenController.email,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validate: true,
                      ),
                      Obx(
                        () => myTextFormField1(
                          constraints: constraints,
                          icon: IconButton(
                            onPressed: () {
                              loginScreenController.changeObscureTextValue();
                            },
                            icon: Icon(
                              loginScreenController.obscureText.value
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off,
                            ),
                          ),
                          obscureText: loginScreenController.obscureText.value,
                          controller: loginScreenController.pass,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          validate: true,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight / 10),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  loginScreenController.sigingInProcess.value
                                  ? null
                                  : () {
                                      if (!loginScreenController
                                          .formKeyForlogin
                                          .currentState!
                                          .validate()) {
                                      } else {
                                        loginScreenController.singIn();
                                      }
                                    },
                              style: loginButtonStyle,
                              child:
                                  loginScreenController.sigingInProcess.value ==
                                      false
                                  ? const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                            ),
                            // const SizedBox(width: 20),
                            // kIsWeb
                            //     ? ElevatedButton(
                            //         style: newCompannyButtonStyle,
                            //         onPressed: () {
                            //           Get.toNamed('/registerScreen');
                            //         },
                            //         child: const Text('Are you a new company?'),
                            //       )
                            //     : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget myTextFormField1({
  required String labelText,
  required String hintText,
  required TextEditingController controller,
  required bool validate,
  required bool obscureText,
  IconButton? icon,
  required BoxConstraints constraints,
  TextInputType? keyboardType,
}) {
  return Container(
    constraints: BoxConstraints(
      maxHeight: constraints.maxHeight > 400
          ? constraints.maxHeight / 3
          : constraints.maxHeight / 1.3,
      maxWidth: constraints.maxWidth > 600
          ? constraints.maxWidth / 3
          : constraints.maxWidth / 1.3,
    ),
    child: TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: icon,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: labelText,
        floatingLabelStyle:const TextStyle(fontSize: 20),
        hintText: hintText,
        labelStyle: regTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
      ),
      validator: validate != false
          ? (value) {
              if (value!.isEmpty) {
                return 'Please Enter $labelText';
              }
              return null;
            }
          : null,
    ),
  );
}
