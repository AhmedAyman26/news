import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubit/states.dart';
import 'package:news/news_app/business/business_screen.dart';
import 'package:news/news_app/science/science_screen.dart';
import 'package:news/news_app/sports/sports_screen.dart';
import 'package:news/shared/network/local/cache_helper.dart';

import '../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems =
  [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.business_center_rounded,
        ),
        label: 'Business'
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.sports_basketball_sharp,
        ),
        label: 'Sport'
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.science,
        ),
        label: 'Science'
    ),

  ];

  List<Widget>screens =
  [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1)
      getSports();
    else if (index == 2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic>business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    if (business.length == 0) {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country': 'eg',
            'category': 'business',
            'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'
          }
      ).then((value) {
        business = value.data['articles'];
        print(business[0]['title']);
        emit(NewsGetBusinessSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetBusinessErrorState(error.toString()));
      });
    } else
      emit(NewsGetBusinessSuccessState());
  }

  List<dynamic>sports = [];

  void getSports() {
    emit(NewsGetBusinessLoadingState());

    if (sports.length == 0) {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country': 'eg',
            'category': 'sports',
            'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'
          }
      ).then((value) {
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSportErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSportSuccessState());
    }
  }

  List<dynamic>science = [];

  void getScience() {
    emit(NewsGetBusinessLoadingState());

    if (science.length == 0) {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country': 'eg',
            'category': 'science',
            'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'
          }
      ).then((value) {
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic>search = [];

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q': '$value',
          'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'
        }
    ).then((value) {
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }

  bool isDark = false;

  void ChangeTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(NewsChangeThemeState());
    }
    else {
      isDark = !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
        emit(NewsChangeThemeState());
      });
    }
  }
}

