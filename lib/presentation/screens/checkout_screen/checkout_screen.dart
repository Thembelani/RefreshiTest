import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/cart_panel.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/delivery_time_card.dart';

const _paneGap = 12.0;
const _screenInset = 24.0;
const _stackBreakpoint = 900.0;

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final List<CartLine> _lines = dummyCartLines();

  void _removeLine(CartLine line) {
    setState(() {
      _lines.removeWhere((item) => item.service.id == line.service.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final lines = _lines;
    final stacked = MediaQuery.sizeOf(context).width < _stackBreakpoint;

    final address = CheckoutPane(
      key: const Key('checkout-left-top-start'),
      title: 'Address',
      expand: !stacked,
      child: _DummyCopy(
        scroll: !stacked,
        lines: const ['12 Long Street', 'Cape Town, 8001'],
      ),
    );
    final card = CheckoutPane(
      key: const Key('checkout-left-top-end'),
      title: 'Card Details',
      expand: !stacked,
      child: _CardDetails(scroll: !stacked),
    );
    final times = CheckoutPane(
      key: const Key('checkout-left-bottom'),
      title: 'Select Delivery Times',
      expand: !stacked,
      child: DeliveryTimeScroller(expand: !stacked),
    );
    final cart = CartPanel(
      lines: lines,
      expand: !stacked,
      onRemove: _removeLine,
    );

    final completeButton = FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.2),
        minimumSize: const Size(230, 52),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: type.labelLarge,
      ),
      onPressed: lines.isEmpty
          ? null
          : () => context.router.push(const OrderSummaryRoute()),
      child: const Text('Complete'),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 72,
        titleSpacing: 24,
        title: Image.asset(
          'assets/images/logo.png',
          key: const Key('checkout-logo'),
          height: 32,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(_screenInset, _screenInset, _screenInset, 0),
        child: stacked
            ? ListView(
                children: [
                  address,
                  const SizedBox(height: _paneGap),
                  card,
                  const SizedBox(height: _paneGap),
                  times,
                  const SizedBox(height: _paneGap),
                  cart,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            key: const Key('checkout-left-top'),
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: address),
                              const SizedBox(width: _paneGap),
                              Expanded(child: card),
                            ],
                          ),
                        ),
                        const SizedBox(height: _paneGap),
                        Expanded(flex: 1, child: times),
                      ],
                    ),
                  ),
                  const SizedBox(width: _paneGap),
                  Expanded(flex: 1, child: cart),
                ],
              ),
      ),
      bottomNavigationBar: Material(
        color: colors.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              _screenInset,
              _paneGap,
              _screenInset,
              _screenInset,
            ),
            child: stacked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [completeButton],
                  )
                : Row(
                    children: [
                      const Expanded(flex: 3, child: SizedBox.shrink()),
                      const SizedBox(width: _paneGap),
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: completeButton,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _DummyCopy extends StatelessWidget {
  const _DummyCopy({required this.lines, this.scroll = true});

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
