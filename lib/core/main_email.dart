import 'package:email_otp/email_otp.dart';

mixin FuncEmail {
  void onEmailInit() {
    EmailOTP.config(appName: 'Wings', otpType: OTPType.numeric, expiry: 18000, emailTheme: EmailTheme.v1, appEmail: 'valentynoelsan@gmail.com', otpLength: 6);

    EmailOTP.setTemplate(
      template: '''
      <div style="background-color: #ffffff; padding: 16px; border-radius: 8px; max-width: 300px; margin: auto; text-align: center;">
        <h1 style="color: #000000;">{{appName}}</h1>
        <p style="color: #000000;">Jika anda tidak meminta kode OTP jangan bagikan ke pada siapapun</p>
        <div style="display: inline-block; background-color: #e0e0e0; padding: 8px 16px; font-size: 20px; font-weight: bold; border-radius: 5px; color: #000000; margin: 16px 0;">
          {{otp}}
        </div>
        <p style="color: #000000;">Kode OTP ini hanya berlaku 3 menit</p>
      </div>
    ''',
    );
  }

  Future<bool> sendOTP(String email) async {
    return await EmailOTP.sendOTP(email: email);
  }

  bool verifyOTP(String otp) {
    return EmailOTP.verifyOTP(otp: otp);
  }
}
