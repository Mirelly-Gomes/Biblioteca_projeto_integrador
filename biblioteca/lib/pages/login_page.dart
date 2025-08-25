import 'package:biblioteca/pages/home_page.dart';
import 'package:flutter/material.dart';

// Página de Login
class LoginPage extends StatefulWidget {
  static const String route = "/login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores dos campos de texto
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Estado de carregamento
  bool isLoading = false;

  // Função de login
  Future<void> login() async {
    setState(() => isLoading = true);

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, HomePage.route); // redireciona
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo com imagem
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fundo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          // Card de login centralizado
          child: Container(
            height: 500,
            width: 900,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                // Coluna esquerda: formulário
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Gerenciador de Livros",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(26, 0, 217, 1),
                          ),
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Campo Email
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          cursorColor: const Color(0xFF1A00D9),
                        ),
                        const SizedBox(height: 20),
                        // Campo Senha
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: "Senha",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          cursorColor: const Color(0xFF1A00D9),
                        ),
                        const SizedBox(height: 40),
                        // Botão de login
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A00D9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Entrar",
                                    style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Coluna direita: imagem decorativa
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/azul-escuro.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
