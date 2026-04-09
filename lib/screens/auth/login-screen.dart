import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/providers/auth_provider.dart';
import 'package:jolu_trip/widgets/auth/auth_button.dart';
import 'package:jolu_trip/widgets/auth/auth_field.dart';
import 'package:jolu_trip/widgets/auth/auth_header.dart';
import 'package:jolu_trip/widgets/auth/auth_toggle.dart';
import 'package:jolu_trip/widgets/auth/social_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _formAnimation;

  // Form state
  bool _isLogin = true;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // Focus nodes
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey('mode')) {
      final mode = args['mode'];
      if (mode == 'register' && _isLogin) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _toggleMode();
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);
    setState(() => _errorMessage = null);

    try {
      if (_isLogin) {
        await ref.read(signInWithEmailProvider(
                (emailController.text.trim(), passwordController.text.trim()))
            .future);
      } else {
        await ref.read(signUpWithEmailProvider(
                (emailController.text.trim(), passwordController.text.trim()))
            .future);
        // Update profile if name provided
        if (nameController.text.trim().isNotEmpty) {
          // Note: Profile update would need a separate provider, for now just sign up
        }
      }
      if (mounted) _navigateToProfile();
    } catch (e) {
      _handleAuthError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    setState(() => _errorMessage = null);

    try {
      await ref.read(signInWithGoogleProvider.future);
      if (mounted) _navigateToProfile();
    } catch (e) {
      setState(() => _errorMessage = 'Не удалось войти через Google');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToProfile() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/profile');
      }
    });
  }

  void _toggleMode() {
    _animationController.reset();
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
      _clearControllers();
    });
    _animationController.forward();
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }

  bool _validateInputs() {
    if (emailController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Введите email');
      return false;
    }
    if (passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Пароль минимум 6 символов');
      return false;
    }
    if (!_isLogin && nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Введите имя');
      return false;
    }
    return true;
  }

  void _handleAuthError(dynamic e) {
    final errorString = e.toString();
    final errorMap = {
      'user-not-found': 'Пользователь не найден',
      'wrong-password': 'Неверный пароль',
      'email-already-in-use': 'Email уже используется',
      'weak-password': 'Слабый пароль',
      'network-request-failed': 'Ошибка сети',
      'invalid-email': 'Неверный email',
      'user-disabled': 'Аккаунт заблокирован',
      'too-many-requests': 'Слишком много попыток',
    };

    for (final entry in errorMap.entries) {
      if (errorString.contains(entry.key)) {
        setState(() => _errorMessage = entry.value);
        return;
      }
    }
    setState(
        () => _errorMessage = _isLogin ? 'Ошибка входа' : 'Ошибка регистрации');
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.black,
              Colors.grey.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: AppDimens.screenPadding,
                child: Column(
                  children: [
                    AuthHeader(
                      scaleAnimation: _scaleAnimation,
                      formAnimation: _formAnimation,
                    ),
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            AuthToggle(
                              isLogin: _isLogin,
                              onToggle: _toggleMode,
                              formAnimation: _formAnimation,
                            ),
                            const SizedBox(height: AppDimens.spaceL),
                            if (_errorMessage != null)
                              _buildErrorWidget(_errorMessage!),
                            if (!_isLogin) ...[
                              AuthField(
                                controller: nameController,
                                focusNode: nameFocus,
                                nextFocus: emailFocus,
                                label: 'Имя',
                                icon: Icons.person_outline,
                                formAnimation: _formAnimation,
                                isLoading: _isLoading,
                              ),
                              const SizedBox(height: AppDimens.spaceM),
                            ],
                            AuthField(
                              controller: emailController,
                              focusNode: emailFocus,
                              nextFocus: passwordFocus,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              formAnimation: _formAnimation,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: AppDimens.spaceM),
                            AuthField(
                              controller: passwordController,
                              focusNode: passwordFocus,
                              label: 'Пароль',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              onToggleVisibility: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              formAnimation: _formAnimation,
                              isLoading: _isLoading,
                              onSubmitted: _submit,
                            ),
                            const SizedBox(height: AppDimens.spaceL),
                            AuthButton(
                              isLogin: _isLogin,
                              isLoading: _isLoading,
                              onPressed: _submit,
                              formAnimation: _formAnimation,
                            ),
                            const SizedBox(height: AppDimens.spaceL),
                            _buildDivider(),
                            const SizedBox(height: AppDimens.spaceL),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SocialButton(
                                  icon: Icons.g_mobiledata,
                                  onPressed: _signInWithGoogle,
                                  label: 'Google',
                                  formAnimation: _formAnimation,
                                ),
                                const SizedBox(width: AppDimens.spaceM),
                                SocialButton(
                                  icon: Icons.apple,
                                  onPressed: () {},
                                  label: 'Apple',
                                  formAnimation: _formAnimation,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimens.spaceXL),
                            FadeTransition(
                              opacity: _formAnimation,
                              child: Text(
                                'Продолжая, вы соглашаетесь с условиями использования',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceM),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return FadeTransition(
      opacity: _formAnimation,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceS),
        margin: const EdgeInsets.only(bottom: AppDimens.spaceM),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          border: Border.all(color: AppColors.error, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline,
                color: AppColors.error, size: AppDimens.iconSizeS),
            const SizedBox(width: AppDimens.spaceXS),
            Expanded(
              child: Text(
                message,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return FadeTransition(
      opacity: _formAnimation,
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceM),
            child: Text(
              'или',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
        ],
      ),
    );
  }
}
