part of 'order_summary_screen.dart';

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final titleStyle = type.bodyMedium.copyWith(color: colors.onSurface);
    final valueStyle = type.bodyLarge.copyWith(color: colors.onBackground);

    TableRow detailRow(String title, String value, {bool last = false}) {
      final padding = EdgeInsets.only(bottom: last ? 0 : 12);
      return TableRow(
        children: [
          Padding(
            padding: padding.copyWith(right: 16),
            child: Text(title, style: titleStyle),
          ),
          Padding(
            padding: padding,
            child: Text(value, style: valueStyle),
          ),
        ],
      );
    }

    return CheckoutPane(
      title: 'Details',
      expand: false,
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          detailRow('Address', address),
          detailRow('Card', 'Visa ending 4242', last: true),
        ],
      ),
    );
  }
}
