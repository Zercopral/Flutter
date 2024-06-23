import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reg and Auth",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const EnterPage(title: 'Enter Page'),
        '/main': (context) => const MainPage(),
        '/auth': (context) => AuthPage(),
        '/reg': (context) => RegisterPage(),
      },
    );
  }
}

class EnterPage extends StatelessWidget {
  const EnterPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    void goToAuth() async {
      Navigator.pushNamed(context, '/auth');
    }

    void goToMain() async {
      User.authorized = false;
      Navigator.pushNamed(context, '/main');
    }

    void goToReg() async {
      Navigator.pushNamed(context, '/reg');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Начальная страница'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: goToAuth, child: const Text('Авторизоваться')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: goToReg, child: const Text('Зарегистрироваться')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: goToMain,
                child: const Text('Продолжить без авторизации'))
          ],
        ),
      ),
    );
  }
}

class User {
  static bool authorized = false;
}

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void goToMain() async {
      User.authorized = true;
      Navigator.pushNamed(context, '/main');
    }

    Future<void> auth() async {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddressController.text,
          password: passwordController.text,
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Успешная авторизация"),
              ),
              body: Center(
                child: Column(
                  children: [
                    const Text('Вы авторизовались'),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: goToMain,
                        child: const Text('Перейти на главную страницу')),
                  ],
                ),
              ));
        }));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Auth"),
        ), // AppBar
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Введите почту", contentPadding: EdgeInsets.all(10)),
            controller: emailAddressController,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Введите пароль", contentPadding: EdgeInsets.all(10)),
            controller: passwordController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => auth(), child: const Text('Авторизоваться'))
        ])); // Scaffold
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController emailAddressControllerReg =
      TextEditingController();
  final TextEditingController passwordControllerReg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void goToMain() async {
      User.authorized = true;
      Navigator.pushNamed(context, '/main');
    }

    Future<void> auth() async {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddressControllerReg.text,
          password: passwordControllerReg.text,
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Успешная регистрация"),
              ),
              body: Center(
                child: Column(
                  children: [
                    const Text('Вы зарегистрировались'),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: goToMain,
                        child: const Text('Перейти на главную страницу')),
                  ],
                ),
              ));
        }));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Reg"),
        ), // AppBar
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Введите почту", contentPadding: EdgeInsets.all(10)),
            controller: emailAddressControllerReg,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Введите пароль", contentPadding: EdgeInsets.all(10)),
            controller: passwordControllerReg,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => auth(), child: const Text('Зарегистрироваться'))
        ])); // Scaffold
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late bool authorized;

  @override
  void initState() {
    authorized = User.authorized;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void logOut() {
      User.authorized = false;
      setState(() {
        authorized = User.authorized;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
                hintText: "Здесь может писать любой пользователь."),
          ),
          const SizedBox(
            height: 50,
            width: 1000,
          ),
          TextField(
            enabled: !authorized,
            decoration: const InputDecoration(
                hintText:
                    "Здесь может писать только неавторизованный пользователь."),
          ),
          const SizedBox(
            height: 50,
            width: 1000,
          ),
          TextField(
            enabled: authorized,
            decoration: const InputDecoration(
                hintText:
                    "Здесь может писать только авторизованный пользователь."),
          ),
          const SizedBox(
            height: 300,
            width: 1000,
          ),
          authorized
              ? ElevatedButton(
                  onPressed: logOut, child: const Text('Разлогиниться'))
              : const SizedBox(
                  height: 5,
                ),
        ],
      ),
    );
  }
}
