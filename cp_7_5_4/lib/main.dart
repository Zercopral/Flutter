import 'package:cp_9_8_7_5_4/user_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'httpRequests/http_requests.dart';
import 'LocalStorage/local_storages.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const MainApp());
  // print('!');

  // APIUsedCounter apiUsedCounter = APIUsedCounter(prefs);
  // int counterValue = apiUsedCounter.getCounterValue() as int;
  // print(counterValue);
  // var res = await WeatherAPI.getTemperature();
  // print(res);
  // print('!!!');
  // apiUsedCounter.saveCounterValue(counterValue++);
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
        '/': (context) => const MainPage(),
        '/weatherAPI': (context) => const WeatherPage(),
        '/account': (context) => const AccountPage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    void goToWeatherPage() {
      Navigator.pushNamed(context, '/weatherAPI');
    }

    void goToAccountPage() {
      Navigator.pushNamed(context, '/account');
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Главная страница')),
        body: Column(
          children: [
            const SizedBox(
              height: 200,
              width: 1000,
            ),
            ElevatedButton(
                onPressed: goToWeatherPage,
                child: const Text('Узнать Температуру')),
            const SizedBox(height: 100),
            ElevatedButton(
                onPressed: goToAccountPage, child: const Text('Аккаунт'))
          ],
        ));
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  double temperature = 0.0;
  int counterValue = 0;

  void getTemperature() {
    SharedPreferences.getInstance().then((onValue) {
      APIUsedCounter apiUsedCounter = APIUsedCounter(onValue);
      var val = apiUsedCounter.getCounterValue();
      int value = (val != null) ? val : 0;

      setState(() {
        counterValue = value + 1;
      });
      apiUsedCounter.saveCounterValue(counterValue);
    });

    WeatherAPI.getTemperature().then((value) {
      setState(() {
        temperature = value;
      });
    });
  }

  @override
  void initState() {
    temperature = 0.0;
    counterValue = 0;
    getTemperature();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Погоды'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 400,
            width: 1000,
          ),
          Text('Температура в Москве $temperature градусов'),
          const SizedBox(
            height: 200,
          ),
          Text('Её узнавали $counterValue раз.'),
          const SizedBox(
            height: 100,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  getTemperature();
                });
              },
              child: const Text('Обновить данные')),
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late bool authorized = true; //User.LogedIn();

  @override
  void setState(VoidCallback fn) {
    authorized;
    super.setState(fn);
  }

  void logIn() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      TextEditingController loginController = TextEditingController();
      TextEditingController passwordController = TextEditingController();
      TextEditingController nameController = TextEditingController();
      TextEditingController ageController = TextEditingController();

      void createUser() {
        print("Создаем User");
        User.initStorage();
        User.createUser(nameController.text, ageController.text as int,
            loginController.text, passwordController.text);
        setState(() {
          authorized = true; //User.Authorized();
        });
        print("Создали User");
        Navigator.pop(context);
      }

      return Scaffold(
        appBar: AppBar(title: const Text("Создание пользователя")),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Введите логин", contentPadding: EdgeInsets.all(10)),
            controller: loginController,
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
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Введите имя", contentPadding: EdgeInsets.all(10)),
            controller: nameController,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Введите возраст",
                contentPadding: EdgeInsets.all(10)),
            controller: ageController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => createUser, child: const Text('Создать аккаунт'))
        ]),
      );
    }));
  }

  void logOut() {
    User.setUnAuthorized();
    setState(() {
      authorized = false; //User.Authorized();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Аккаунт'),
        ),
        body: !authorized
            ? Column(
                children: [
                  const SizedBox(
                    height: 100,
                    width: 1000,
                  ),
                  ElevatedButton(onPressed: logIn, child: const Text("Войти")),
                ],
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 100,
                    width: 1000,
                  ),
                  ElevatedButton(onPressed: logOut, child: const Text("Выйти")),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Имя: ${User.name}"),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Возраст: ${User.age}"),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Login: ${User.login}")
                ],
              ));
  }
}
