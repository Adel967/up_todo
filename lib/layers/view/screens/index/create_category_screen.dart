import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/core/constants.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/core/loaders/loading_overlay.dart';
import 'package:up_todo/layers/models/category.dart';
import 'package:up_todo/layers/view/screens/index/widgets/choose_icon_dialog.dart';

import '../../../../injection_container.dart';
import '../../../bloc/category_bloc/category_cubit.dart';
import '../../widgets/custom_text_field_with_title.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _categoryTitleController = TextEditingController();
  late int selectedColor = 0;
  IconData? selectedIcon;
  final categoryCubit = sl<CategoryCubit>();

  selectIcon() async {
    final res = await showDialog<IconData>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ChooseIconDialog(initialIcon: selectedIcon));
    if (res != null) {
      setState(() {
        selectedIcon = res;
      });
    }
  }

  List<int> colors = [
    0XFFC9CC41,
    0XFF66CC41,
    0XFF41CCA7,
    0XFF4181CC,
    0XFF41A2CC,
    0XFFCC8441,
    0XFF9741CC,
    0XFFCC4173,
    0XFFFFCC80,
    0XFFFF80EB,
    0XFF80FFFF,
    0XFFFF9680,
  ];

  createCategory() {
    if (_categoryTitleController.text.trim().isNotEmpty &&
        selectedIcon != null) {
      categoryCubit.addNewCategory(Category(
          title: _categoryTitleController.text.trim(),
          icon: selectedIcon!,
          color: Color(colors[selectedColor])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: BlocListener<CategoryCubit, CategoryState>(
        bloc: categoryCubit,
        listener: (context, state) {
          if (state is CategoryLoading) {
            LoadingOverlay.of(context).show();
          } else if (state is CategoryLoaded) {
            LoadingOverlay.of(context).hide();
            Navigator.of(context).pop();
          } else if (state is CategoryError) {
            LoadingOverlay.of(context).hide();
            Constants.showSnackBar(
                context, "There is an error, try again later!");
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create new category",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextFieldWithTitle(
                              title: "Category name :",
                              hintText: "Category name",
                              textEditingController: _categoryTitleController,
                              textInputType: TextInputType.text),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Category Icon :",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          selectedIcon != null
                              ? GestureDetector(
                                  onTap: () => selectIcon(),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0XFF272727),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(
                                      selectedIcon!,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : TextButton(
                                  onPressed: () => selectIcon(),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white.withOpacity(0.2))),
                                  child: Text(
                                    "Choose icon from library",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14),
                                  )),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Category Color :",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: colors.length,
                                itemBuilder: (context, index) {
                                  int color = colors[index];
                                  return GestureDetector(
                                    onTap: () {
                                      selectedColor = index;
                                      setState(() {});
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Color(color),
                                          shape: BoxShape.circle,
                                        ),
                                        child: selectedColor == index
                                            ? Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const SizedBox.shrink()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                      Row(
                        children: [
                          Expanded(
                              child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: ThemeColors.secondary, fontSize: 16),
                            ),
                          )),
                          Expanded(
                              child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3))),
                                backgroundColor: MaterialStateProperty.all(
                                    ThemeColors.secondary)),
                            onPressed: () => createCategory(),
                            child: Text(
                              "Create Category",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
