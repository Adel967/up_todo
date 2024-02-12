import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/core/configuration/assets.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/core/ui/custom_app_bar.dart';
import 'package:up_todo/core/ui/waiting_widget.dart';
import 'package:up_todo/layers/models/task.dart';
import 'package:up_todo/layers/view/screens/index/widgets/task_list.dart';
import '../../../../injection_container.dart';
import '../../../bloc/task_filter_bloc/task_filter_cubit.dart';
import '../../../bloc/tasks_cubit/tasks_cubit.dart';
import '../../../models/category.dart';
import '../../widgets/task_card.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final searchEditingController = TextEditingController();
  double turns = 0.0;

  final taskFilterCubit = sl<TaskFilter>();
  final tasksCubit = sl<TasksCubit>();

  @override
  void initState() {
    super.initState();
    taskFilterCubit.getTasks(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: BlocListener<TasksCubit, TasksState>(
        bloc: tasksCubit,
        listener: (context, state) {
          if (state is TasksLoaded) {
            taskFilterCubit.getTasks(DateTime.now());
          } else if (state is TasksCompleting) {
            taskFilterCubit.taskLoading();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(title: "Index"),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: BlocBuilder(
                      bloc: taskFilterCubit,
                      builder: (context, state) {
                        if (state is TaskFilterLoading) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 100.0),
                            child: Center(child: WaitingWidget()),
                          );
                        } else if (state is TaskFilterError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else if (state is TaskFilterLoaded) {
                          return state.completedTask.isEmpty &&
                                  state.uncompletedTask.isEmpty
                              ? addingTaskRequestWidget()
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: searchEditingController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colors.white),
                                        onChanged: (text) {
                                          taskFilterCubit.getTasks(
                                              DateTime.now(),
                                              search: text);
                                        },
                                        decoration: InputDecoration(
                                          fillColor: Color(0XFF1D1D1D),
                                          filled: true,
                                          hintText: "Search for your tasks...",
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.white.withOpacity(.7),
                                            size: 25,
                                          ),
                                          isDense: true,
                                          hintStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.7),
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: [
                                          Visibility(
                                              visible: state
                                                  .uncompletedTask.isNotEmpty,
                                              child: TaskList(
                                                title: "Today",
                                                tasks: state.uncompletedTask,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Visibility(
                                              visible: state
                                                  .completedTask.isNotEmpty,
                                              child: TaskList(
                                                  title: "Completed",
                                                  tasks: state.completedTask)),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                        } else {
                          return SizedBox();
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addingTaskRequestWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.ONBOARDING3_ICON),
          SizedBox(
            height: 20,
          ),
          Text(
            "What do you want to do today!",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Tap + to add your tasks",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
