import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ad_offer_app/Categories/categories.dart';
import 'package:ad_offer_app/Services/global_methods.dart';
import 'package:uuid/uuid.dart';
import '../Services/global_variables.dart';
import '../CommonWidgets/bottom_nav_bar.dart';

class UploadOfferNow extends StatefulWidget {
  @override
  State<UploadOfferNow> createState() => _UploadOfferNowState();
}

class _UploadOfferNowState extends State<UploadOfferNow> {

  final TextEditingController _offerCategoryController = TextEditingController(text: 'Select Offer Category');
  final TextEditingController _offerTitleController = TextEditingController();
  final TextEditingController _offerDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose()
  {
    super.dispose();
    _offerCategoryController.dispose();
    _offerTitleController.dispose();
    _offerDescriptionController.dispose();
  }

  Widget _textTitles({required String label}){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xffececec),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
})
{
return Padding(
  padding: const EdgeInsets.all(5.0),
  child: InkWell(
    onTap: (){
      fct();
    },
    child: TextFormField(
      validator: (value)
          {
            if(value!.isEmpty)
              {
                return 'Value is missing';
              }
            return null;
          },
      controller: controller,
      enabled: enabled,
      key: ValueKey(valueKey),
      style: const TextStyle(
        color: Colors.white,
      ),
      maxLines: valueKey == 'OfferDescription' ? 3 : 1,
      maxLength: maxLength,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.black54,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    ),
  ),
);
}

 _showTaskCategoriesDialog({required Size size})

 {
   showDialog(
     context: context,
     builder: (ctx)
     {
       return AlertDialog(
         backgroundColor: Color(0xe50e638d),
         title: const Text(
           'Offer Category',
           textAlign: TextAlign.center,
           style:
           TextStyle(
             fontSize: 20,
             color: Colors.white,
           ),
         ),
         content: Container(
           width: size.width * 0.9,
           child: ListView.builder(
             shrinkWrap: true,
             itemCount: Categories.offerCategoryList.length,
             itemBuilder: (ctx, index)
             {
               return InkWell(
                 onTap: (){
                   setState(() {
                     _offerCategoryController.text = Categories.offerCategoryList[index];
                    });
                   Navigator.pop(context);
                  },
                 child: Row(
                   children: [
                     const Icon(
                       Icons.arrow_right_alt_outlined,
                       color: Color(0xffdcdbdb),
                     ),
                     const SizedBox(width: 8),
                     Expanded(
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           Categories.offerCategoryList[index],
                           style: const TextStyle(
                             color: Color(0xffdcdbdb),
                             fontSize: 16,
                           ),
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                     ),
                   ],
                 ),
               );
             }
           ),
         ),
         actions: [
           TextButton(
               onPressed: (){
                 Navigator.canPop(context) ? Navigator.pop(context) : null;
               },
             child: const Text('Cancel', style:
               TextStyle(
                 color: Colors.white,
                 fontSize: 16,

               ),
             ),
           ),
         ],
       );
     }
   );
 }


 void _uploadTask() async
 {
    final offerId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if(isValid)
      {
        if( _offerCategoryController.text == 'Chose offer category')
        {
          GlobalMethod.showErrorDialog(
            error: 'Please pick everything', ctx: context
          );
          return;
        }
        setState(() {
          _isLoading = true;
        });
        try
        {
          await FirebaseFirestore.instance.collection('offers').doc(offerId).set({
            'offerId': offerId,
            'uploadedBy': _uid,
            'email': user.email,
            'offerTitle': _offerTitleController.text,
            'offerDescription': _offerDescriptionController.text,
            'offerCategory': _offerCategoryController.text,
            'offerChat': [],
            'validity': true,
            'createdAt': Timestamp.now(),
            'name': name,
            'userImage': userImage,
            'location': location,
            'state': 'Pending',
          });
          await Fluttertoast.showToast(
            msg: 'The task has been uploaded',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18.0,
          );
          _offerTitleController.clear();
          _offerDescriptionController.clear();
          setState(() {
            _offerCategoryController.text = 'Choose offer category';
          });
        } catch(error) {
          {
            setState(() {
              _isLoading = false;
            });
            GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
          }
        }
        finally
            {
              setState(() {
                _isLoading = false;
              });
            }
      }
    else
      {
        print('It is not valid');
      }
 }

 void getMyData() async
 {
   final DocumentSnapshot userDoc = await FirebaseFirestore.instance
       .collection('users')
       .doc(FirebaseAuth.instance.currentUser!.uid)
       .get();

   setState(() {
     name = userDoc.get('name');
     userImage = userDoc.get('userImage');
     location = userDoc.get('location');
   });
 }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfff1f1f1),Color(0xffd0d0d0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Color(0xc50e638d),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please fill all fields',
                          style: TextStyle(
                            color: Color(0xffececec),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: 'Offer Category :'),
                            _textFormFields(
                              valueKey: 'OfferCategory',
                              controller: _offerCategoryController,
                              enabled: false,
                              fct: (){
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                              ),
                            _textTitles(label: 'Offer Title :'),
                            _textFormFields(
                              valueKey: 'OfferTitle',
                              controller: _offerTitleController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Offer Description :'),
                            _textFormFields(
                              valueKey: 'OfferDescription',
                              controller: _offerDescriptionController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: _isLoading
                          ? const CircularProgressIndicator()
                          : MaterialButton(
                          onPressed: (){
                            _uploadTask();
                          },
                          color: Color(0xff189dbd),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Post Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(width: 9,),
                                Icon(
                                  Icons.upload_file,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
