import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:up_todo/core/constants.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/core/loaders/loading_overlay.dart';
import 'package:up_todo/layers/bloc/create_task_bloc/create_task_cubit.dart';
import 'package:up_todo/layers/view/screens/index/widgets/category_dialog.dart';
import 'package:up_todo/layers/view/screens/index/widgets/priority_dialog.dart';

import '../../../../../injection_container.dart';
import 'date_dialog.dart';

class AddTaskDialog {
  void showDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: DialogContent(),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}

class DialogContent extends StatefulWidget {
  const DialogContent({super.key});

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  FocusNode _titleNode = FocusNode();

  final createTaskCubit = sl<CreateTaskCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTaskCubit, CreateTaskState>(
      bloc: createTaskCubit,
      listener: (context, state) {
        if (state is CreateTaskLoading) {
          LoadingOverlay.of(context).show();
        } else if (state is CreateTaskLoaded) {
          LoadingOverlay.of(context).hide();
          Navigator.of(context).pop();
        } else if (state is CreateTaskError) {
          LoadingOverlay.of(context).hide();
          Constants.showSnackBar(
              context, "There is an error, try again later!");
        }
      },
      child: Container(
        margin: MediaQuery.of(context).viewInsets,
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: const BoxDecoration(
          color: ThemeColors.accent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Material(
          color: ThemeColors.accent,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildContinueText(),
                const SizedBox(height: 8),
                _buildTitleField(),
                _buildDescriptionField(),
                _buildBottomBar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueText() {
    return const Text(
      'Add Task',
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      focusNode: _titleNode,
      controller: titleController,
      onChanged: (text) {
        createTaskCubit.taskTitle = text;
      },
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      obscureText: false,
      validator: (text) {
        if (text != null) {
          if (text!.isEmpty) {
            return "Fill all fields";
          }
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: "Enter Task Title",
          isDense: true,
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none)),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      //controller: titleController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      obscureText: false,
      onChanged: (text) {
        createTaskCubit.taskDescription = text;
      },
      validator: (text) {
        if (text != null) {
          if (text!.isEmpty) {
            return "Fill all fields";
          }
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: "Description",
          isDense: true,
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none)),
    );
  }

  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus!.unfocus();
                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => DateDialog());
                },
                icon: Icon(
                  Icons.timer,
                  color: Colors.white,
                )),
            IconButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus!.unfocus();
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => CategoryDialog());
              },
              icon: FaIcon(FontAwesomeIcons.tag),
              color: Colors.white,
            ),
            IconButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus!.unfocus();
                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => PriorityDialog());
                },
                icon: FaIcon(
                  FontAwesomeIcons.flag,
                  color: Colors.white,
                )),
          ],
        ),
        IconButton(
            onPressed: () => createTaskCubit.addNewTask(),
            icon: Icon(
              Icons.send,
              color: ThemeColors.secondary,
            )),
      ],
    );
  }
}
