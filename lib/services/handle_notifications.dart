import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/views/add_edit_todo_view.dart';

class HandleNotifications {
  final BuildContext context;
  final ScrollController scrollController;

  HandleNotifications(this.scrollController, {required this.context});

  Future<void> rescheduleActiveNotifications() async {
    try {
      final notes = await databaseProvider.readAllData().first;
      for (var note in notes) {
        if (note.toDate.isNotEmpty && !(note.isFinished ?? false)) {
          try {
            final parsedToDate = DateFormat.yMMMMd().add_jm().parse(
              note.toDate,
            );
            if (parsedToDate.isAfter(DateTime.now())) {
              await NotificationService().showScheduledNotifications(
                id: note.id!,
                title: note.note,
                body: 'Your task is ready To Do',
                date: parsedToDate,
                repeatInterval: note.todoRepeatItem ?? 'No repeat',
              );
            }
          } catch (e, stack) {
            debugPrint(
              'Error rescheduling notification for ID: ${note.id}: $e\n$stack',
            );
          }
        }
      }
    } catch (e, stack) {
      debugPrint('Error fetching notes for rescheduling: $e\n$stack');
    }
  }

  void onTapNotification() async {
    NotificationService.streamController.stream.listen((response) async {
      if (response.payload != null) {
        _navigateToNote(response.payload!);
      }
    });
  }

  Future<void> _navigateToNote(String payload) async {
    try {
      final parts = payload.split('|');
      final noteId = int.tryParse(parts[0]);
      if (noteId != null) {
        final note = await databaseProvider.getNoteById(noteId);
        if (note != null && context.mounted) {
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddEditToDoView(
                  todoModel: note,
                  scrollController: scrollController,
                );
              },
            ),
          );
        } else {
          debugPrint('Note with ID: $noteId not found or context not mounted');
        }
      } else {
        debugPrint('Invalid note ID in payload: $payload');
      }
    } catch (e, stack) {
      debugPrint('Error navigating to note from payload: $payload: $e\n$stack');
    }
  }
}
