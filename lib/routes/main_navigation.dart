import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../screens/inorder_screen.dart';
import '../screens/indelivery_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    InOrderScreen(), 
    InDeliveryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt_outlined),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.delivery_dining_outlined),
      label: 'In Delivery',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 350),
        reverse: false,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: List.generate(_navItems.length, (index) {
            final isSelected = _selectedIndex == index;
            final item = _navItems[index];
            return BottomNavigationBarItem(
              label: item.label,
              icon: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isSelected ? 1.0 : 0.9,
                  end: isSelected ? 1.2 : 1.0,
                ),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                builder:
                    (context, value, child) => Transform.scale(
                      scale: value,
                      child: Icon(
                        (item.icon as Icon).icon,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                      ),
                    ),
              ),
            );
          }),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
