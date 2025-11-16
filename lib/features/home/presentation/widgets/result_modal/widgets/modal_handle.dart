import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/result_modal_constants.dart';

/// 모달 상단 Handle 위젯
class ModalHandle extends StatelessWidget {
  const ModalHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ResultModalConstants.handleTopPadding,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: ResultModalConstants.handleWidth,
          height: ResultModalConstants.handleHeight,
          decoration: BoxDecoration(
            color: ResultModalConstants.handleColor,
            borderRadius: BorderRadius.circular(
              ResultModalConstants.handleBorderRadius,
            ),
          ),
        ),
      ),
    );
  }
}

