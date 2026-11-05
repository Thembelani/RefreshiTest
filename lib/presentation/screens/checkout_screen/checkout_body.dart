part of 'checkout_screen.dart';

class _CheckoutBody extends StatelessWidget {
  const _CheckoutBody({
    required this.stacked,
    required this.items,
    required this.catalogItems,
    required this.addressLines,
    required this.deliveryTimes,
    required this.selectedDeliveryTimeId,
    required this.canComplete,
  });

  final bool stacked;
  final List<CartItemEntity> items;
  final List<CatalogItemEntity> catalogItems;
  final List<String> addressLines;
  final List<DeliveryTimeEntity> deliveryTimes;
  final int? selectedDeliveryTimeId;
  final bool canComplete;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    final address = CheckoutPane(
      key: const Key('checkout-left-top-start'),
      title: 'Address',
      expand: !stacked,
      child: _AddressLines(
        scroll: !stacked,
        lines: addressLines,
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
      child: DeliveryTimeScroller(
        expand: !stacked,
        times: deliveryTimes,
        selectedId: selectedDeliveryTimeId,
        onSelected: (id) => context.read<CartBloc>().add(
              CartEvent.selectDeliveryTime(deliveryTimeId: id),
            ),
      ),
    );
    final cart = CartPanel(
      items: items,
      catalogItems: catalogItems,
      expand: !stacked,
      onRemove: (item) => context.read<CartBloc>().add(
            CartEvent.removeCartItem(cartItemId: item.id),
          ),
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
      onPressed: canComplete
          ? () => context.read<CartBloc>().add(const CartEvent.placeOrder())
          : null,
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
