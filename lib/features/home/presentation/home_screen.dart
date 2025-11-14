import 'package:flutter/material.dart';
import '../domain/menu_repository.dart';
import 'package:flutter_application_1/core/widgets/icons.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'widgets/bounce_dice_widget.dart';
import 'widgets/dice_roll_animation.dart';
import 'widgets/result_modal.dart';

/// 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  // 주사위 던지기 애니메이션
  late AnimationController _diceRollController;
  late Animation<double> _diceRollAnimation;
  bool _isRolling = false;
  bool _showModal = false;
  String? _selectedMenu;

  @override
  void initState() {
    super.initState();
    // Tailwind CSS animate-bounce와 동일: 1초 duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 애니메이션 값 (0.0 ~ 1.0)
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    // 애니메이션 시작 (모든 초기화 완료 후)
    _animationController.repeat();

    // 주사위 던지기 애니메이션
    _diceRollController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _diceRollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _diceRollController, curve: Curves.easeOut),
    );

    _diceRollController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isRolling = false;
          _showModal = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _diceRollController.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_isRolling) return;

    // 랜덤 메뉴 선택
    final selectedMenu = MenuRepository.selectRandomMenu();

    setState(() {
      _isRolling = true;
      _showModal = false;
      _selectedMenu = selectedMenu;
    });

    _diceRollController.reset();
    _diceRollController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // 상단 헤더
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        '오늘 뭐 먹지?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                          letterSpacing: 0.07,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '주사위를 던져 오늘의 메뉴를 골라보세요',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondary,
                          letterSpacing: -0.31,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // 메인 컨텐츠 영역
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 통통 튀는 주사위 아이콘 (던지기 중이 아닐 때만 표시)
                        if (!_isRolling)
                          BounceDiceWidget(animation: _bounceAnimation),

                        const SizedBox(height: 67.5),

                        // 설명 텍스트
                        const Text(
                          '주사위를 던져보세요!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                            letterSpacing: -0.31,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '100가지 이상의 음식 중 랜덤으로 추천해드려요',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                            letterSpacing: -0.15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // 주사위 던지기 버튼
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 68,
                    child: ElevatedButton(
                      onPressed: _rollDice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const DiceIcon(size: 24, color: Colors.white),
                          const SizedBox(width: 12),
                          const Text(
                            '주사위 던지기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              letterSpacing: -0.44,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 탭바
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.borderColor, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                // 탭 전환 로직
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: AppTheme.textSecondary,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: [
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(1000000),
                        ),
                      ),
                      const SizedBox(height: 4.4),
                      const HomeIcon(size: 26.4, color: AppTheme.primaryColor),
                    ],
                  ),
                  label: '홈',
                ),
                const BottomNavigationBarItem(
                  icon: MapIcon(size: 24, color: AppTheme.textSecondary),
                  label: '지도',
                ),
                const BottomNavigationBarItem(
                  icon: PersonIcon(size: 24, color: AppTheme.textSecondary),
                  label: '내정보',
                ),
              ],
            ),
          ),
        ),

        // 주사위 던지기 애니메이션
        if (_isRolling) DiceRollAnimation(animation: _diceRollAnimation),

        // 결과 모달 (하단에 붙어있는 bottom sheet)
        if (_showModal && _selectedMenu != null)
          ResultModal(
            menu: _selectedMenu!,
            onFindNearby: () {
              setState(() {
                _showModal = false;
              });
              // TODO: 근처 음식점 찾기 (지도 화면으로 이동)
            },
            onReroll: () {
              setState(() {
                _showModal = false;
              });
              // 애니메이션 완료 후 주사위 던지기
              Future.delayed(const Duration(milliseconds: 300), () {
                _rollDice();
              });
            },
            onClose: () {
              setState(() {
                _showModal = false;
              });
            },
          ),
      ],
    );
  }
}
