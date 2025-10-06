import 'dart:convert';

import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/company_variables.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/car_brands.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/companies.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/countries.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/currency.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/employee_performance.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/inventery_items.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/invoice_items.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/job_card.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/job_tasks.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/list_of_values.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/sales_man.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/technician.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/User%20Management/functions.dart';
import 'package:datahubai/Screens/Main%20screens/Trading/car_trading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/menus_functions_roles/favourite_screen_model.dart';
import '../../Models/screen_tree_model.dart';
import '../../Screens/Dashboard/car_trading_dashboard.dart';
import '../../Screens/Dashboard/trading_dashboard.dart';
import '../../Screens/Main screens/System Administrator/Setup/AP_payment_type.dart';
import '../../Screens/Main screens/System Administrator/Setup/ap_invoices.dart';
import '../../Screens/Main screens/System Administrator/Setup/banks_and_others.dart';
import '../../Screens/Main screens/System Administrator/Setup/branches.dart';
import '../../Screens/Main screens/System Administrator/Setup/cash_management_payment.dart';
import '../../Screens/Main screens/System Administrator/Setup/cash_management_receipts.dart';
import '../../Screens/Main screens/System Administrator/Setup/counters.dart';
import '../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../Screens/Main screens/System Administrator/Setup/issue_items.dart';
import '../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../Screens/Main screens/System Administrator/Setup/receiving.dart';
import '../../Screens/Main screens/System Administrator/Setup/system_variables.dart';
import '../../Screens/Main screens/System Administrator/Setup/time_sheets.dart';
import '../../Screens/Main screens/System Administrator/User Management/menus.dart';
import '../../Screens/Main screens/System Administrator/User Management/responsibilities.dart';
import '../../Screens/Main screens/System Administrator/User Management/users.dart';
import '../../Widgets/main screen widgets/first_main_screen_widgets/first_main_screen.dart';
import '../../consts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../helpers.dart';
import 'websocket_controller.dart';

class MainScreenController extends GetxController {
  final RxList<FavouriteScreensModel> favoriteScreens =
      RxList<FavouriteScreensModel>([]);
  late TreeController<MyTreeNode> treeController;
  RxList<MyTreeNode> roots = <MyTreeNode>[].obs;
  RxBool isLoading = RxBool(false);
  RxList<String> userRoles = RxList([]);
  RxList<MyTreeNode> finalMenu = RxList([]);
  RxBool arrow = RxBool(false);
  Rx<Widget> selectedScreen = const SizedBox(child: FirstMainScreen()).obs;
  Rx<String> selectedScreenName = RxString('🏡 Home');
  Rx<String> selectedScreenId = RxString('');
  Rx<String> selectedScreenRoute = RxString('/home');
  Rx<String> selectedScreenDescription = RxString('');
  RxString userName = RxString('');
  RxString userEmail = RxString('');
  RxString userJoiningDate = RxString('');
  RxString userExpiryDate = RxString('');
  RxString companyId = RxString('');
  RxBool errorLoading = RxBool(false);
  RxString companyImageURL = RxString('');
  RxString companyName = RxString('');
  RxDouble menuWidth = RxDouble(250);
  RxString userId = RxString('');
  MyTreeNode? previouslySelectedNode;
  RxBool isHovered = RxBool(false);
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;
  final secureStorage = const FlutterSecureStorage();
  Helpers helper = Helpers();

  @override
  void onInit() async {
    connectWebSocket();
    getCompanyDetails();
    getFavoriteScreens();
    getScreens();
    super.onInit();
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "favourite_added":
          final newfav = FavouriteScreensModel.fromJson(message["data"]);
          favoriteScreens.insert(0, newfav);
          break;

        case "favourite_deleted":
          final deletedId = message["data"]["_id"];
          favoriteScreens.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  // this function is to get company details
  Future<void> getCompanyDetails() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';

      var url = Uri.parse('$backendUrl/companies/get_user_and_company_details');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded["data"];
        userName.value = data['user_name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userJoiningDate.value = data['createdAt'] ?? '';
        userExpiryDate.value = data['expiry_date'] ?? '';
        companyImageURL.value = data['company_logo'] ?? '';
        companyName.value = data['company_name'] ?? '';
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCompanyDetails();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      getCompanyDetails();
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
        return const SizedBox(child: FirstMainScreen());
      case '/users':
        return const SizedBox(child: Users());
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
        return const SizedBox(child: JobCard());
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
      case '/jobTasks':
        return const SizedBox(child: JobTasks());
      case '/employeePerformance':
        return const SizedBox(child: EmployeePerformance());
      case '/companyVariables':
        return const SizedBox(child: CompanyVariables());
      case '/receiving':
        return const SizedBox(child: Receiving());
      case '/inventeryItems':
        return const SizedBox(child: InventeryItems());
      case '/issueItems':
        return const SizedBox(child: IssueItems());
      case '/carTradingDashboard':
        return const SizedBox(child: CarTradingDashboard());
      default:
        return const SizedBox(child: Center(child: Text('Screen not found')));
    }
  }

  // this function is to get the name of the screen of the right side of the main screen
  Text getScreenName(String name) {
    return Text(name, style: fontStyleForAppBar);
  }

  MyTreeNode buildTreeFromJson(
    Map<String, dynamic> json, {
    bool isRoot = false,
  }) {
    final childrenJson = json['children'] as List<dynamic>? ?? [];

    // تحويل كل طفل recursively
    final childrenNodes = childrenJson
        .map<MyTreeNode>((childJson) => buildTreeFromJson(childJson))
        .toList();

    return MyTreeNode(
      id: json['_id'],
      title: json['name'] ?? '',
      isMenu: json['isMenu'],
      children: childrenNodes,
      routeName: json["route_name"],
    );
  }

  Future<void> getScreens() async {
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/menus/get_user_menu_tree');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List data = decoded["root"];
        roots.value = data
            .map<MyTreeNode>((item) => buildTreeFromJson(item, isRoot: true))
            .toList();
        treeController = TreeController<MyTreeNode>(
          roots: roots,
          childrenProvider: (node) => node.children,
          parentProvider: (node) => node.parent,
        );

        isLoading.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getScreens();
        } else if (refreshed == RefreshResult.invalidToken) {
          isLoading.value = false;

          logout();
        } else {
          isLoading.value = false;
        }
      } else if (response.statusCode == 401) {
        isLoading.value = false;
        logout();
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      errorLoading.value = true;
    }
  }

  // init the tree
  void init() {
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

  Future<void> getFavoriteScreens() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/favourite_screens/get_favourite_screens',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> favs = decoded["favourites"] ?? [];
        favoriteScreens.assignAll(
          favs
              .map((country) => FavouriteScreensModel.fromJson(country))
              .toList(),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getFavoriteScreens();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      //
    }
  }

  Future<void> addScreenToFavorite() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/favourite_screens/add_screen_to_favourites',
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"screen_id": selectedScreenId.value}),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addScreenToFavorite();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try agian');
    }
  }

  Future<void> removeScreenFromFavorite(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/favourite_screens/remove_screen_from_favourites/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await removeScreenFromFavorite(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      //
    }
  }
}
