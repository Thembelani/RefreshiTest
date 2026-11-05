part of 'order_summary_screen.dart';

class _HoldTimeline extends StatelessWidget {
  const _HoldTimeline({
    required this.createdAt,
    required this.fulfilled,
    this.fulfilledAt,
  });

  final DateTime createdAt;
  final bool fulfilled;
  final DateTime? fulfilledAt;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final labelStyle = type.bodyMedium.copyWith(color: colors.onSurface);
    final valueStyle = type.bodyLarge.copyWith(color: colors.onBackground);

    return Column(
      key: const Key('hold-timeline'),
      children: [
        Row(
          children: [
            _dot(colors, complete: true),
            Expanded(
              child: Container(
                height: 2,
                color: fulfilled
                    ? colors.primary
                    : colors.onSurface.withValues(alpha: 0.28),
              ),
            ),
            _dot(colors, complete: fulfilled),
          ],
        ),
        hSpacer8,
        Row(
          children: [
            Expanded(
              child: Text('Created', style: labelStyle),
            ),
            Expanded(
              child: Text(
                'Fulfilled',
                textAlign: TextAlign.right,
                style: labelStyle,
              ),
            ),
          ],
        ),
        hSpacer4,
        Row(
          children: [
            Expanded(
              child: Text(_formatOrderDate(createdAt), style: valueStyle),
            ),
            Expanded(
              child: Text(
                fulfilledAt == null
                    ? 'Pending'
                    : _formatOrderDate(fulfilledAt!),
                textAlign: TextAlign.right,
                style: valueStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dot(AppColorsThemeExtension colors, {required bool complete}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: complete ? colors.primary : colors.background,
        border: Border.all(
          color: complete
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.28),
          width: 2,
        ),
      ),
    );
  }
}
