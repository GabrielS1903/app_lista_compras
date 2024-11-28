import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../cores/cores.dart'; // Paleta de cores existente

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      showFriendlyMessage(
        "Por favor, preencha todos os campos para entrar.",
        MyColors.yellow.shade700,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      showFriendlyMessage(
        "Login realizado com sucesso! Bem-vindo!",
        MyColors.green,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      handleAuthErrors(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void register() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      showFriendlyMessage(
        "Por favor, preencha todos os campos para se registrar.",
        MyColors.yellow.shade700,
      );
      return;
    }

    if (passwordController.text.trim().length < 6) {
      showFriendlyMessage(
        "A senha deve ter pelo menos 6 caracteres.",
        MyColors.yellow.shade700,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      showFriendlyMessage(
        "Conta criada com sucesso! Faça login para continuar.",
        MyColors.green,
      );
    } catch (e) {
      handleAuthErrors(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleAuthErrors(dynamic error) {
    String message;
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          message = "O email fornecido é inválido. Por favor, verifique.";
          break;
        case 'user-not-found':
          message = "Usuário não encontrado. Verifique o email digitado.";
          break;
        case 'email-already-in-use':
          message = "Este email já está em uso. Tente outro.";
          break;
        default:
          message = "Login inválido. Tente novamente.";
      }
    } else {
      message = "Erro desconhecido: $error";
    }

    showFriendlyMessage(message, MyColors.yellow.shade700);
  }

  void showFriendlyMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: MyColors.primary,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ícone e título
              Icon(
                Icons.shopping_cart,
                color: MyColors.primary,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                "Bem-vindo ao Lista de Compras",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary.shade700,
                ),
              ),
              const SizedBox(height: 32),

              // Campo de e-mail
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: "Email",
                  labelStyle: TextStyle(color: MyColors.primary),
                  filled: true,
                  fillColor: MyColors.gray.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.primary),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de senha
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Senha",
                  labelStyle: TextStyle(color: MyColors.primary),
                  filled: true,
                  fillColor: MyColors.gray.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.primary),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botões de ação
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text(
                        "Registrar",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
