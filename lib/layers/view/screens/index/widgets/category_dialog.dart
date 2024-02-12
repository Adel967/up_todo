import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:up_todo/core/constants.dart';
import 'package:up_todo/layers/bloc/category_bloc/category_cubit.dart';
import 'package:up_todo/layers/bloc/create_task_bloc/create_task_cubit.dart';
import 'package:up_todo/layers/view/screens/index/create_category_screen.dart';
import '../../../../../core/constants/theme.dart';
import '../../../../../injection_container.dart';
import '../../../../models/category.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final categoryCubit = sl<CategoryCubit>();
  int? selectedIndex;
  Category? selectedCategory;
  final createTaskCubit = sl<CreateTaskCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!(categoryCubit.state is CategoryLoaded)) {
      categoryCubit.getCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: ThemeColors.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Category",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Divider(
                  color: Color(0XFF979797),
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<CategoryCubit, CategoryState>(
                  bloc: categoryCubit,
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return loading_shimmer();
                    } else if (state is CategoryError) {
                    } else if (state is CategoryLoaded) {
                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.0, crossAxisCount: 3),
                          shrinkWrap: true,
                          itemCount: state.categories.length + 1,
                          itemBuilder: (context, index) {
                            late Category category;
                            if (index < state.categories.length) {
                              category = state.categories[index];
                            } else {
                              category = Category(
                                  title: "Create New",
                                  icon: Icons.add,
                                  color: Colors.greenAccent.shade200);
                            }
                            return GestureDetector(
                              onTap: () {
                                if (index == state.categories.length) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => CreateCategoryScreen()));
                                } else {
                                  setState(() {
                                    selectedIndex = index;
                                    selectedCategory = state.categories[index];
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                padding: EdgeInsets.only(top: 5),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: category.color,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  category.icon,
                                                  size: 35,
                                                  color: Constants.darken(
                                                      category.color, .3),
                                                ),
                                              ),
                                            ),
                                            selectedIndex != null &&
                                                    selectedIndex == index
                                                ? Positioned(
                                                    top: -7,
                                                    left: -7,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          category.title,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white
                                                  .withOpacity(0.9)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return SizedBox();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
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
                                  borderRadius: BorderRadius.circular(3))),
                          backgroundColor:
                              MaterialStateProperty.all(ThemeColors.secondary)),
                      onPressed: () {
                        if (selectedCategory != null) {
                          createTaskCubit.category = selectedCategory;
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Shimmer loading_shimmer() {
    return Shimmer.fromColors(
        baseColor: Color(0XFF434343),
        highlightColor: Color(0XFF505050),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0, crossAxisCount: 3),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeColors.secondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: ThemeColors.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
