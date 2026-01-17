import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EncryptedPasswordStorage _storage = EncryptedPasswordStorage();
  List<PasswordEntry> _passwords = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    try {
      await _storage.initialize();
      await _loadPasswords();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing storage: $e')),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPasswords() async {
    final passwords = await _storage.loadPasswords();
    setState(() {
      _passwords = passwords;
    });
  }

  Future<void> _addPassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordEditPage(),
      ),
    );

    if (result != null && result is PasswordEntry) {
      setState(() {
        _passwords.add(result);
      });
      await _storage.savePasswords(_passwords);
    }
  }

  Future<void> _editPassword(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordEditPage(entry: _passwords[index]),
      ),
    );

    if (result != null && result is PasswordEntry) {
      setState(() {
        _passwords[index] = result;
      });
      await _storage.savePasswords(_passwords);
    }
  }

  Future<void> _deletePassword(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Password'),
        content: const Text('Are you sure you want to delete this password?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _passwords.removeAt(index);
      });
      await _storage.savePasswords(_passwords);
    }
  }

  List<PasswordEntry> get _filteredPasswords {
    if (_searchQuery.isEmpty) {
      return _passwords;
    }
    return _passwords.where((entry) {
      return entry.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.username.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Password Saver'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _filteredPasswords.isEmpty
                      ? const Center(
                          child: Text('No passwords saved yet'),
                        )
                      : ListView.builder(
                          itemCount: _filteredPasswords.length,
                          itemBuilder: (context, index) {
                            final entry = _filteredPasswords[index];
                            final originalIndex = _passwords.indexOf(entry);
                            return PasswordListItem(
                              entry: entry,
                              onTap: () => _editPassword(originalIndex),
                              onDelete: () => _deletePassword(originalIndex),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPassword,
        tooltip: 'Add Password',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PasswordListItem extends StatelessWidget {
  final PasswordEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PasswordListItem({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(entry.title.isNotEmpty
              ? entry.title[0].toUpperCase()
              : '?'),
        ),
        title: Text(entry.title),
        subtitle: Text(entry.username),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}

class PasswordEditPage extends StatefulWidget {
  final PasswordEntry? entry;

  const PasswordEditPage({super.key, this.entry});

  @override
  State<PasswordEditPage> createState() => _PasswordEditPageState();
}

class _PasswordEditPageState extends State<PasswordEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _usernameController = TextEditingController(text: widget.entry?.username ?? '');
    _passwordController = TextEditingController(text: widget.entry?.password ?? '');
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final entry = PasswordEntry(
        id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: widget.entry?.createdAt ?? now,
        updatedAt: now,
      );
      Navigator.pop(context, entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.entry == null ? 'Add Password' : 'Edit Password'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePassword,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username/Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username or email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _passwordController.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
