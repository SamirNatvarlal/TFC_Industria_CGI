import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Biblioteca HTTP para chamadas à API
import 'package:mysql_client/mysql_client.dart';
//import 'package:mysql1/mysql1.dart';
import 'package:tfc_industria/databaseconnector.dart';
import 'package:tfc_industria/navigationBarPages/main_page.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _formKey = GlobalKey<FormState>(); // Chave para identificar o formulário
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  /*
  // Função para fazer login via API
  Future<void> _login() async {
    try {
      final conn = await DatabaseConnector().connect();

      // Query para verificar o login
      final results = await conn.query(
        'SELECT * FROM Utilizadores WHERE username = ? AND password = ?',
        [_userController.text, _passwordController.text],
      );

      if (results.isNotEmpty) {
        final user = results.first.fields;
        print('Login bem-sucedido para: ${user['username']}');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPages()),
        );
      } else {
        print('Credenciais inválidas');
        _showError('Credenciais inválidas.');
      }

      await conn.close();
    } on MySqlException catch (e) {
      print('Erro específico de MySQL: $e');
      _showError('Erro no banco de dados. Verifique as configurações.');
    } catch (e) {
      print('Erro geral ao conectar: $e');
      _showError('Erro de conexão. Verifique sua rede ou servidor.');
    }
  }
   */
  Future<void> _login() async {
    try {
      /*
      final db = DatabaseConnector();

      await db.connect();
      print("first");

      final conn = db.connection;
      print("second");

       */



      final conn = await MySQLConnection.createConnection(
        host: "10.0.2.2",
        port: 3306,
        userName: "root",
        password: "my-secret",
        databaseName: "Teste", // optional
      );

      await conn.connect();
      /*
      final result = await conn.execute(
        "SELECT * FROM Utilizadores WHERE username = :username AND password = :password",
        {
          "username": _userController.text.toString(),
          "password": _passwordController.text.toString(),
        },
      );
       */
      final result = await conn.execute(
          "SELECT * FROM Utilizadores WHERE username = '${_userController.text}' AND password = '${_passwordController.text}'"
      );
      print("third");

      if (result.rows.isNotEmpty) {
        print("Login bem-sucedido!");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPages()),
        );
      } else {
        print("Credenciais inválidas.");
      }

      //await db.close();
      await conn.close();
    } catch (e) {
      _showError('Erro no banco de dados. Verifique as configurações.');
      print("Erro ao conectar à base de dados: $e");
    }
  }


  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 60),
                  Image.asset('images/img.png'),
                  const Text(
                    'IOT - IndusTria',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bem-Vindo!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A2119),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Por favor, faça login da conta',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: 'Nº do utilizador',
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o Nº do utilizador';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Palavra-Passe',
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a Palavra-Passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A2119), // Cor de fundo
                      minimumSize: const Size.fromHeight(50), // Tamanho do botão
                    ),
                    onPressed: () {
                      print("Botão precionado");
                      if (_formKey.currentState!.validate()) {
                        _login(); // Chama a função para login
                      } else{
                        print("Validação falhou");
                      }
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueceste a Palavra-Passe?\nEntre em contacto com a empresa',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
