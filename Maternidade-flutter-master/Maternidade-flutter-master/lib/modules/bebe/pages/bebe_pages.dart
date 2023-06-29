import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maternidade/entities/bebe.dart';
import 'package:maternidade/entities/mae.dart';
import 'package:maternidade/entities/medico.dart';
import 'package:maternidade/config/api.dart';

class BebePage extends StatefulWidget {
  const BebePage({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _BebePageState();
}

String? selectedValue = 'None';
List<String?> listaMae = ['None', 'Claudete', 'Roberta', 'Valdirene', 'Sandra'];
List<String?> listaMedico = ['None', 'Paulo', 'Rodrigo', 'Miranda', 'Marcos'];

Future<List<BebeData>> _fetchBebes() async {
  const url = '$baseURL/bebes?limit=10&offset=0';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
    return jsonResponse
        .map((bebe) => BebeData.fromJson(bebe))
        .toList();
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar os bebes!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0);
    throw ('Sem bebes');
  }
}

class _BebePageState extends State<BebePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<BebeData>> futureBebes;

  @override
  void initState() {
    super.initState();
    futureBebes = _fetchBebes();
  }

  void submit(String action, BebeData bebeData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (bebeData.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.data_nascimento == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a data de nascimento!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.peso == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o peso!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.altura == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a altura!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        if (action == "adicionar") {
          _adicionarBebe(bebeData);
        } else {
          _editarBebe(bebeData);
        }
      }
    }
  }

  void _adicionarBebe(BebeData bebeData) async {
    const url = '$baseURL/bebes';
    var body = jsonEncode({
      'nome': bebeData.nome,
      'id': bebeData.id,
      'id_mae': bebeData.id_mae,
      'crm_medico': bebeData.crm_medico,
      'data_nascimento' : bebeData.data_nascimento,
      'peso': bebeData.peso,
      'altura': bebeData.altura,
    });
    try {
      final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Bebe Adicionada!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao inserir o Bebe!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _editarBebe(BebeData bebeData) async {
    var id = bebeData.id;
    var url = '$baseURL/bebes/$id';
    var body = jsonEncode({
      'nome': bebeData.nome,
      'id': bebeData.id,
      'id_mae': bebeData.id_mae,
      'crm_medico': bebeData.crm_medico,
      'data_nascimento' : bebeData.data_nascimento,
      'peso': bebeData.peso,
      'altura': bebeData.altura,
    });
    try {
      final response = await http.put(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Bebe Editada!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao editar a bebe!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _excluirBebe(int id) async {
    var url = '$baseURL/bebes/$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Bebe Excluída!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao excluir o bebe!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _adicionarOuEditarBebe(BebeData bebeData) async {
    String action = 'adicionar';
    if (bebeData.id != null) {
      action = 'editar';
    }
    var dfE = DateFormat('dd/MM/yyyy');
    var dfS = DateFormat('yyyy-MM-dd');
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24
                      ),
                      items: listaMae.map((String? string){
                        return new DropdownMenuItem<String>(
                          value: string,
                          child: Text(string!),
                        );
                      }).toList(),
                      onChanged: (String? string){
                            setState(() {
                              selectedValue = string;
                            });
                        },
                      ),
                    DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24
                      ),
                      items: listaMedico.map((String? string){
                        return new DropdownMenuItem<String>(
                          value: string,
                          child: Text(string!),
                        );
                      }).toList(),
                      onChanged: (String? string){
                        setState(() {
                          selectedValue = string;
                        });
                      },
                    ),

                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Nome', labelText: 'Nome'),
                        initialValue: bebeData.nome,
                        onSaved: (String? value) {
                          bebeData.nome = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Data de Nascimento', labelText: 'Data de Nascimento'),
                        initialValue: bebeData.data_nascimento,
                        onSaved: (String? value) {
                          bebeData.data_nascimento = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Peso', labelText: 'Peso'),
                        initialValue: bebeData.peso != null ? bebeData.peso.toString() : "",
                        onSaved: (String? value) {
                          bebeData.peso = value != "" ? int.parse(value!) : null;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Altura', labelText: 'Altura'),
                        initialValue: bebeData.altura != null ? bebeData.altura.toString() : "",
                        onSaved: (String? value) {
                          bebeData.altura = value != "" ? int.parse(value!) : null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text(action == 'adicionar' ? 'Adicionar' : 'Editar'),
                      onPressed: () {
                        submit(action, bebeData);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Bebes'),
      ),
      body: Center(
        child: FutureBuilder<List<BebeData>>(
          future: futureBebes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BebeData> _bebe = snapshot.data!;
              return ListView.builder(
                  itemCount: _bebe.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(_bebe[index].nome!),
                        subtitle: Text(_bebe[index].id_mae.toString()!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _adicionarOuEditarBebe(_bebe[index])
                                          .whenComplete(() {
                                        setState(() {
                                          futureBebes = _fetchBebes();
                                        });
                                      })),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você deseja excluir o bebe "' +
                                            _bebe[index].nome! +
                                            '"?'),
                                    textOK: const Text('Sim'),
                                    textCancel: const Text('Não'),
                                  )) {
                                    _excluirBebe(_bebe[index].id!)
                                        .whenComplete(() {
                                      setState(() {
                                        futureBebes = _fetchBebes();
                                      });
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Text("Sem bebes");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _adicionarOuEditarBebe(BebeData()).whenComplete(() {
              setState(() {
                futureBebes = _fetchBebes();
              });
            }),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}