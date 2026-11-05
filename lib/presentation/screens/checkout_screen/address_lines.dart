part of 'checkout_screen.dart';

class _AddressLines extends StatelessWidget {
  const _AddressLines({required this.lines, this.scroll = true});

  final List<String> lines;
  final bool scroll;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          Text(
            lines[i],
            style: type.bodyLarge.copyWith(color: colors.onSurface),
          ),
        ],
      ],
    );

    if (!scroll) {
      return content;
    }

    return SingleChildScrollView(child: content);
  }
}
