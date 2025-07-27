import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/car_brands.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/companies.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/countries.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/currency.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/invoice_items.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/job_card.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/list_of_values.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/sales_man.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/technician.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/User%20Management/functions.dart';
import 'package:datahubai/Screens/Main%20screens/Trading/car_trading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/screen_tree_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Screens/Dashboard/trading_dashboard.dart';
import '../../Screens/Main screens/System Administrator/Setup/AP_payment_type.dart';
import '../../Screens/Main screens/System Administrator/Setup/ap_invoices.dart';
import '../../Screens/Main screens/System Administrator/Setup/banks_and_others.dart';
import '../../Screens/Main screens/System Administrator/Setup/branches.dart';
import '../../Screens/Main screens/System Administrator/Setup/cash_management_payment.dart';
import '../../Screens/Main screens/System Administrator/Setup/cash_management_receipts.dart';
import '../../Screens/Main screens/System Administrator/Setup/counters.dart';
import '../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../Screens/Main screens/System Administrator/Setup/system_variables.dart';
import '../../Screens/Main screens/System Administrator/Setup/time_sheets.dart';
import '../../Screens/Main screens/System Administrator/User Management/menus.dart';
import '../../Screens/Main screens/System Administrator/User Management/responsibilities.dart';
import '../../Screens/Main screens/System Administrator/User Management/users.dart';
import '../../Widgets/main screen widgets/first_main_screen_widgets/first_main_screen.dart';
import '../../consts.dart';

class MainScreenController extends GetxController {
  final RxList<DocumentSnapshot> favoriteScreens = RxList<DocumentSnapshot>([]);
  late TreeController<MyTreeNode> treeController;
  RxList<MyTreeNode> roots = <MyTreeNode>[].obs;
  RxBool isLoading = RxBool(false);
  RxString uid = RxString('');
  RxList<String> userRoles = RxList([]);
  // RxString roleMenus = RxString('');
  RxList<String> roleMenus = RxList([]);
  RxList<MyTreeNode> finalMenu = RxList([]);
  RxBool arrow = RxBool(false);
  Rx<Widget> selectedScreen = const SizedBox(
    child: FirstMainScreen(),
  ).obs;
  Rx<String> selectedScreenName = RxString('🏡 Home');
  Rx<String> selectedScreenRoute = RxString('/home');
  Rx<String> selectedScreenDescription = RxString('');
  RxString userName = RxString('');
  RxString userEmail = RxString('');
  RxString userJoiningDate = RxString('');
  RxString userExpiryDate = RxString('');
  RxString companyId = RxString('');
  RxBool errorLoading = RxBool(false);
  RxMap allMenus = RxMap({});
  RxMap allScreens = RxMap({});
  RxString companyImageURL = RxString('');
  RxString companyName = RxString('');
  RxDouble menuWidth = RxDouble(250);
  RxString userId = RxString('');
  MyTreeNode? previouslySelectedNode;
  RxBool isHovered = RxBool(false);
  

  @override
  void onInit() async {
    // init();
    await getCompanyDetails();
    getFavoriteScreens();
    getScreens();
    super.onInit();
  }

  // this function is to get company details
  getCompanyDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = '${prefs.getString('companyId')}';
    userId.value = prefs.getString('userId')!;
    if (companyId.value == '' || companyId.isEmpty) return;

    var companyDetails = await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId.value)
        .get();
    if (companyDetails.exists) {
      companyImageURL.value = companyDetails.data()!['company_logo'];
      companyName.value = companyDetails.data()!['company_name'];
    }
  }

// this function is to get the fisrt letter of the name of current user
  String getFirstCharacter(String word) {
    return word.characters.isNotEmpty ? word.characters.first : '';
  }

