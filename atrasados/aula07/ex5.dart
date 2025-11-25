import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      title: 'Gerenciador de Aluno', home: StudentInfoScreen()));
}

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final _nameController = TextEditingController();
  final _matController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _matController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aluno - Dados Pessoais'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Aluno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _matController,
              decoration: InputDecoration(
                labelText: 'Matrícula',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final mat = _matController.text.trim();

                if (name.isEmpty || mat.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha nome e matrícula')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GradesEntryScreen(
                      name: name,
                      matricula: mat,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Próximo: Inserir Notas', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class GradesEntryScreen extends StatefulWidget {
  final String name;
  final String matricula;

  const GradesEntryScreen(
      {super.key, required this.name, required this.matricula});

  @override
  State<GradesEntryScreen> createState() => _GradesEntryScreenState();
}

class _GradesEntryScreenState extends State<GradesEntryScreen> {
  final _gradeController = TextEditingController();
  final List<double> _grades = [];

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  void _addGrade() {
    final text = _gradeController.text.trim();
    final grade = double.tryParse(text);

    if (grade == null || grade < 0 || grade > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite uma nota válida entre 0 e 10')),
      );
      return;
    }

    setState(() {
      _grades.add(grade);
      _gradeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Notas'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Aluno: ${widget.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Matrícula: ${widget.matricula}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gradeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Nota (0 a 10)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addGrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: _grades.isEmpty
                    ? const Center(child: Text('Nenhuma nota adicionada ainda'))
                    : ListView.builder(
                        itemCount: _grades.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal.shade100,
                              child: Text('${index + 1}', style: TextStyle(color: Colors.teal.shade800)),
                            ),
                            title: Text(
                                'Nota: ${_grades[index].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                            trailing: const Icon(Icons.check_circle_outline, color: Colors.green),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _grades.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentSummaryScreen(
                            name: widget.name,
                            matricula: widget.matricula,
                            grades: _grades,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _grades.isEmpty ? Colors.grey : Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Próximo: Ver Resumo', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentSummaryScreen extends StatelessWidget {
  final String name;
  final String matricula;
  final List<double> grades;

  const StudentSummaryScreen({
    super.key,
    required this.name,
    required this.matricula,
    required this.grades,
  });

  double _calculateAverage() {
    if (grades.isEmpty) return 0.0;
    final total = grades.reduce((a, b) => a + b);
    return total / grades.length;
  }

  @override
  Widget build(BuildContext context) {
    final average = _calculateAverage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do Aluno'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome: $name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Matrícula: $matricula', style: TextStyle(fontSize: 20, color: Colors.teal.shade600)),
                    const Divider(height: 30),
                    Text('Média Final:', style: TextStyle(fontSize: 20, color: Colors.grey.shade700)),
                    const SizedBox(height: 5),
                    Text(
                      average.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Notas Detalhadas:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: grades.isEmpty
                  ? const Text('Nenhuma nota disponível')
                  : ListView.builder(
                      itemCount: grades.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text('${index + 1}º', style: const TextStyle(fontWeight: FontWeight.bold)),
                          title:
                              Text('Nota: ${grades[index].toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}