import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/utils/color.dart';
import '../../models/task_model.dart';
import '../../view_model/task_view_model.dart';
import '../components/input_field.dart';
import '../components/task_tile.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final String _currentUserId = 'user_1'; // Simulate login
  final ScrollController _scrollController = ScrollController();
  List<TaskModel> _displayedTasks = [];
  int _pageSize = 10;
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    viewModel.taskStream.listen((tasks) {
      final userTasks = viewModel.getTasks(_currentUserId);
      setState(() {
        _displayedTasks = userTasks.take(_currentMax).toList();
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _currentMax += _pageSize;
        _displayedTasks = context
            .read<TaskViewModel>()
            .getTasks(_currentUserId)
            .take(_currentMax)
            .toList();
      });
    }
  }

  void _addTask() {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) return;
    context.read<TaskViewModel>().addTask(
      _titleController.text,
      _descController.text,
      _currentUserId,
    );
    _titleController.clear();
    _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: fbackgroundColor2,
        centerTitle: true,
        title: const Text("TODO App"),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => vm.resetTasks(),
                icon: const Icon(Icons.delete_forever),
                tooltip: 'Clear All Tasks',
              ),
              Positioned(
                right: -1,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                InputField(
                  controller: _titleController,
                  hintText: "Task Title",
                  id: "title",
                ),
                const SizedBox(height: 10),
                InputField(
                  controller: _descController,
                  hintText: "Task Description",
                  id: "desc",
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text("Add Task"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _displayedTasks.length,
              itemBuilder: (context, index) {
                final task = _displayedTasks[index];
                return TaskTile(
                  task: task,
                  currentUserId: _currentUserId,
                  onShare: (shareWithUserId) {
                    context
                        .read<TaskViewModel>()
                        .shareTask(task.id, shareWithUserId);
                  },
                  onDelete: () {
                    context.read<TaskViewModel>().deleteTask(task.id);
                  },
                  onUpdate: (updatedTitle, updatedDesc) {
                    final updatedTask = task.copyWith(
                      title: updatedTitle,
                      description: updatedDesc,
                    );
                    context.read<TaskViewModel>().updateTask(updatedTask);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
