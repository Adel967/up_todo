import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/app/state/app_state.dart';
import '../../../injection_container.dart';
import '../../models/category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  CollectionReference categories = FirebaseFirestore.instance
      .collection('user_data')
      .doc(sl<AppStateModel>().currentUser!.username)
      .collection("categories");

  getCategories() async {
    emit(CategoryLoading());
    try {
      final querySnapshot = await categories.get();
      List<Category> cate =
          querySnapshot.docs.map((doc) => Category.fromMap(doc)).toList();

      emit(CategoryLoaded(categories: cate));
    } catch (ex) {
      emit(CategoryError(errorMessage: "There is an error, try again later!"));
    }
  }

  addNewCategory(Category category) async {
    emit(CategoryLoading());
    try {
      final querySnapshot = await categories.add(category.toMap());
      if (querySnapshot.id.isNotEmpty) {
        getCategories();
      } else {
        emit(
            CategoryError(errorMessage: "There is an error, try again later!"));
      }
    } catch (ex) {
      emit(CategoryError(errorMessage: "There is an error, try again later!"));
    }
  }

  removeCategory(Category category) async {
    emit(CategoryLoading());
    try {
      await categories.doc(category.id).delete();
    } catch (ex) {
      emit(CategoryError(errorMessage: "There is an error, try again later!"));
    }
  }
}
