import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/add_new_todo_view.dart';
import 'package:todo_app/widgets/lists_drop_down_list.dart';
import 'package:todo_app/widgets/todo_list_item.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: CustomListsDropDownList(
            isHomePage: true,
            initialTextColor: Colors.white,
            prefixIconColor: Colors.white,
            suffixIconColor: Colors.white,
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width / 2,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        toolbarHeight: 75,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: StreamBuilder<List<TodoModel>>(
          stream: todoProvider.readAllData(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final notes = snapshot.data ?? [];
            return notes.isNotEmpty
                ? ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return TodoListItem(todoModel: notes[index]);
                    },
                  )
                : const Center(child: Text('There are no data to show!'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryLightColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_task_outlined),
        onPressed: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddNewToDoView();
              },
            ),
          );
        },
      ),
    );
  }
}
