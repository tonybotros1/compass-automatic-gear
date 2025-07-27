import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeSheetsController extends GetxController {
  RxString selectedEmployeeName = RxString('');
  RxString selectedEmployeeId = RxString('');
  RxString selectedJob = RxString('');
  RxString selectedJobId = RxString('');
  RxString selectedTask = RxString('');
  RxString selectedTaskId = RxString('');
  RxString companyId = RxString('');
  RxBool isScreenLoding = RxBool(false);
  RxBool isScreenLodingForJobs = RxBool(false);
  RxMap allBrands = RxMap({});
  RxMap allColors = RxMap({});

  final RxList<DocumentSnapshot> allTechnician = RxList<DocumentSnapshot>([]);
  // final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allJobCards =
  //     RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  final RxList<Map<String, dynamic>> allJobCards = <Map<String, dynamic>>[].obs;

  final Map<String, Map<String, String>> modelCache = {};
  final Map<String, String> colorCache = {};

  @override
  void onInit() async {
    await getCompanyId();
    getCarBrands();
    await getColors();
    getAllTechnicians();
    getApprovedJobs();
    super.onInit();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  getAllTechnicians() {
    try {
      isScreenLoding.value = true;
      FirebaseFirestore.instance
          .collection('all_technicians')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('name', descending: false)
          .snapshots()
          .listen((tech) {
        allTechnician.assignAll(List<DocumentSnapshot>.from(tech.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  // getApprovedJobs() {
  //   try {
  //     isScreenLodingForJobs.value = true;
  //     FirebaseFirestore.instance
  //         .collection('job_cards')
  //         .where('company_id', isEqualTo: companyId.value)
  //         .where('job_status_2', isEqualTo: 'Approved')
  //         .orderBy('job_number')
  //         .snapshots()
  //         .listen((jobs) {
  //       allJobCards.assignAll(jobs.docs);
  //       isScreenLodingForJobs.value = false;
  //     });
  //   } catch (e) {
  //     isScreenLodingForJobs.value = false;
  //   }
  // }

  void getApprovedJobs() {
    isScreenLodingForJobs.value = true;

    FirebaseFirestore.instance
        .collection('job_cards')
        .where('company_id', isEqualTo: companyId.value)
        .where('job_status_2', isEqualTo: 'Approved')
        .orderBy('job_number')
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> enrichedJobs = [];

      for (var doc in snapshot.docs) {
        final job = doc.data();
        job['id'] = doc.id;

        // جلب الأسماء المرتبطة بشكل متزامن
        final brandName = getdataName(job['car_brand'], allBrands);
        final modelName =
            await getCarModelNameCached(job['car_brand'], job['car_model']);
        final colorName = getdataName(job['color'], allColors);

        job['car_brand'] = brandName;
        job['car_model'] = modelName;
        job['color'] = colorName;

        enrichedJobs.add(job);
      }

      allJobCards.assignAll(enrichedJobs);
      isScreenLodingForJobs.value = false;
    }, onError: (e) {
      isScreenLodingForJobs.value = false;
      // print('🔥 Error listening to jobs: $e');
    });
  }

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .orderBy('name')
          .snapshots()
          .listen((brands) {
        allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  Future<String> getCarModelNameCached(String brandId, String modelId) async {
    if (modelCache[brandId]?.containsKey(modelId) ?? false) {
      return modelCache[brandId]![modelId]!;
    }
    final doc = await FirebaseFirestore.instance
        .collection('all_brands')
        .doc(brandId)
        .collection('values')
        .doc(modelId)
        .get();
    final name = doc.data()?['name'] ?? '';
    modelCache[brandId] = modelCache[brandId] ?? {};
    modelCache[brandId]![modelId] = name;
    return name;
  }

// this function is to get colors
  getColors() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'COLORS')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .listen((colors) {
      allColors.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
  }
}
