import 'package:flutter/material.dart';
import 'package:div/screens/home/api_home/info_api.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key, required this.infoKey});

  final String infoKey;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool loading = true;
  String title = "";
  String description = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await InfoApi.getInfo(widget.infoKey);
      title = data["title"] ?? "";
      description = data["description"] ?? "";
    } catch (_) {
      title = "Error";
      description = "Failed to load info";
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