// this function is to get the screen and show it on the right side of the main screen
  Widget getScreenFromRoute(String? routeName) {
    switch (routeName) {
      case '/home':
        return SizedBox(child: FirstMainScreen());
      case '/users':
        return SizedBox(child: Users());
      case '/functions':
        return const SizedBox(child: Functions());
      case '/menus':
        return const SizedBox(child: Menus());
      case '/responsibilities':
        return const SizedBox(child: Responsibilities());
      case '/defineCompany':
        return const SizedBox(child: Companies());
      case '/listOfValues':
        return const SizedBox(child: ListOfValues());
      case '/systemVariables':
        return const SizedBox(child: SystemVariables());
      case '/entityInformation':
        return const SizedBox(child: EntityInformations());
      case '/salesMan':
        return const SizedBox(child: SalesMan());
      case '/counters':
        return const SizedBox(child: Counters());
      case '/currencies':
        return const SizedBox(child: Currency());
      case '/branches':
        return const SizedBox(child: Branches());
      case '/jobCards':
        return SizedBox(child: JobCard());
      case '/quotationCards':
        return SizedBox(child: QuotationCard());
      case '/countries':
        return const SizedBox(child: Countries());
      case '/carBrands':
        return const SizedBox(child: CarBrands());
      case '/invoiceItems':
        return const SizedBox(child: InvoiceItems());
      case '/technicians':
        return const SizedBox(child: Technician());
      case '/cashManagementReceipt':
        return const SizedBox(child: CashManagementReceipt());
      case '/cashManagementPayment':
        return const SizedBox(child: CashManagementPayment());
      case '/banks':
        return const SizedBox(child: BanksAndOthers());
      case '/carTrading':
        return const SizedBox(child: CarTrading());
      case '/apPaymentType':
        return const SizedBox(child: ApPaymentType());
      case '/apInvoices':
        return const SizedBox(child: ApInvoices());
      case '/trading':
        return const SizedBox(child: TradingDashboard());
      case '/timeSheets':
        return const SizedBox(child: TimeSheets());
      default:
        return const SizedBox(child: Center(child: Text('Screen not found')));
    }
  }

  // this function is to get the name of the screen of the right side of the main screen
  Text getScreenName(name) {
    return Text(
      name,
      style: fontStyleForAppBar,
    );
  }

  Future<void> getScreens() async {
    try {
      isLoading.value = true;

      // Fetch user ID from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final action = prefs.getString('userId');
      if (action == null || action.isEmpty) return;

      uid.value = action;

      // Fetch user data from Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .doc(uid.value)
          .get();

      if (!userSnapshot.exists) return;

      final fetchedRoles =
          List<String>.from(userSnapshot.data()?['roles'] ?? []);
      userName.value = userSnapshot.data()?['user_name'] ?? '';
      userEmail.value = userSnapshot.data()?['email'] ?? '';
      userJoiningDate.value = userSnapshot.data()?['added_date'] ?? '';
      userExpiryDate.value = userSnapshot.data()?['expiry_date'] ?? '';
      // Assign roles directly without checking for cached data
      userRoles.assignAll(fetchedRoles);

      // Fetch role menus
      final roleSnapshot = await FirebaseFirestore.instance
          .collection('sys-roles')
          .where(FieldPath.documentId, whereIn: userRoles)
          .get();

      roleMenus.clear();
      for (var doc in roleSnapshot.docs) {
        final menuID = doc.data()['menuID'];
        if (menuID is String) {
          roleMenus.add(menuID);
        } else if (menuID is List) {
          roleMenus.addAll(List<String>.from(menuID));
        }
      }

      // Fetch menus and screens
      final collections = await Future.wait([
        FirebaseFirestore.instance.collection('menus ').get(),
        FirebaseFirestore.instance.collection('screens').get(),
      ]);

      allMenus.value = {
        for (var menu in collections[0].docs) menu.id: menu.data()
      };
      allScreens.value = {
        for (var screen in collections[1].docs) screen.id: screen.data()
      };

      // Filter menus based on role menus
      final menuSnapshot = allMenus.entries
          .where((entry) => roleMenus.contains(entry.key))
          .toList();

      // Build tree structure
      final roots = await Future.wait(menuSnapshot.map((menuDoc) async {
        final children = await buildMenus(menuDoc.value);
        return MyTreeNode(
          isMenu: true,
          title: menuDoc.value['name'],
          children: children,
          routeName: menuDoc.value['routeName'],
        );
      }));

      // Initialize tree controller
      treeController = TreeController<MyTreeNode>(
        roots: roots,
        childrenProvider: (node) => node.children,
        parentProvider: (node) => node.parent,
      );

      isLoading.value = false;
    } catch (e) {
      errorLoading.value = true;
      isLoading.value = false;
    }
  }

  Future<List<MyTreeNode>> buildMenus(Map<String, dynamic> menuDetail) async {
    List<String> childrenIds = List<String>.from(menuDetail['children'] ?? []);

    if (childrenIds.isEmpty) return [];

    // Fetch child menus
    final menuSnapshot = allMenus.entries
        .where((entry) => childrenIds.contains(entry.key))
        .toList();

    // Fetch child screens
    final screenSnapshot = allScreens.entries
        .where((entry) => childrenIds.contains(entry.key))
        .toList();

    // Build nodes for menus and screens
    final menuNodes = await Future.wait(menuSnapshot.map((menuDoc) async {
      final children = await buildMenus(menuDoc.value);
      return MyTreeNode(
        isMenu: true,
        title: menuDoc.value['name'],
        children: children,
        routeName: menuDoc.value['routeName'],
      );
    }));

    final screenNodes = screenSnapshot.map((screenDoc) {
      return MyTreeNode(
          isMenu: false,
          title: screenDoc.value['name'],
          children: [],
          routeName: screenDoc.value['routeName'],
          description: screenDoc.value['description'] ?? '');
    }).toList();

    return [...menuNodes, ...screenNodes];
  }

