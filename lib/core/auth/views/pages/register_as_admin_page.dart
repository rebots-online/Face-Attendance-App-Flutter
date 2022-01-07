import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../data/helpers/form_verify.dart';
import '../../../widgets/app_button.dart';
import '../../controllers/signup_controller.dart';

class RegisterAsAdminPage extends StatefulWidget {
  const RegisterAsAdminPage({Key? key}) : super(key: key);

  @override
  _RegisterAsAdminPageState createState() => _RegisterAsAdminPageState();
}

class _RegisterAsAdminPageState extends State<RegisterAsAdminPage> {
  /* <---- Dependency -----> */
  final SignUpController _controller = Get.put(SignUpController());

  /* <---- Text Editing Controllers ----> */
  late TextEditingController nameController;
  late TextEditingController companyName;
  late TextEditingController emailController;
  late TextEditingController extrainfo;

  _initializeControllers() {
    nameController = TextEditingController();
    companyName = TextEditingController();
    emailController = TextEditingController();
    extrainfo = TextEditingController();
  }

  _disposeControllers() {
    nameController.dispose();
    companyName.dispose();
    emailController.dispose();
    extrainfo.dispose();
  }

  // Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RxBool _isSendingData = false.obs;

  Future<void> _onCreateUser() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      AppUiHelper.dismissKeyboard(context: context);
      _isSendingData.trigger(true);
      prepareEmail();
      try {
        await FlutterEmailSender.send(email);
        _isSendingData.trigger(false);
      } on Exception catch (e) {
        print(e);
        _isSendingData.trigger(false);
      }
    }
  }

  Email email = Email();

  void prepareEmail() {
    email = Email(
      body: '''
    Hello I am ${nameController.text},
    I want to join FaceAttendance app as an Admin.

    Email Address: ${emailController.text}
    Company Name: ${companyName.text}
    I heard about you: ${extrainfo.text}

    Thank you.
    Have a good day.
    ''',
      subject: 'Register as Admin at FaceAttendance App',
      recipients: ['mdmomin322@gmail.com'],
      isHTML: false,
    );
  }

  /* <---- State ----> */
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    _isSendingData.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register As Admin'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* <---- Header ----> */
              Image.asset(AppImages.illustrationWelcome),
              /* <---- Form ----> */
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.all(AppSizes.defaultMargin),
                  padding: const EdgeInsets.all(AppSizes.defaultMargin),
                  child: Column(
                    children: [
                      // Full Name
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_rounded),
                          hintText: 'John Doe',
                        ),
                        controller: nameController,
                        validator: (value) {
                          return AppFormVerify.name(fullName: value);
                        },
                      ),
                      AppSizes.hGap20,
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Company Name',
                          prefixIcon: Icon(Icons.business_center_rounded),
                          hintText: 'Ahi Distribution',
                        ),
                        controller: companyName,
                        validator: (value) {
                          return AppFormVerify.name(fullName: value);
                        },
                      ),
                      AppSizes.hGap20,
                      // Email
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_rounded),
                          hintText: 'you@email.com',
                        ),
                        controller: emailController,
                        validator: (value) {
                          return AppFormVerify.email(email: value);
                        },
                      ),
                      AppSizes.hGap20,
                      // Where did you find about us
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Some Info',
                          prefixIcon: Icon(Icons.question_answer_rounded),
                          hintText: 'Where did you find about us?',
                        ),
                        controller: extrainfo,
                        validator: (value) {
                          return AppFormVerify.info(info: value);
                        },
                      ),

                      /* <---- Submit Button ----> */
                      AppSizes.hGap30,
                      Obx(
                        () => AppButton(
                          label: 'Submit',
                          isLoading: _isSendingData.value,
                          onTap: _onCreateUser,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
