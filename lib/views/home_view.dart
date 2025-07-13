import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
// import 'package:todo_app/main.dart';
// import 'package:todo_app/models/todo_model.dart';
// import 'package:todo_app/views/add_new_todo_view.dart';
// import 'package:todo_app/widgets/lists_drop_down_list.dart';
// import 'package:todo_app/widgets/todo_list_item.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          // child: const CustomListsDropDownList(
          //   isHomePage: true,
          //   initialTextColor: Colors.white,
          //   prefixIconColor: Colors.white,
          //   suffixIconColor: Colors.white,
          // ),
        ),
        leadingWidth: MediaQuery.of(context).size.width / 2,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
        toolbarHeight: 75,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        // child: StreamBuilder<List<TodoModel>>(
        //   stream: todoProvider.onNotes(),
        //   builder: (context, snapshot) {
        //     var notes = snapshot.data;
        //     if (notes == null) {
        //       return Center(child: CircularProgressIndicator());
        //     }
        //     return notes.isNotEmpty
        //         ? ListView.builder(
        //             itemCount: notes.length,
        //             itemBuilder: (context, index) {
        //               return TodoListItem(todoModel: notes[index]);
        //             },
        //           )
        //         : Center(child: Text('There are no data to show!'));
        //   },
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryLightColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_task_outlined),
        onPressed: () {
          // Navigator.push<void>(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return AddNewToDoView(todoModel: null,);
          //     },
          //   ),
          // );
        },
      ),
    );
  }
}
