import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/uid.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('ja_JP');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(create: (context) => UidModel(), child: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAuth.instance.userChanges().listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<UidModel, AccountModel>(
          create: (context) => AccountModel(create: (uidModel) {
            return DatabaseService.getAccount(uidModel.uid);
          }),
          update: (context, uidModel, accountModel) {
            accountModel.update(uidModel);
            return accountModel;
          },
        ),
      ],
      child: Test(),
    );
  }
}

class Test extends StatelessWidget {
  void navigate(BuildContext context, bool hasUser) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) {
        if (hasUser) {
          return Root();
        } else {
          return Authenticate();
        }
      }),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountModel>(context);
    accountModel.addListener(() {
      navigate(context, accountModel.value != null);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        colorScheme: ColorScheme.light(
          primary: Colors.deepOrange,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: Colors.blue,
        cardTheme: CardTheme(
          elevation: 2.0,
        ),
      ),
      home: LoadingScaffold(),
    );
  }
}
