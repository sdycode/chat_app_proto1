import 'dart:developer';

import 'package:chat_demo1/models/usermodel.dart';
import 'package:chat_demo1/services/dataservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListService {
  Future<List<UserModel>> getUsersFromDatabaseORcache() async {
    List<UserModel> _list = [];
    QuerySnapshot<Map<String, dynamic>> data = await DataService()
        .usersInstance
        .get(GetOptions(source: Source.serverAndCache));
    int count = 0;
    Map map = {};
    data.docs.forEach((e) {
      String useremail = e.data()['user']['email'] ?? 'user$count@gmail.com';
      String userimg = e.data()['user']['img'] ??
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png';
      String username = e.data()['user']['name'] ?? 'User  No $count';

      count++;
      if (!FirebaseAuth.instance.currentUser!.email!
          .toLowerCase()
          .trim()
          .contains(useremail.toLowerCase().trim())) {
        if (!map.containsKey((useremail.toLowerCase().trim()))) {
          _list.add(UserModel.withForList(useremail, username, userimg));
        }
        map[(useremail.toLowerCase().trim())] =
            (useremail.toLowerCase().trim());
      }
    });
    log('listt ${_list.length}');
    return _list.toSet().toList();
  }

  Future<bool> checkThisUserIdexistOrNot(String emailid) async {
    bool exist = false;
    List<String> users = [];
    QuerySnapshot<Map<String, dynamic>> data = await DataService()
        .usersInstance
        .get(GetOptions(source: Source.serverAndCache));
    int count = 0;
    data.docs.forEach((e) {
      if ((e.data()['user']['email'] ?? 'user$count@gmail.com')
          .toString()
          .toLowerCase()
          .trim()
          .contains(emailid.toLowerCase().trim())) {
        exist = true;
        return;
      }
      String useremail = e.data()['user']['email'] ?? 'user$count@gmail.com';
      String userimg = e.data()['user']['img'] ??
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png';
      String username = e.data()['user']['name'] ?? 'User  No $count';
      users.add(useremail.toLowerCase().trim());
      // count++;
      // if (!FirebaseAuth.instance.currentUser!.email!
      //     .toLowerCase()
      //     .trim()
      //     .contains(useremail.toLowerCase().trim())) {
      //   exist = true;
      //   return;
      // _list.add(UserModel.withForList(useremail, username, userimg));
      // }
      // return;
      // break;
    });
    log('$emailid and users are  $users');
    if (users.contains(emailid.trim())) {
      return true;
    } else {
      return false;
    }
    // return exist;
  }

  Future<String> checkPasswordForthisUser(String email) async {
    String pass = 'null';
    QuerySnapshot<Map<String, dynamic>> data = await DataService()
        .usersInstance
        .get(GetOptions(source: Source.serverAndCache));
    QueryDocumentSnapshot<Map<String, dynamic>>? doc;
    data.docs.forEach((e) {
      if (e.data()['user']['email'].toString() == email) {
        doc = e;
      }
    });


    if(doc != null){pass = doc!.data()['user']['pass'].toString();
    
   
    }
    
  

    return pass;
  }


   Future<String> getUserNameforthisemail(String email) async {
    String pass = 'null';
    QuerySnapshot<Map<String, dynamic>> data = await DataService()
        .usersInstance
        .get(GetOptions(source: Source.serverAndCache));
    QueryDocumentSnapshot<Map<String, dynamic>>? doc;
    data.docs.forEach((e) {
      if (e.data()['user']['email'].toString() == email) {
        doc = e;
      }
    });


    if(doc != null){pass = doc!.data()['user']['name'].toString();
    
   
    }
    
  

    return pass;
  }
}
