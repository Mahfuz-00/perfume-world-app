import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit(int initialIndex) : super(initialIndex);

  void setIndex(int index) {
    print('Setting index: $index');  // Debugging state changes
    emit(index);
  }
}
