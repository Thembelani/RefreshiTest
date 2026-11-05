part of 'checkout_screen.dart';

class _CardDetails extends StatelessWidget {
  const _CardDetails({this.scroll = true});

  final bool scroll;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final titleStyle = type.bodyMedium.copyWith(color: colors.onSurface);
    final valueStyle = type.bodyLarge.copyWith(color: colors.onBackground);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.onSurface.withValues(alpha: 0.28)),
    );

    TableRow row(String title, Widget value, {bool last = false}) {
      final padding = EdgeInsets.only(bottom: last ? 0 : 12);
      return TableRow(
        children: [
          Padding(
            padding: padding.copyWith(right: 16),
            child: Text(title, style: titleStyle),
          ),
          Padding(padding: padding, child: value),
        ],
      );
    }

    final content = Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        row('Card', Text('Visa ending 4242', style: valueStyle)),
        row('Expires', Text('12/28', style: valueStyle)),
        row(
          'CVV',
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 72,
              child: TextField(
                key: const Key('card-cvv-field'),
                style: valueStyle,
                cursorColor: colors.primary,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  hintText: '123',
                  hintStyle: type.bodyMedium.copyWith(color: colors.onSurface),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.primary),
                  ),
                ),
              ),
            ),
          ),
          last: true,
        ),
      ],
    );

    if (!scroll) {
      return content;
    }

    return SingleChildScrollView(child: content);
  }
}
