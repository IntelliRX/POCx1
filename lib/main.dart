import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _login() {
    // For demo, just navigate to landing page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // Successfully signed in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Image.asset(
                'assets/google_logo.png', // Add a Google logo asset or use an Icon
                height: 24,
                width: 24,
              ),
              label: const Text('Sign in with Google'),
              onPressed: _loginWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Landing Page')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('About Us'),
                    content: const Text('This is the About Us page.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Help'),
                    content: const Text('This is the Help page.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('New Form'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewFormPage()),
                );
              },
            ),
            ListTile(
  leading: const Icon(Icons.list),
  title: const Text('Show Entries'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntriesListPage()),
    );
  },
),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Landing Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class NewFormPage extends StatefulWidget {
  @override
  State<NewFormPage> createState() => _NewFormPageState();
}

class _NewFormPageState extends State<NewFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _patientProblemController = TextEditingController();
  final TextEditingController _doctorAnalysisController = TextEditingController();
  final TextEditingController _medicineSuggestedController = TextEditingController();

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final formData = {
      'name': _nameController.text,
      'age': _ageController.text,
      'comments': _commentsController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'patient_problem': _patientProblemController.text,
      'doctor_analysis': _doctorAnalysisController.text,
      'medicine_suggested': _medicineSuggestedController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final appSupportDir = await getApplicationSupportDirectory();
    final directory = Directory('${appSupportDir.path}/MedicalForms');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final file = File('${directory.path}/forms.json');

    List<dynamic> entries = [];
    if (file.existsSync()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        entries = jsonDecode(content);
      }
    }
    entries.add(formData);
    await file.writeAsString(jsonEncode(entries));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Submitted'),
        content: const Text('Form data saved!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your age' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentsController,
                decoration: const InputDecoration(labelText: 'Comments'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your phone number';
                }
                // Simple phone validation: 10 digits
                final phoneRegExp = RegExp(r'^\d{10}$');
                if (!phoneRegExp.hasMatch(value)) {
                  return 'Enter a valid 10-digit phone number';
                }
                return null;
              },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email ID'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  // Simple email validation
                  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _patientProblemController,
                decoration: const InputDecoration(labelText: 'Patient Problem'),
                maxLines: 2,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter patient problem' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorAnalysisController,
                decoration: const InputDecoration(labelText: 'Doctor Analysis'),
                maxLines: 2,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter doctor analysis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicineSuggestedController,
                decoration: const InputDecoration(labelText: 'Medicine Suggested'),
                maxLines: 2,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter medicine suggested' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EntriesListPage extends StatefulWidget {
  @override
  State<EntriesListPage> createState() => _EntriesListPageState();
}

class _EntriesListPageState extends State<EntriesListPage> {
  List<dynamic> entries = [];
  List<dynamic> filteredEntries = [];
  final TextEditingController _searchController = TextEditingController();
  String filePath = '';

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _searchController.addListener(_filterEntries);
  }

  Future<void> _loadEntries() async {
    final appSupportDir = await getApplicationSupportDirectory();
    final file = File('${appSupportDir.path}/MedicalForms/forms.json');
    filePath = file.path;
    if (file.existsSync()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        setState(() {
          entries = jsonDecode(content);
          filteredEntries = entries;
        });
      }
    } else {
      setState(() {
        entries = [];
        filteredEntries = [];
      });
    }
    setState(() {}); // Update filePath in UI
  }

  void _filterEntries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredEntries = entries.where((entry) {
        return (entry['name'] ?? '').toLowerCase().contains(query) ||
               (entry['age'] ?? '').toString().toLowerCase().contains(query) ||
               (entry['phone'] ?? '').toLowerCase().contains(query) ||
               (entry['email'] ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _deleteFile() async {
    final file = File(filePath);
    if (file.existsSync()) {
      await file.delete();
      setState(() {
        entries = [];
        filteredEntries = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File deleted!')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Entries')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'File: $filePath',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete file',
                  onPressed: _deleteFile,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name, age, phone, or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredEntries.isEmpty
                ? const Center(child: Text('No entries found.'))
                : ListView.builder(
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(entry['name'] ?? 'No Name'),
                          subtitle: Text('Age: ${entry['age'] ?? ''}\n'
                              'Phone: ${entry['phone'] ?? ''}\n'
                              'Email: ${entry['email'] ?? ''}\n'
                              'Problem: ${entry['patient_problem'] ?? ''}\n'
                              'Doctor: ${entry['doctor_analysis'] ?? ''}\n'
                              'Medicine: ${entry['medicine_suggested'] ?? ''}\n'
                              'Timestamp: ${entry['timestamp'] ?? ''}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}