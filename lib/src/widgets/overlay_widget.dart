import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walkthrux/src/controllers/pro_onboard_controller.dart';
import 'package:walkthrux/src/core/enums/enums.dart';
import 'package:walkthrux/src/core/models/showcase_config.dart';
import 'package:walkthrux/src/core/models/tooltip_config.dart';
import 'package:walkthrux/src/widgets/tooltip_widget.dart';

class OverlayWidget extends StatefulWidget {
  final ShowcaseConfig showcaseConfig;
  final TooltipConfig tooltipConfig;
  final ProOnboarderController controller;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onSkip;
  final bool showPrevious;
  final bool showNext;
  final bool showSkip;

  const OverlayWidget({
    Key? key,
    required this.showcaseConfig,
    required this.tooltipConfig,
    required this.controller,
    this.onNext,
    this.onPrevious,
    this.onSkip,
    this.showPrevious = false,
    this.showNext = true,
    this.showSkip = true,
  }) : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _highlightController;
  late AnimationController _pulseController;
  late Animation<double> _overlayFadeAnimation;
  late Animation<double> _highlightScaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _overlayController = AnimationController(
      duration: widget.showcaseConfig.animationDuration,
      vsync: this,
    );

    _highlightController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _overlayFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeInOut),
    );

    _highlightScaleAnimation = _createHighlightAnimation();
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _overlayController.forward();
    _startHighlightAnimation();
  }

  Animation<double> _createHighlightAnimation() {
    switch (widget.showcaseConfig.highlightBehavior) {
      case HighlightBehavior.pulse:
        return Tween<double>(begin: 1.0, end: 1.08).animate(
          CurvedAnimation(
            parent: _highlightController,
            curve: Curves.easeInOut,
          ),
        );
      case HighlightBehavior.glow:
        return Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _highlightController,
            curve: Curves.easeInOut,
          ),
        );
      case HighlightBehavior.breathe:
        return Tween<double>(begin: 0.95, end: 1.05).animate(
          CurvedAnimation(
            parent: _highlightController,
            curve: Curves.easeInOut,
          ),
        );
      case HighlightBehavior.shimmer:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _highlightController, curve: Curves.linear),
        );
      case HighlightBehavior.ripple:
        return Tween<double>(begin: 1.0, end: 1.2).animate(
          CurvedAnimation(parent: _highlightController, curve: Curves.easeOut),
        );
      case HighlightBehavior.static:
      default:
        return Tween<double>(
          begin: 1.0,
          end: 1.0,
        ).animate(_highlightController);
    }
  }

  void _startHighlightAnimation() {
    if (widget.showcaseConfig.highlightBehavior != HighlightBehavior.static) {
      if (widget.showcaseConfig.highlightBehavior == HighlightBehavior.ripple ||
          widget.showcaseConfig.highlightBehavior ==
              HighlightBehavior.shimmer) {
        _highlightController.repeat();
      } else {
        _highlightController.repeat(reverse: true);
      }
    }

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _highlightController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyEvent,
      child: AnimatedBuilder(
        animation: _overlayFadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _overlayFadeAnimation.value,
            child: _buildOverlay(),
          );
        },
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.showcaseConfig.enableKeyboardNavigation) return;

    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowRight:
        case LogicalKeyboardKey.space:
          widget.onNext?.call();
          break;
        case LogicalKeyboardKey.arrowLeft:
          widget.onPrevious?.call();
          break;
        case LogicalKeyboardKey.escape:
          widget.onSkip?.call();
          break;
      }
    }
  }

  Widget _buildOverlay() {
    return GestureDetector(
      onTap:
          widget.showcaseConfig.dismissOnTapOutside
              ? () => widget.onSkip?.call()
              : null,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent, // Make background transparent
        child: _buildHighlightAndTooltip(),
      ),
    );
  }

  Widget _buildHighlightAndTooltip() {
    final RenderBox? renderBox =
        widget.showcaseConfig.targetKey.currentContext?.findRenderObject()
            as RenderBox?;

    if (renderBox == null) {
      return Center(
        child: TooltipWidget(
          showcaseConfig: widget.showcaseConfig,
          tooltipConfig: widget.tooltipConfig,
          onNext: widget.onNext,
          onPrevious: widget.onPrevious,
          onSkip: widget.onSkip,
          showPrevious: widget.showPrevious,
          showNext: widget.showNext,
          showSkip: widget.showSkip,
          currentStep: widget.controller.currentIndex + 1,
          totalSteps: widget.controller.showcases.length,
        ),
      );
    }

    final targetSize = renderBox.size;
    final targetPosition = renderBox.localToGlobal(Offset.zero);

    return Stack(
      children: [
        // Highlighted area - without cutout overlay
        Positioned(
          left: targetPosition.dx - widget.showcaseConfig.padding.left,
          top: targetPosition.dy - widget.showcaseConfig.padding.top,
          child: _buildHighlight(targetSize),
        ),

        // Tooltip
        _buildTooltip(targetPosition, targetSize),
      ],
    );
  }

  Widget _buildHighlight(Size targetSize) {
    if (widget.showcaseConfig.customHighlight != null) {
      return widget.showcaseConfig.customHighlight!;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_highlightScaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _highlightScaleAnimation.value * _pulseAnimation.value,
          child: Container(
            width: targetSize.width + widget.showcaseConfig.padding.horizontal,
            height: targetSize.height + widget.showcaseConfig.padding.vertical,
            decoration: _getHighlightDecoration(),
          ),
        );
      },
    );
  }

  BoxDecoration _getHighlightDecoration() {
    final highlightColor = widget.showcaseConfig.highlightColor;
    final intensity =
        widget.showcaseConfig.highlightBehavior == HighlightBehavior.glow
            ? _highlightScaleAnimation.value
            : 1.0;

    BoxDecoration decoration;

    switch (widget.showcaseConfig.shape) {
      case ShowcaseShape.circle:
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: highlightColor.withOpacity(0.8), width: 3),
        );
        break;
      case ShowcaseShape.roundedRectangle:
        decoration = BoxDecoration(
          borderRadius:
              widget.showcaseConfig.borderRadius ?? BorderRadius.circular(8),
          border: Border.all(color: highlightColor.withOpacity(0.8), width: 3),
        );
        break;
      case ShowcaseShape.rectangle:
      default:
        decoration = BoxDecoration(
          border: Border.all(color: highlightColor.withOpacity(0.8), width: 3),
        );
        break;
    }

    // Add glow effect for certain behaviors
    if (widget.showcaseConfig.highlightBehavior == HighlightBehavior.glow) {
      decoration = decoration.copyWith(
        boxShadow: [
          BoxShadow(
            color: highlightColor.withOpacity(intensity * 0.6),
            blurRadius: 20 * intensity,
            spreadRadius: 8 * intensity,
          ),
          BoxShadow(
            color: highlightColor.withOpacity(intensity * 0.3),
            blurRadius: 40 * intensity,
            spreadRadius: 16 * intensity,
          ),
        ],
      );
    }

    return decoration;
  }

  Widget _buildTooltip(Offset targetPosition, Size targetSize) {
    final tooltipPosition = _calculateOptimalTooltipPosition(
      targetPosition,
      targetSize,
    );

    return Positioned(
      left: tooltipPosition.dx,
      top: tooltipPosition.dy,
      child: TooltipWidget(
        showcaseConfig: widget.showcaseConfig,
        tooltipConfig: widget.tooltipConfig,
        onNext: widget.onNext,
        onPrevious: widget.onPrevious,
        onSkip: widget.onSkip,
        showPrevious: widget.showPrevious,
        showNext: widget.showNext,
        showSkip: widget.showSkip,
        currentStep: widget.controller.currentIndex + 1,
        totalSteps: widget.controller.showcases.length,
      ),
    );
  }

  Offset _calculateOptimalTooltipPosition(
    Offset targetPosition,
    Size targetSize,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final tooltipWidth = widget.tooltipConfig.maxWidth;
    const tooltipHeight = 200.0;
    const margin = 24.0;

    final targetCenter =
        targetPosition + Offset(targetSize.width / 2, targetSize.height / 2);

    double left = 0;
    double top = 0;

    // Calculate available space in each direction
    final spaceTop = targetPosition.dy;
    final spaceBottom =
        screenSize.height - (targetPosition.dy + targetSize.height);
    final spaceLeft = targetPosition.dx;
    final spaceRight =
        screenSize.width - (targetPosition.dx + targetSize.width);

    switch (widget.showcaseConfig.tooltipPosition) {
      case TooltipPosition.auto:
        // Smart positioning based on available space
        if (spaceBottom > tooltipHeight + margin && spaceBottom >= spaceTop) {
          // Position below
          left = targetCenter.dx - tooltipWidth / 2;
          top = targetPosition.dy + targetSize.height + margin;
        } else if (spaceTop > tooltipHeight + margin) {
          // Position above
          left = targetCenter.dx - tooltipWidth / 2;
          top = targetPosition.dy - tooltipHeight - margin;
        } else if (spaceRight > tooltipWidth + margin &&
            spaceRight >= spaceLeft) {
          // Position right
          left = targetPosition.dx + targetSize.width + margin;
          top = targetCenter.dy - tooltipHeight / 2;
        } else {
          // Position left
          left = targetPosition.dx - tooltipWidth - margin;
          top = targetCenter.dy - tooltipHeight / 2;
        }
        break;

      case TooltipPosition.top:
        left = targetCenter.dx - tooltipWidth / 2;
        top = targetPosition.dy - tooltipHeight - margin;
        break;

      case TooltipPosition.bottom:
        left = targetCenter.dx - tooltipWidth / 2;
        top = targetPosition.dy + targetSize.height + margin;
        break;

      case TooltipPosition.left:
        left = targetPosition.dx - tooltipWidth - margin;
        top = targetCenter.dy - tooltipHeight / 2;
        break;

      case TooltipPosition.right:
        left = targetPosition.dx + targetSize.width + margin;
        top = targetCenter.dy - tooltipHeight / 2;
        break;

      default:
        left = targetCenter.dx - tooltipWidth / 2;
        top = targetPosition.dy + targetSize.height + margin;
        break;
    }

    // Ensure tooltip stays within screen bounds
    left = left.clamp(margin, screenSize.width - tooltipWidth - margin);
    top = top.clamp(margin, screenSize.height - tooltipHeight - margin);

    return Offset(left, top);
  }
}
