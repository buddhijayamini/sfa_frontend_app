import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa_frontend_app/bloc/drawer_event.dart';
import 'package:sfa_frontend_app/bloc/nav_drawer_bloc.dart';
import 'package:sfa_frontend_app/bloc/nav_drawer_state.dart';


class AdminNavDrawerWidget extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  
  final List<_NavigationItem> _listItems = [
    _NavigationItem(true, null, null, null),
    _NavigationItem(false, NavItem.homePage, "Daily Route", Icons.add_road_outlined),
    _NavigationItem(false, NavItem.salePage, "Sales Inquiry", Icons.account_balance_wallet), 
    _NavigationItem(false, NavItem.prodList, "Price & Stock", Icons.list_rounded),
    _NavigationItem(false, NavItem.routePlan, "Route Plan", Icons.edit_road_outlined),
    _NavigationItem(false, NavItem.exeSummery, "Executive Summery", Icons.account_balance),
    _NavigationItem(false, NavItem.adminPage, "Admin", Icons.account_circle,),
    _NavigationItem(false, NavItem.logout, "Log Out", Icons.logout,),
  ];

  AdminNavDrawerWidget(this.accountName, this.accountEmail);

  @override
  Widget build(BuildContext context) => Drawer(
          child: Container(
        child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: _listItems.length,
            itemBuilder: (BuildContext context, int index) =>
                BlocBuilder<NavDrawerBloc, NavDrawerState>(
                  builder: (BuildContext context, NavDrawerState state) =>
                      _buildItem(_listItems[index], state),
                )
                ),
      ));

  Widget _buildItem(_NavigationItem data, NavDrawerState state) =>
      data.header ? _makeHeaderItem() : _makeListItem(data, state);

  Widget _makeHeaderItem() =>Container(
    height: 250,
    child: UserAccountsDrawerHeader(
        margin: EdgeInsets.all(10),
        accountName: Text(accountName, style: TextStyle(color: Colors.white,fontSize: 45)),
        accountEmail: Text(accountEmail, style: TextStyle(color: Colors.white,fontSize: 35)),
        decoration: BoxDecoration(color: Colors.teal,borderRadius: BorderRadius.circular(10) ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.tealAccent,
          child: Icon(
            Icons.person,
            size: 65,
          ),
        ),
      ));

  Widget _makeListItem(_NavigationItem data, NavDrawerState state) => Card(
         shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5)),
        borderOnForeground: true,
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Builder(
          builder: (BuildContext context) => ListTile(
            title: Text(
              data.title,
              style: TextStyle(
                fontSize: 35,
                color: data.item == state.selectedItem ? Colors.teal[500] : Colors.teal[400],
              ),
            ),
            leading: Icon(
              data.icon,
              size: 45,
              color: data.item == state.selectedItem ? Colors.indigo[900] : Colors.indigo[400],
            ),
            onTap: () => _handleItemClick(context, data.item),
          ),
        ),
      );
  void _handleItemClick(BuildContext context, NavItem item) {
    BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(item));
    Navigator.pop(context);
  }
}

class _NavigationItem {
  final bool header;
  final NavItem item;
  final String title;
  final IconData icon;

  _NavigationItem(this.header, this.item, this.title, this.icon);
}
