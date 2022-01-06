import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gold_price/controller/bottom_nav_controller.dart';
import 'package:gold_price/controller/gold_shop_controller.dart';
import 'package:gold_price/model/gold.dart';
import 'package:gold_price/util/common_util.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:provider/provider.dart';

class GoldEditorPage extends StatefulWidget {
  GoldEditorPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  _GoldEditorPageState createState() => _GoldEditorPageState();
}

class _GoldEditorPageState extends State<GoldEditorPage> {
  final TextEditingController _shopNameTextController = TextEditingController();
  final TextEditingController _sixteenPrcTextController =
      TextEditingController();
  final TextEditingController _fifteenPrcTextController =
      TextEditingController();
  final TextEditingController _phoneNoTextController = TextEditingController();
  final TextEditingController _facebookTextController = TextEditingController();
  final TextEditingController _websiteTextController = TextEditingController();
  final TextEditingController _createdDateTextController =
      TextEditingController();
  final TextEditingController _modifiedDateTextController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    CommonUtil.doInFuture(() {
      Gold gold = context.read<GoldShopController>().currentEditGold;
      _shopNameTextController.text = gold.name;
      _sixteenPrcTextController.text = gold.sixteenPrice;
      _fifteenPrcTextController.text = gold.fifteenPrice;
      _phoneNoTextController.text = gold.phoneNo;
      _facebookTextController.text = gold.facebook;
      _websiteTextController.text = gold.website;
      _createdDateTextController.text = gold.createdDate;
      _modifiedDateTextController.text = gold.modifiedDate;
    });
    return SafeArea(
        child: WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        // appBar: appBar(context),
        body: _mainBody(),
      ),
    ));
  }

  Widget _getAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.grey,
      leading: Consumer<GoldShopController>(
        builder: (_, controller, __) => IconButton(
          onPressed: () {
            if (controller.currentEditGold.name.isNotEmpty) {
              controller.currentEditGold = controller.newGold;
              Navigator.pop(context, "Backbutton data");
            } else {
              controller.currentEditGold = controller.newGold;
              context.read<BottomNavController>().selectedIndex = 0;
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      title: Consumer<GoldShopController>(
        builder: (_, controller, __) => Text(
            (controller.currentEditGold.name.isNotEmpty ? 'Edit' : 'Add') +
                ' Gold Shop'),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black12.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child:
              // Stack(
              //   children: [
              Consumer<GoldShopController>(
            builder: (_, controller, __) => Image.network(
              controller.currentEditGold.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => SizedBox(
                width: ScreenSizeUtil.getScreenWidth(context),
                child: Image.asset(
                  'assets/images/4.jpg',
                  color: Colors.grey.withOpacity(0.5),
                  colorBlendMode: BlendMode.srcOver,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 10,
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.add_a_photo,
          //       size: 35,
          //     ),
          //     onPressed: () {},
          //   ),
          // )
          // ],
          // ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: SpeedDial(
            backgroundColor: Colors.transparent,
            overlayColor: Colors.transparent,
            overlayOpacity: 0.2,
            elevation: 0,
            childrenButtonSize: const Size(50, 50),
            child: const Icon(Icons.menu, size: 27),
            direction: SpeedDialDirection.down,
            children: <SpeedDialChild>[
              SpeedDialChild(
                  child: const Icon(
                    Icons.check,
                    color: Colors.red,
                    size: 33,
                  ),
                  onTap: () {
                    // todo
                  }),
              SpeedDialChild(
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 33,
                ),
              ),
              SpeedDialChild(
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.blueGrey,
                  size: 33,
                ),
              ),
            ],
          ),
        )
        // IconButton(
        //   padding: const EdgeInsets.only(right: 15),
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.check_circle_outline,
        //     color: Colors.grey.shade800,
        //     size: 35,
        //   ),
        // ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: Consumer<GoldShopController>(
        builder: (_, controller, __) => IconButton(
          onPressed: () {
            if (controller.currentEditGold.name.isNotEmpty) {
              controller.currentEditGold = controller.newGold;
              Navigator.pop(context, "Backbutton data");
            } else {
              controller.currentEditGold = controller.newGold;
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      title: Consumer<GoldShopController>(
        builder: (_, controller, __) => Text(
            (controller.currentEditGold.name.isNotEmpty ? 'Edit' : 'Add') +
                ' Gold Shop'),
      ),
    );
  }

  Widget _mainBody() {
    return CustomScrollView(
      slivers: <Widget>[
        _getAppBar(),
        SliverToBoxAdapter(
            child: textFormField(
          'Shop Name',
          _shopNameTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Sixteen Gold Price',
          _sixteenPrcTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Fifteen Gold Price',
          _fifteenPrcTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Phone No.',
          _phoneNoTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Facebook',
          _facebookTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Website',
          _websiteTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Created Date',
          _createdDateTextController,
          true,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Modified Date',
          _modifiedDateTextController,
          true,
        )),
      ],
    );
  }

  // Widget mainBody2() {
  //   return SingleChildScrollView(
  //     child: Form(
  //       key: widget._formKey,
  //       child: Column(
  //         children: [
  //           textFormField('Shop Name', _shopNameTextController),
  //           textFormField('Sixteen Gold Price', _sixteenPrcTextController),
  //           textFormField('Fifteen Gold Price', _fifteenPrcTextController),
  //           textFormField('Phone No.', _fifteenPrcTextController),
  //           textFormField('Facebook', _fifteenPrcTextController),
  //           textFormField('Website', _fifteenPrcTextController),
  //           textFormField('Created Date', _fifteenPrcTextController),
  //           textFormField('Modified Date', _fifteenPrcTextController),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget textFormField(
      String title, TextEditingController controller, bool isDate) {
    return Container(
      width: ScreenSizeUtil.getScreenWidth(context) - 16,
      // height: 60,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black, width: 1.0, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(color: Colors.black54),
          ),
          TextField(
            controller: controller,
            readOnly: !isDate,
            decoration: InputDecoration(
              hintText: "Input $title",
              // if you want to remove bottom border that changes color when field gains focus
              // then uncomment the line bellow
              // border: InputBorder.none,
            ),
            onTap: () async {
              if (!isDate) {
                return;
              }
              var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
              controller.text = date.toString().substring(0, 10);
            },
          )
        ],
      ),
    );
  }
}
