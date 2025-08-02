import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen_contro.dart';

class CompanyVariablesController extends GetxController {
  RxString companyId = RxString('');
  RxString companyLogo = RxString('');

  double logoSize = 150;
  RxList<String> userRoles = RxList([]);

  RxMap<String, String> companyInformation = RxMap({
    'Company Name': '',
    'Industry': '',
  });
  RxMap<String, String> companyVariables = RxMap({
    'Incentive Percentage': '',
    'VAT Percentage': '',
    'TAX Number': '',
  });
  RxMap<String, String> ownerInformation = RxMap({
    'Name': '',
    'Phone Number': '',
    'Email': '',
    'Address': '',
    'Country': '',
    'City': '',
  });
  RxMap industryMap = RxMap({});

  MainScreenController mainScreenController = Get.put(MainScreenController());

  @override
  void onInit() async {
    await getCompanyId();
    await getIndustries();
    getCurrentCompanyInformation();
    getResponsibilitiess();
    super.onInit();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  // this function is to get industries
  getIndustries() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'INDUSTRIES')
        .get();

    var typrId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typrId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((business) {
          industryMap.value = {
            for (var doc in business.docs) doc.id: doc.data(),
          };
        });
  }

  getCurrentCompanyInformation() async {
    try {
      final companyInfos = await FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId.value)
          .get();

      if (companyInfos.exists) {
        final data = companyInfos.data();

        if (data != null) {
          getOwnerInformation(data);
          companyInformation.value = {
            'Company Name': data['company_name'] ?? '',
            'Industry': getdataName(data['industry'], industryMap),
          };
          companyLogo.value = data['company_logo'] ?? '';
        }
      }
    } catch (e) {
      //
    }
  }

  getOwnerInformation(data) async {
    Map<String, dynamic> contactDetails =
        data['contact_details'] as Map<String, dynamic>;

    ownerInformation.value = {
      'Name': mainScreenController.userName.value,
      'Phone Number': contactDetails['phone'],
      'Email': mainScreenController.userEmail.value,
      'Address': contactDetails['address'],
      'Country': await getCountry(contactDetails['country']),
      'City': await getCity(contactDetails['country'], contactDetails['city']),
    };
  }

  Future<String> getCountry(String id) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(id)
          .get();

      if (doc.exists) {
        final data = doc.data();
        return data?['name'] ?? 'Unknown Country';
      } else {
        return 'Country Not Found';
      }
    } catch (e) {
      return 'Error';
    }
  }

  getCity(country, city) async {
    final doc = await FirebaseFirestore.instance
        .collection('all_countries')
        .doc(country)
        .collection('values')
        .doc(city)
        .get();

    if (doc.exists) {
      final data = doc.data();
      return data?['name'] ?? 'Unknown City';
    } else {
      return 'City Not Found';
    }
  }

  getResponsibilitiess() async {
    List roles = mainScreenController.userRoles;
    userRoles.clear();
    final roleSnapshot = await FirebaseFirestore.instance
        .collection('sys-roles')
        .where(FieldPath.documentId, whereIn: roles)
        .get();

    for (var role in roleSnapshot.docs) {
      userRoles.add(role.data()['role_name']);
    }
  }

  // getUserName(id)async{
  //  var user = await FirebaseFirestore.instance.collection('sys-users').doc(id).get();
  //  String name = user.data()?['user_name'] ?? '';
  //  return name;
  // }
}
