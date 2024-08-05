import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';

class QuestRepository {
  final CollectionReference _questsCollection = FirebaseFirestore.instance.collection('quests');

  Future<List<Quest>> getQuests() async {
    try {
      print("Attempting to fetch quests from Firebase...");
      QuerySnapshot querySnapshot = await _questsCollection.get();
      print("Fetched ${querySnapshot.docs.length} quests from Firebase.");

      List<Quest> quests = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Processing quest document: ${doc.id}");
        print("Quest data: $data");

        return Quest(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          points: data['points'] ?? 0,
          lastGenerated: data['lastGenerated'] != null
              ? (data['lastGenerated'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();

      print("Successfully processed ${quests.length} quests.");
      return quests;
    } catch (e, stackTrace) {
      print('Error fetching quests: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<void> updateQuestStatus(String questId, bool completed) async {
    try {
      await _questsCollection.doc(questId).update({'completed': completed});
      print('Successfully updated quest status for quest $questId');
    } catch (e) {
      print('Error updating quest status: $e');
    }
  }
}