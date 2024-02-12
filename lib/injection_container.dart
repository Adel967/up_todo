import 'package:get_it/get_it.dart';
import 'package:up_todo/core/app/state/app_state.dart';
import 'package:up_todo/layers/bloc/auth_bloc/auth_cubit.dart';
import 'package:up_todo/layers/bloc/category_bloc/category_cubit.dart';
import 'package:up_todo/layers/bloc/create_task_bloc/create_task_cubit.dart';
import 'package:up_todo/layers/bloc/tasks_cubit/tasks_cubit.dart';
import 'package:up_todo/layers/view/screens/calendar/provider/calendar_properties.dart';

import 'layers/bloc/task_filter_bloc/task_filter_cubit.dart';

final sl = GetIt.instance;

void initInjection() {
  //bloc
  sl.registerLazySingleton(() => AuthCubit());
  sl.registerLazySingleton(() => TaskFilter());
  sl.registerLazySingleton(() => CategoryCubit());
  sl.registerLazySingleton(() => CreateTaskCubit());
  sl.registerLazySingleton(() => TasksCubit());
  sl.registerLazySingleton(() => AppStateModel());
  sl.registerLazySingleton(() => CalendarProperties());
}
