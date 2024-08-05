import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class QuestRepository {
  final CollectionReference _questsCollection = FirebaseFirestore.instance.collection('quests');

  Future<List<Quest>> getQuests() async {
    try {
      QuerySnapshot querySnapshot = await _questsCollection.get();

      List<Quest> quests = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Quest.fromMap({...data, 'id': doc.id});
      }).toList();

      if (quests.isEmpty || _needsUpdate(quests)) {
        quests = await generateAndSaveNewQuests();
      }

      return quests;
    } catch (e, stackTrace) {
      print('Error fetching quests: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<Quest>> generateAndSaveNewQuests() async {
    try {
      final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
      const promptText = '''
                          Generate 5 fitness quests. Each quest MUST follow this EXACT format:
                          [Quest Number]. Title: [1-2 word title] Description: [3-5 word description] Points: [1-3]
                          
                          Example:
                          1. Title: Morning Jog Description: Run for 20 minutes Points: 2
                          
                          Rules:
                          - Title must be 1-2 words only
                          - Description must be 3-5 words only
                          - Points must be between 1-3
                          - Total points for all 5 quests must add up to exactly 10
                          - Do not include any additional text or formatting
                          
                          Generate the quests now:
                          ''';

      final prompt = [Content.text(promptText)];
      final response = await model.generateContent(prompt);

      List<Quest> newQuests = _parseGeneratedQuests(response.text ?? '');

      if (newQuests.isEmpty) {
        newQuests = _createDefaultQuests();
      }

      print("Clearing existing quests from Firestore...");
      await _questsCollection.get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      List<Quest> savedQuests = [];
      for (var quest in newQuests) {
        DocumentReference docRef = _questsCollection.doc();
        String newId = docRef.id;
        Quest updatedQuest = quest.copyWith(id: newId);
        await docRef.set(updatedQuest.toMap());
        savedQuests.add(updatedQuest);
        print("Saved quest with ID: ${updatedQuest.id}");
      }

      print("Successfully generated and saved ${savedQuests.length} new quests.");
      return savedQuests;
    } catch (e) {
      print("Error generating and saving quests: $e");
      return _createDefaultQuests();
    }
  }

  List<Quest> _parseGeneratedQuests(String generatedText) {
    List<Quest> quests = [];
    List<String> lines = generatedText.split('\n');

    print("Parsing generated quests:");
    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      print("Parsing line: $line");
      RegExp regExp = RegExp(r'(\d+)\.\s*Title:\s*(.*?)\s*Description:\s*(.*?)\s*Points:\s*(\d+)');
      Match? match = regExp.firstMatch(line);

      if (match != null) {
        Quest quest = Quest(
          id: '', // Leave ID empty, it will be assigned when saving to Firestore
          title: match.group(2) ?? '',
          description: match.group(3) ?? '',
          points: int.parse(match.group(4) ?? '0'),
          lastGenerated: DateTime.now(),
        );
        quests.add(quest);
        print("Parsed quest: ${quest.title}: ${quest.description} (${quest.points} points)");
      } else {
        print("Failed to parse line: $line");
      }
    }

    return quests;
  }

  List<Quest> _createDefaultQuests() {
    print("Creating default quests:");
    List<Quest> defaultQuests = [
      Quest(id: '', title: 'Morning Run', description: 'Run for 20 minutes', points: 2, lastGenerated: DateTime.now()),
      Quest(id: '', title: 'Push-ups', description: 'Do 20 push-ups', points: 2, lastGenerated: DateTime.now()),
      Quest(id: '', title: 'Healthy Meal', description: 'Prepare a balanced meal', points: 2, lastGenerated: DateTime.now()),
      Quest(id: '', title: 'Meditation', description: 'Meditate for 10 minutes', points: 2, lastGenerated: DateTime.now()),
      Quest(id: '', title: 'Stretching', description: 'Do a full-body stretch', points: 2, lastGenerated: DateTime.now()),
    ];
    defaultQuests.forEach((quest) => print("- ${quest.title}: ${quest.description} (${quest.points} points)"));
    return defaultQuests;
  }

  bool _needsUpdate(List<Quest> quests) {
    if (quests.isEmpty) return true;
    final now = DateTime.now();
    bool needsUpdate = quests.any((quest) =>
    quest.lastGenerated.year != now.year ||
        quest.lastGenerated.month != now.month ||
        quest.lastGenerated.day != now.day);
    print("Quests need update: $needsUpdate");
    return needsUpdate;
  }

  Future<void> updateQuestStatus(String questId, bool completed) async {
    try {
      await _questsCollection.doc(questId).update({
        'completed': completed,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('Successfully updated quest status for quest $questId to $completed');
    } catch (e) {
      print('Error updating quest status: $e');
      throw e;
    }
  }
}