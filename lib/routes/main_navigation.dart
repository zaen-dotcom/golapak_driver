import 'package:flutter/material.dart';
import '../screens/indelivery_screen.dart';
import '../screens/inorder_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    InOrderScreen(),
    InDeliveryScreen(),
    ProfileScreen(),
  ];

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
      label: 'In Order',
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(_selectedIndex),
          index: _selectedIndex,
          children: _screens,
        ),
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
