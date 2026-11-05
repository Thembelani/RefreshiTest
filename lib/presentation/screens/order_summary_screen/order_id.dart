part of 'order_summary_screen.dart';

class _OrderId extends StatelessWidget {
  const _OrderId({required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    return Text(
      'Order #$id',
      key: const Key('order-id'),
      style: type.titleMedium.copyWith(color: colors.onBackground),
    );
  }
}
