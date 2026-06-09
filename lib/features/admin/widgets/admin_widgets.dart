import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../screens/admin_dashboard_screen.dart';

// =============================================================================
// USER MANAGEMENT SECTION
// =============================================================================
class UserManagementSection extends StatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearch;
  final bool isTablet;

  const UserManagementSection({
    super.key,
    required this.searchController,
    required this.se