
class SignUpWithEmailAndPasswordFailure{
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message="An uknown error"]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case "weak-password":
        return const SignUpWithEmailAndPasswordFailure("Please Enter a Stronger password");

      case "invalid-email":
        return const SignUpWithEmailAndPasswordFailure("Email is not valid");

      case "invalid-password":
        return const SignUpWithEmailAndPasswordFailure("Password is incorrect");

      case "email-already-in-use":
        return const SignUpWithEmailAndPasswordFailure("Account already exists ,use different email");

      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}