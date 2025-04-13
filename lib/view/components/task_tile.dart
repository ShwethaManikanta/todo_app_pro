import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import 'package:share_plus/share_plus.dart';



class TaskTile extends StatefulWidget {
  final TaskModel task;
  final String currentUserId;
  final void Function(String userId) onShare;
  final VoidCallback onDelete;
  final void Function(String updatedTitle, String updatedDesc) onUpdate;

  const TaskTile({
    super.key,
    required this.task,
    required this.currentUserId,
    required this.onShare,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.task.ownerId == widget.currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEditing)
              Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(widget.task.description),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isOwner) ...[
                  IconButton(
                    icon: Icon(isEditing ? Icons.check : Icons.edit),
                    onPressed: () {
                      if (isEditing) {
                        widget.onUpdate(
                          _titleController.text,
                          _descController.text,
                        );
                      }
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    _showShareDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Modified to send email with task details
  void _showShareDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Share Task With"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
              hintText: "Enter email address",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final email = controller.text;
              if (email.isNotEmpty) {
                _sendEmail(email);
              }
              Navigator.pop(context);
            },
            child: const Text("Share"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // New method to send the task details via email
  Future<void> _sendEmail(String email) async {
    final String shareContent =
    'Title: ${widget.task.title}\n Description: ${widget.task.description}';
    Share.share(shareContent, subject: 'Shared Task: ${widget.task.title}');
  }
}


