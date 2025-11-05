import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Database database;
  List<Map> tarefas = [];
  TextEditingController taskController = TextEditingController();
  DateTime? selectedDate;
  String filterOption = "Todas";

  @override
  void initState() {
    super.initState();
    _iniciaDB();
  }

  Future<void> _iniciaDB() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'tarefas.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE tarefas(
            id INTEGER PRIMARY KEY, 
            descricao TEXT, 
            feito INTEGER,
            data TEXT
          )''');
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tarefas ADD COLUMN data TEXT');
        }
      },
    );
    _atualizaTarefas();
  }

  void _adicionaTarefa(String descricao) async {
    if (selectedDate == null) {
      selectedDate = DateTime.now();
    }

    final db = await database;
    await db.insert('tarefas', {
      'descricao': descricao,
      'feito': 0,
      'data': selectedDate!.toIso8601String(),
    });
    taskController.clear();
    setState(() {
      selectedDate = null;
    });
    _atualizaTarefas();
  }

  void _marcaComoFeita(int id) async {
    final db = await database;
    await db.update('tarefas', {'feito': 1}, where: 'id = ?', whereArgs: [id]);
    _atualizaTarefas();
  }

  void _atualizaTarefas() async {
    final db = await database;
    List<Map> lista;

    if (filterOption == "Filtrar por Data" && selectedDate != null) {
      String dateStr = selectedDate!.toIso8601String().split('T')[0];
      lista = await db.query(
        'tarefas',
        where: 'data LIKE ?',
        whereArgs: ['$dateStr%'],
      );
    } else {
      lista = await db.query('tarefas');
    }

    setState(() {
      tarefas = lista;
    });
  }

  void _excluirTarefa(int id) async {
    final db = await database;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
    _atualizaTarefas();
  }

  void _mostrarModalDeTarefa(BuildContext context) {
    final TextEditingController novaTarefaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nova Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: novaTarefaController,
                decoration: const InputDecoration(
                  labelText: 'Descrição da Tarefa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (filterOption == "Filtrar por Data")
                ListTile(
                  title: Text(
                    selectedDate == null
                        ? 'Selecione a Data'
                        : 'Data: ${selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final descricao = novaTarefaController.text.trim();
                if (descricao.isNotEmpty) {
                  _adicionaTarefa(descricao);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Filtrar por data:'),
                DropdownButton<String>(
                  value: filterOption,
                  items: const [
                    DropdownMenuItem(value: "Todas", child: Text("Todas")),
                    DropdownMenuItem(
                      value: "Filtrar por Data",
                      child: Text("Filtrar por Data"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filterOption = value!;
                    });
                    _atualizaTarefas();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filterOption == "Filtrar por Data")
              ListTile(
                title: Text(
                  selectedDate == null
                      ? 'Selecione a Data'
                      : 'Data: ${selectedDate!.toLocal()}'.split(' ')[0],
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                    _atualizaTarefas();
                  }
                },
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  var tarefa = tarefas[index];
                  String tarefaData = tarefa['data'] != null
                      ? DateTime.parse(
                          tarefa['data'],
                        ).toLocal().toString().split(' ')[0]
                      : 'Data não definida';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    child: ListTile(
                      title: Text(tarefa['descricao']),
                      subtitle: Text('Data: $tarefaData'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              tarefa['feito'] == 1
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: tarefa['feito'] == 1
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _marcaComoFeita(tarefa['id']);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _excluirTarefa(tarefa['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModalDeTarefa(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
