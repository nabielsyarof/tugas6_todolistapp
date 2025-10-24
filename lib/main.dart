import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List Activity App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7E57C2),
        scaffoldBackgroundColor: const Color(0xFFF8F7FA),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ✅ Sekarang kita simpan kegiatan sebagai map {text, done}
  final List<Map<String, dynamic>> _activities = [];
  final TextEditingController _controller = TextEditingController();

  // Simpan teks yang sedang diketik (onChanged)
  String _typedText = '';

  // Fungsi menambahkan kegiatan
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Tambah Kegiatan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Contoh: Belajar Flutter",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.task_alt),
          ),
          // ✅ Event onChanged
          onChanged: (value) {
            setState(() {
              _typedText = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clear();
              _typedText = '';
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_typedText.isNotEmpty) {
                setState(() {
                  _activities.add({'text': _typedText, 'done': false});
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"$_typedText" ditambahkan! ✅'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.deepPurple,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _controller.clear();
                _typedText = '';
                Navigator.pop(context);
              }
            },
            label: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // Fungsi menghapus kegiatan
  void _deleteActivity(int index) {
    String deleted = _activities[index]['text'];
    setState(() {
      _activities.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$deleted" telah dihapus 🗑️'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ✅ Fungsi menandai tugas selesai (onTap)
  void _toggleDone(int index) {
    setState(() {
      _activities[index]['done'] = !_activities[index]['done'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar
      appBar: AppBar(
        toolbarHeight: 75,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "📝 To-Do Activity App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: _activities.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "✨ Belum ada kegiatan hari ini ✨",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Tekan tombol + untuk menambah kegiatan",
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 16),
                    Text("🗓️", style: TextStyle(fontSize: 40)),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.deepPurple.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GestureDetector(
                        // ✅ Event onTap untuk menandai selesai
                        onTap: () => _toggleDone(index),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: activity['done']
                                ? Colors.greenAccent
                                : Colors.deepPurple.shade100,
                            child: Icon(
                              activity['done']
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: activity['done']
                                  ? Colors.green
                                  : Colors.purple,
                            ),
                          ),
                          title: Text(
                            activity['text'],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              decoration: activity['done']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: activity['done']
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_forever,
                                color: Colors.redAccent),
                            onPressed: () => _deleteActivity(index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),

      // Floating Button Tambah
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7E57C2),
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add_task, color: Colors.white),
        label: const Text(
          "Tambah",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
