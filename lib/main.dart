import 'package:flutter/material.dart';
import 'package:flutter_via_cep/cep_controller.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const appId = "<>";
  const clientKey = "<>";
  const server = 'https://parseapi.back4app.com';

  await Parse().initialize(
    appId,
    server,
    clientKey: clientKey,
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CepController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cepEC = TextEditingController();
  late final getCeps;
  @override
  void initState() {
    super.initState();
    context.read<CepController>().loadMessage();
    getCeps = context.read<CepController>().getCeps();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CepController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: controller.isLoading
            ? const BuildMessage()
            : ListView(
                children: <Widget>[
                  TextField(
                    controller: cepEC,
                    maxLength: 8,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.handleCep(cepEC.text);
                          },
                          child: const Text('Verificar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ListView.builder(
                    itemCount: controller.listModel.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = controller.listModel[index];

                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (dismiss) async {
                          await controller.removeCep(item.objectId, index);
                        },
                        child: Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.cep),
                                    Text(item.bairro),
                                    Text(item.localidade),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.ddd),
                                    Text(item.gia),
                                    Text(item.ibge),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.logradouro),
                                    Text(item.siafi),
                                    Text(item.uf),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class BuildMessage extends StatelessWidget {
  const BuildMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CepController>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(controller.randomMessage),
        ],
      ),
    );
  }
}
