class AuthResponse {
  final bool isAuthenticated;
  final String? token;
  final String? expiresOn;
  final String? userId;
  final String? fullName;
  final String message;

  AuthResponse({
    required this.isAuthenticated,
    this.token,
    this.expiresOn,
    this.userId,
    this.fullName,
    required this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      isAuthenticated: json['isAuthenticated'] ?? false,
      token: json['token'],
      expiresOn: json['expiresOn'],
      userId: json['userId'],
      fullName: json['fullName'],
      message: json['message'] ?? '',
    );
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class RegisterRequest {
  final String email;
  final String password;
  final String fullName;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'fullName': fullName,
  };
}
