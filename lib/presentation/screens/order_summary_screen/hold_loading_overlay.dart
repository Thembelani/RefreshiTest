part of 'order_summary_screen.dart';

class _HoldLoadingOverlay extends StatelessWidget {
  const _HoldLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Stack(
      key: const Key('hold-loading-overlay'),
      children: [
        ModalBarrier(
          color: colors.onBackground.withValues(alpha: 0.32),
          dismissible: false,
        ),
        Center(
          child: CircularProgressIndicator(color: colors.primary),
        ),
      ],
    );
  }
}
