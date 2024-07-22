class CreateUserReq {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  CreateUserReq({
    required this.firstName, 
    required this.lastName, 
    required this.email, 
    required this.password
  });
}