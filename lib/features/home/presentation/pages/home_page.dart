// lib/features/home/presentation/pages/home_page.dart

import 'package:app_v1/core/constants/app_colors.dart';

import 'package:app_v1/core/routes/routes.dart';
import 'package:app_v1/core/services/storage_service.dart';
import 'package:app_v1/features/auth/data/models/auth_response.dart';
import 'package:app_v1/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _lastBackPress;
  bool _isLoading = true;
  AccountInfo? _accountInfo;
  String? _errorMessage;

  late final AuthService _authService;
  late final StorageService _storageService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _initializeHome();
  }

  Future<void> _initializeHome() async {
    _storageService = await StorageService.getInstance();
    await _loadAccountInfo();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  Future<void> _loadAccountInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get auth data from arguments or storage
      final args = ModalRoute.of(context)?.settings.arguments as AuthResponse?;

      final accessToken = args?.accessToken ?? _storageService.getAccessToken();
      final accountId = args?.accountId ?? _storageService.getAccountId();

      if (accessToken == null || accountId == null) {
        throw ApiError(message: 'No authentication data found');
      }

      // Fetch account info
      final accountInfo = await _authService.getAccountInfo(
        accessToken: accessToken,
        accountId: accountId,
      );

      setState(() {
        _accountInfo = accountInfo;
        _isLoading = false;
      });
    } on ApiError catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });

      if (e.message.contains('authenticate') || e.message.contains('token')) {
        _handleLogout();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load account info: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      final accessToken = _storageService.getAccessToken();
      final accountId = _storageService.getAccountId();

      if (accessToken != null && accountId != null) {
        await _authService.disableAccessToken(
          accessToken: accessToken,
          accountId: accountId,
        );
      }
    } catch (e) {
      // Silent fail, we're logging out anyway
    }

    await _storageService.clearAuthData();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    const maxDuration = Duration(seconds: 2);
    final isWarning =
        _lastBackPress == null || now.difference(_lastBackPress!) > maxDuration;

    if (isWarning) {
      _lastBackPress = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return false;
    }

    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rediafile'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? _buildErrorView()
                : _buildAccountInfoView(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadAccountInfo,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoView() {
    if (_accountInfo == null) {
      return const Center(child: Text('No account data'));
    }

    return RefreshIndicator(
      onRefresh: _loadAccountInfo,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _accountInfo!.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _accountInfo!.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${_accountInfo!.username}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Account Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.email_outlined,
                      'Email',
                      _accountInfo!.email,
                    ),
                    _buildInfoRow(
                      Icons.badge_outlined,
                      'User ID',
                      _accountInfo!.id.toString(),
                    ),
                    _buildInfoRow(
                      Icons.verified_user_outlined,
                      'Status',
                      _accountInfo!.status.toUpperCase(),
                      valueColor:
                          _accountInfo!.status == 'active'
                              ? Colors.green
                              : Colors.orange,
                    ),
                    if (_accountInfo!.lastLoginDate != null)
                      _buildInfoRow(
                        Icons.access_time_outlined,
                        'Last Login',
                        _accountInfo!.lastLoginDate!,
                      ),
                    if (_accountInfo!.lastLoginIp != null)
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        'Last IP',
                        _accountInfo!.lastLoginIp!,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.upload_file,
                    label: 'Upload',
                    onPressed: () {
                      // TODO: Implement upload
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload feature coming soon'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.folder_outlined,
                    label: 'Files',
                    onPressed: () {
                      // TODO: Implement file browsing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('File browser coming soon'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        foregroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
