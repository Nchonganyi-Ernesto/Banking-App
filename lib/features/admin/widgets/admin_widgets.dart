import 'package:flutter/material.dart';

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