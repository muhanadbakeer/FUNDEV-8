import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/cooking_skill_api.dart';

class CookingSkillPage extends StatefulWidget {
  const CookingSkillPage({super.key});

  @override
  State<CookingSkillPage> createState() => _CookingSkillPageState();
}

class _CookingSkillPageState extends State<CookingSkillPage> {
  bool loading = true;
  String selected = "Beginner";

  final String userId = "1"; 
  final List<String> options = ["Beginner", "Intermediate", "Advanced"];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      selected = await CookingSkillApi.getSkill(userId);
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await CookingSkillApi.saveSkill(userId, selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.cookingSkill".tr()),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ?  Center(child: CircularProgressIndicator())
          : Column(
        children: [
          ...options.map((x) => RadioListTile<String>(
            value: x,
            groupValue: selected,
            onChanged: (v) => setState(() => selected = v ?? selected),
            title: Text(x),
          )),
           Spacer(),
          Padding(
            padding:  EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                onPressed: _save,
                child: Text(
                  "common.save".tr(),
                  style:  TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
