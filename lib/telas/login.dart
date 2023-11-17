//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:ponto_movel/telas/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> fazerLogin() async {
    //TODO: Implementar método de login

    final AuthResponse resposta = await Supabase.instance.client.auth.signInWithPassword(
      email: _emailController.text,
      password: _senhaController.text
    );

    final userId = resposta.user?.id;

    debugPrint('\n\nUSER ID: $userId\n\n');


    //const userId = true;
    if(userId != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }


    debugPrint('Login: ${_emailController.text}');
    debugPrint('Senha: ${_senhaController.text}');

    ;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FooBarBaz',
        home: Scaffold(
          body: Form(
              key: _loginKey,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 195, 195, 195)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: const Color.fromARGB(255, 245, 245, 245)),
                  //margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                  width: 350,
                  height: 400,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.watch_later_rounded,
                                      size: 40, color: Color.fromRGBO(3, 80, 166, 1)),
                                  Text(' Ponto Móvel',
                                      style: TextStyle(
                                          fontSize: 40, color: Color.fromRGBO(3, 80, 166, 1)))
                                ])),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                                controller: _emailController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    label: Text('E-mail'),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)))),
                                validator: (value) {
                                  //TODO: Validar e-mail
                                })),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                                controller: _senhaController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    label: Text('Senha'),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)))),
                                obscureText: true,
                                validator: (value) {
                                  //TODO: validar se senha é nula
                                })),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ElevatedButton(
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Entrar',
                                              style: TextStyle(fontSize: 23)),
                                          Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Icon(
                                                Icons.login_rounded,
                                                size: 23,
                                              ))
                                        ])),
                                onPressed: () {
                                  fazerLogin();
                                }))
                      ]),
                ),
              )),
        ));
  }
}
