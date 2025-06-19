import 'package:flutter/material.dart';
import 'package:walkthrux/src/core/models/showcase_config.dart';
import 'package:walkthrux/src/core/models/tooltip_config.dart';

class TooltipWidget extends StatefulWidget {
  final ShowcaseConfig showcaseConfig;
  final TooltipConfig tooltipConfig;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onSkip;
  final bool showPrevious;
  final bool showNext;
  final bool showSkip;
  final int currentStep;
  final int totalSteps;

  const TooltipWidget({
    Key? key,
    required this.showcaseConfig,
    required this.tooltipConfig,
    this.onNext,
    this.onPrevious,
    this.onSkip,
    this.showPrevious = false,
    this.showNext = true,
    this.showSkip = true,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  State<TooltipWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _progressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: widget.tooltipConfig.animationDuration,
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.elasticOut),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentStep / widget.totalSteps,
    ).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _entryController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildTooltipContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTooltipContent() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: widget.tooltipConfig.maxWidth,
        minWidth: widget.tooltipConfig.minWidth,
      ),
      decoration: BoxDecoration(
        color: widget.tooltipConfig.backgroundColor,
        gradient: widget.tooltipConfig.backgroundGradient,
        borderRadius: BorderRadius.circular(widget.tooltipConfig.borderRadius),
        boxShadow:
            widget.tooltipConfig.shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
            ],
        border: widget.tooltipConfig.border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.tooltipConfig.borderRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.tooltipConfig.showProgress) _buildProgressHeader(),
            Padding(
              padding: widget.tooltipConfig.padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildDescription(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: widget.tooltipConfig.textColor.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.tooltipConfig.borderRadius),
        ),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progressAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.tooltipConfig.progressColor,
                    widget.tooltipConfig.progressColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(widget.tooltipConfig.borderRadius),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (widget.tooltipConfig.leadingIcon != null) ...[
          widget.tooltipConfig.leadingIcon!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            widget.showcaseConfig.title,
            style:
                widget.tooltipConfig.titleStyle ??
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.tooltipConfig.textColor,
                  height: 1.3,
                ),
          ),
        ),
        if (widget.tooltipConfig.trailingIcon != null) ...[
          const SizedBox(width: 12),
          widget.tooltipConfig.trailingIcon!,
        ],
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.showcaseConfig.description,
      style:
          widget.tooltipConfig.descriptionStyle ??
          TextStyle(
            fontSize: 14,
            color: widget.tooltipConfig.textColor.withOpacity(0.8),
            height: 1.5,
          ),
    );
  }

  Widget _buildActionButtons() {
    if (widget.tooltipConfig.actionButtons != null) {
      return Wrap(
        spacing: 12,
        runSpacing: 8,
        children: widget.tooltipConfig.actionButtons!,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side actions
        Row(
          children: [
            if (widget.showSkip)
              TextButton(
                onPressed: widget.onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: widget.tooltipConfig.textColor.withOpacity(
                    0.6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Skip'),
              ),
          ],
        ),

        // Right side actions
        Row(
          children: [
            Text(
              '${widget.currentStep} of ${widget.totalSteps}',
              style: TextStyle(
                fontSize: 12,
                color: widget.tooltipConfig.textColor.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            if (widget.showPrevious)
              IconButton(
                onPressed: widget.onPrevious,
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                style: IconButton.styleFrom(
                  foregroundColor: widget.tooltipConfig.textColor,
                  backgroundColor: widget.tooltipConfig.textColor.withOpacity(
                    0.1,
                  ),
                  minimumSize: const Size(40, 40),
                ),
              ),
            if (widget.showPrevious) const SizedBox(width: 8),
            if (widget.showNext)
              ElevatedButton.icon(
                onPressed: widget.onNext,
                icon: Icon(
                  widget.currentStep == widget.totalSteps
                      ? Icons.check
                      : Icons.arrow_forward_ios,
                  size: 16,
                ),
                label: Text(
                  widget.currentStep == widget.totalSteps ? 'Finish' : 'Next',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.tooltipConfig.progressColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
