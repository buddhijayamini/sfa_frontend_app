class NavDrawerState {
  final NavItem selectedItem;

  const NavDrawerState(this.selectedItem);
}

enum NavItem {
  homePage,
  salePage,
  prodList,
  routePlan,
  exeSummery,
  adminPage,
  logout
}
