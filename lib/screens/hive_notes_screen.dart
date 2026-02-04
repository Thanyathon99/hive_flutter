import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hive_note_provider.dart';
import '../models/hive_note.dart';

class HiveNotesScreen extends StatelessWidget {
  const HiveNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Hive Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement Search Delegate
            },
          ),
        ],
      ),
      body: Consumer<HiveNotesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.notes.isEmpty) {
            return const Center(
              child: Text('ยังไม่มีโน้ตในตอนนี้.. ลองเพิ่มดูสิ!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.notes.length,
            itemBuilder: (context, index) {
              final note = provider.notes[index];
              final category = provider.getCategoryById(note.categoryId);

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: category?.colorValue?.withAlpha((0.2 * 255).round()),
                    child: Icon(
                      category?.iconData,
                      color: category?.colorValue,
                    ),
                  ),
                  title: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: note.isPinned ? Colors.orange : null,
                    ),
                    onPressed: () => provider.togglePin(note.id),
                  ),
                  onTap: () {
                    // TODO: Navigate to Edit Screen
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final newNote = HiveNote(
            id: '', 
            title: 'โน้ตใหม่ ${DateTime.now().second}',
            content: 'รายละเอียดเนื้อหาโน้ต...',
          );
          context.read<HiveNotesProvider>().addNote(newNote);
        },
        label: const Text('New Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
