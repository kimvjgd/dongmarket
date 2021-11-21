import 'package:dongmarket/constants/common_size.dart';
import 'package:dongmarket/states/user_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/src/provider.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  final inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  final TextEditingController _phoneNumberEditingController =
      TextEditingController(text: "010");

  final TextEditingController _codeController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late VerificationStatus _verificationsStatus = VerificationStatus.none;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verificationsStatus == VerificationStatus.verifying,
          child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  '전화번호 로그인',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(common_padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ExtendedImage.asset(
                          'assets/imgs/padlock.png',
                          width: size.width * 0.15,
                          height: size.width * 0.15,
                        ),
                        SizedBox(width: common_sm_padding),
                        Text('''토마토 마켓은 휴대폰 번호로 가입해요.
번호는 안전하게 보관 되며
어디에도 공개되지 않아요.
                      ''')
                      ],
                    ),
                    SizedBox(height: common_padding),
                    TextFormField(
                      controller: _phoneNumberEditingController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                      decoration: InputDecoration(
                          focusedBorder: inputBorder, border: inputBorder),
                      validator: (phoneNumber) {
                        if (phoneNumber != null && phoneNumber.length == 13) {
                          return null;
                        } else {
                          return '올바른 전화번호 양식을 적어주세요.';
                        }
                      },
                    ),
                    SizedBox(
                      height: common_sm_padding,
                    ),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState != null) {
                            bool passed = _formKey.currentState!.validate();
                            if (passed) {
                              setState(() {
                                _verificationsStatus =
                                    VerificationStatus.codeSent;
                              });
                            }
                          }
                        },
                        child: Text('인증 문자 발송')),
                    SizedBox(
                      height: common_padding,
                    ),
                    AnimatedOpacity(
                      duration: duration,
                      opacity: (_verificationsStatus == VerificationStatus.none)
                          ? 0
                          : 1,
                      child: AnimatedContainer(
                        duration: duration,
                        curve: Curves.easeInOut,
                        height: getVerificationHeight(_verificationsStatus),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [MaskedInputFormatter("000000")],
                          decoration: InputDecoration(
                              focusedBorder: inputBorder, border: inputBorder),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                        duration: duration,
                        curve: Curves.easeInOut,
                        height: getButtonHeight(_verificationsStatus),
                        child: TextButton(
                            onPressed: () {
                              attempVerify();
                            }, child: (_verificationsStatus == VerificationStatus.verifying)?CircularProgressIndicator(color: Colors.white,):Text('인증'))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60 + common_sm_padding;
    }
  }

  double getButtonHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48;
    }
  }
  void attempVerify() async{
    setState(() {
      _verificationsStatus= VerificationStatus.verifying;
    });

    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _verificationsStatus = VerificationStatus.verificationDone;
    });
    context.read<UserProvider>().setUserAuth(true);       // notifyListener가 들어가 있으므로 read
  }
}

enum VerificationStatus { none, codeSent, verifying, verificationDone }
