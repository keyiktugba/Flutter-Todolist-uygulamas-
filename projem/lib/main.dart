import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const ProjemApp());
}

class ProjemApp extends StatelessWidget {
  const ProjemApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajanda Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange,
        ),
        textTheme: const TextTheme(
          //bodyText2: TextStyle(color: Colors.purple), // Buradaki renk sadece bir örnektir, ihtiyacınıza göre değiştirin
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajanda Uygulaması'),
      ),
      body: ListView(
        children: [
          _buildDashboardTile(context, 'Todo Listesi', Icons.check, TodoListScreen()),
          _buildDashboardTile(context, 'Takvim Planlayıcı', Icons.calendar_today, CalendarPlannerScreen()),
          _buildDashboardTile(context, 'Alışveriş Listesi', Icons.shopping_cart, ShoppingListScreen()),
          _buildDashboardTile(context, 'İzlenecek Filmler', Icons.movie, MoviesToWatchScreen()),
          _buildDashboardTile(context, 'Dinlenecek Müzikler', Icons.music_note, MusicToListenScreen()),
          _buildDashboardTile(context, 'Okunacak Kitaplar', Icons.book, BooksToReadScreen()),
          _buildDashboardTile(context, 'Motivasyon Notları', Icons.note, MotivationNotesScreen()),
        ],
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context, String title, IconData icon, Widget screen) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        title: Text(title, style: TextStyle(color: Theme.of(context).primaryColor)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> todos = ['Örnek Todo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Listesi'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(todos[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    todos.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Yeni Todo Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodo() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Todo Ekle'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Todo adını girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textFieldController.text.isNotEmpty) {
                    todos.add(_textFieldController.text);
                  }
                });
                _textFieldController.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class CalendarPlannerScreen extends StatefulWidget {
  @override
  _CalendarPlannerScreenState createState() => _CalendarPlannerScreenState();
}

class _CalendarPlannerScreenState extends State<CalendarPlannerScreen> {
  Map<DateTime, List<String>> events = {};
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takvim Planlayıcı'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return events[day] ?? [];
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 8.0),
          ..._getEventsForDay(selectedDay).map((event) => ListTile(
            title: Text(event),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Yeni Etkinlik Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _addEvent() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Etkinlik Ekle'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Etkinlik adını girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textFieldController.text.isNotEmpty) {
                    if (events[selectedDay] != null) {
                      events[selectedDay]!.add(_textFieldController.text);
                    } else {
                      events[selectedDay] = [_textFieldController.text];
                    }
                  }
                });
                _textFieldController.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<String> shoppingList = ['Örnek Alışveriş'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışveriş Listesi'),
      ),
      body: ListView.builder(
        itemCount: shoppingList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(shoppingList[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    shoppingList.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Yeni Öğe Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItem() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Alışveriş Ögesi Ekle'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Alışveriş ögesini girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textFieldController.text.isNotEmpty) {
                    shoppingList.add(_textFieldController.text);
                  }
                });
                _textFieldController.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class MoviesToWatchScreen extends StatefulWidget {
  @override
  _MoviesToWatchScreenState createState() => _MoviesToWatchScreenState();
}

class _MoviesToWatchScreenState extends State<MoviesToWatchScreen> {
  final List<String> movies = ['Örnek Film'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İzlenecek Filmler'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(movies[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    movies.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMovie,
        tooltip: 'Yeni Film Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addMovie() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Film Ekle'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Film adını girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textFieldController.text.isNotEmpty) {
                    movies.add(_textFieldController.text);
                  }
                });
                _textFieldController.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class MusicToListenScreen extends StatefulWidget {
  @override
  _MusicToListenScreenState createState() => _MusicToListenScreenState();
}

class _MusicToListenScreenState extends State<MusicToListenScreen> {
  final List<String> musicList = ['Örnek Şarkı'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinlenecek Müzikler'),
      ),
      body: ListView.builder(
        itemCount: musicList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(musicList[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    musicList.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMusic,
        tooltip: 'Yeni Müzik Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addMusic() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Müzik Ekle'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Müzik adını girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textFieldController.text.isNotEmpty) {
                    musicList.add(_textFieldController.text);
                  }
                });
                _textFieldController.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class BooksToReadScreen extends StatefulWidget {
  @override
  _BooksToReadScreenState createState() => _BooksToReadScreenState();
}

class _BooksToReadScreenState extends State<BooksToReadScreen> {
  final List<String> books = ['Örnek Kitap'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Okunacak Kitaplar'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(books[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    books.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Yeni Kitap Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addBook() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Kitap Ekle'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Kitap adını girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textFieldController.text.isNotEmpty) {
                    books.add(_textFieldController.text);
                  }
                });
                _textFieldController.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class MotivationNotesScreen extends StatefulWidget {
  @override
  _MotivationNotesScreenState createState() => _MotivationNotesScreenState();
}

class _MotivationNotesScreenState extends State<MotivationNotesScreen> {
  final List<String> notes = ['Örnek Not'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivasyon Notları'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(notes[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    notes.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Yeni Not Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNote() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Not Ekle'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Notunuzu girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textFieldController.text.isNotEmpty) {
                    notes.add(_textFieldController.text);
                  }
                });
                _textFieldController.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}
