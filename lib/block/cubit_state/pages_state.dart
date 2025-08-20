abstract class PagesState {
  int index = 0;
}

class PagesInitial extends PagesState {}

class HomePage extends PagesState {
  int index = 0;
}

class FavoritePage extends PagesState {
  int index = 1;
}

class CategoryPage extends PagesState {
  int index = 2;
}

class CartPage extends PagesState {
  int index = 3;
}

class ProfilePage extends PagesState {
  int index = 4;
}
