import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: 'Cálculo da Idade', home: FirstRoute()));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular Idade'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Digite sua data de nascimento (dd/MM/yyyy)',
                hintText: 'Ex: 01/01/2000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final String dateStr = dateController.text;
                if (dateStr.isNotEmpty) {
                  final DateTime? birthDate = _parseDate(dateStr);
                  if (birthDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondRoute(birthDate: birthDate),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Formato de data inválido! Use dd/MM/yyyy.')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Calcular Idade', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

class SecondRoute extends StatelessWidget {
  final DateTime birthDate;

  const SecondRoute({super.key, required this.birthDate});

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(birthDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cake, size: 80, color: Colors.teal),
            const SizedBox(height: 30),
            Text(
              'Sua idade é:',
              style: TextStyle(fontSize: 24, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            Text(
              '$age anos',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Voltar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}