// init the tree
  init() {
    final List<MyTreeNode> roots = [
      MyTreeNode(
        title: 'Root Node',
        children: [
          MyTreeNode(
            title: 'Node 1',
            children: [
              MyTreeNode(title: 'Node 1.1'),
              MyTreeNode(title: 'Node 1.2'),
            ],
          ),
          MyTreeNode(
            title: 'Node 2',
            children: [
              MyTreeNode(title: 'Node 2.1'),
              MyTreeNode(title: 'Node 2.2'),
            ],
          ),
        ],
      ),
      MyTreeNode(
        title: 'Root Node',
        children: [
          MyTreeNode(
            title: 'Node 1',
            children: [
              MyTreeNode(title: 'Node 1.1'),
              MyTreeNode(title: 'Node 1.2'),
            ],
          ),
          MyTreeNode(
            title: 'Node 2',
            children: [
              MyTreeNode(title: 'Node 2.1'),
              MyTreeNode(title: 'Node 2.2'),
            ],
          ),
        ],
      ),
    ];
    treeController = TreeController<MyTreeNode>(
      roots: roots,
      childrenProvider: (MyTreeNode node) => node.children,
      parentProvider: (MyTreeNode node) => node.parent,
    );
    isLoading.value = false;
  }

  void getFavoriteScreens() {
    FirebaseFirestore.instance
        .collection('favorite_screens')
        .where('company_id', isEqualTo: companyId.value)
        .where('user_id', isEqualTo: userId.value)
        .orderBy('added_date', descending: true)
        .limit(15)
        .snapshots()
        .listen((fav) {
      favoriteScreens.assignAll(fav.docs);
    }, onError: (e) {
      // print(e);
      // Handle errors here
    });
  }

  addScreenToFavorite() {
    try {
      FirebaseFirestore.instance.collection('favorite_screens').add({
        'screen_name': selectedScreenName.value,
        'screen_route': selectedScreenRoute.value,
        'added_date': DateTime.now(),
        'company_id': companyId.value,
        'user_id': userId.value,
        'description': selectedScreenDescription.value
      });
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try agian');
    }
  }

  void removeScreenFromFavorite(String route) {
    FirebaseFirestore.instance
        .collection('favorite_screens')
        .where('screen_route', isEqualTo: route)
        .get()
        .then((snap) {
      for (var doc in snap.docs) {
        doc.reference.delete();
      }
    });
  }
}
