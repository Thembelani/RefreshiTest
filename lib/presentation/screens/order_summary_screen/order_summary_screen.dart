import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/catalog_item.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/cart_panel.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';

const _paneGap = 12.0;
const _screenInset = 24.0;

@RoutePage()
class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final lines = dummyCartLines();
    final totalCents = lines.fold(0, (total, line) {
      final item = catalogItems.firstWhere((item) => item.id == line.service.id);
      return total + item.priceCents * line.quantity;
    });
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 72,
        titleSpacing: 24,
        title: Image.asset(
          'assets/images/logo.png',
          key: const Key('order-summary-logo'),
          height: 32,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(_screenInset, _screenInset, _screenInset, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order Summary',
              style: type.headlineSmall.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: 16),
            CheckoutPane(
              title: 'Details',
              expand: false,
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  detailRow('Address', '12 Long Street, Cape Town, 8001'),
                  detailRow('Card', 'Visa ending 4242', last: true),
                ],
              ),
            ),
            const SizedBox(height: _paneGap),
            Expanded(
              child: CheckoutPane(
                title: 'Items',
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: lines.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      CartItemCard(line: lines[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: colors.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(_screenInset),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: ${formatRand(totalCents)}',
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: type.titleMedium.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    minimumSize: const Size(230, 52),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: type.labelLarge,
                  ),
                  onPressed: () {
                    context.router.pushAndPopUntil(
                      const LoginRoute(),
                      predicate: (_) => false,
                    );
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
