import 'package:cx_final_project/block/cubit_state/pages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PagesCubit extends Cubit<PagesState> {
  PagesCubit() : super(PagesInitial());

  void changePage(int index) {
    switch (index) {
      case 0:
        emit(HomePage());
        break;
      case 1:
        emit(FavoritePage());
        break;
      case 2:
        emit(CategoryPage());
        break;
      case 3:
        emit(CartPage());
        break;
      case 4:
        emit(ProfilePage());
        break;
      default:
        emit(HomePage());
    }
  }
}
