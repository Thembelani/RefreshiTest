part of 'order_summary_screen.dart';

class _HoldStatus extends StatelessWidget {
  const _HoldStatus({required this.fulfilled});

  final bool fulfilled;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final label = fulfilled ? 'Fulfilled' : 'Pending';

    return DecoratedBox(
      key: const Key('hold-status'),
      decoration: BoxDecoration(
        color: fulfilled
            ? colors.primary.withValues(alpha: 0.12)
            : colors.surface,
        borderRadius: borderRadiusMedium,
        border: Border.all(
          color: fulfilled
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: type.labelLarge.copyWith(
            color: fulfilled ? colors.primary : colors.onSurface,
          ),
        ),
      ),
    );
  }
}
