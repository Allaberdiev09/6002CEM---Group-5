import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/global_variables.dart';

class Categories
{
  static List<String> offerCategoryList = [
    'Agriculture and Forestry',
    'Automotive',
    'Banking and Finance',
    'Biotechnology and Pharmaceuticals',
    'Charity',
    'Chemicals',
    'Construction and Real Estate',
    'Consumer Goods and Services',
    'Education',
    'Energy and Utilities',
    'Entertainment and Media',
    'Food and Beverage',
    'Healthcare and Medical Devices',
    'Hospitality and Tourism',
    'Information Technology and Services',
    'Manufacturing',
    'Mining and Metals',
    'Retail',
    'Telecommunications',
    'Transportation and Logistics',
    'Waste Management and Recycling',
  ];

  void getMyData() async
  {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

      name = userDoc.get('name');
      userImage = userDoc.get('userImage');
      location = userDoc.get('location');
  }

}