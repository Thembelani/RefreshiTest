part of 'delivery_time_card.dart';

class DeliveryTimeScroller extends StatelessWidget {
  const DeliveryTimeScroller({
    required this.times,
    required this.selectedId,
    required this.onSelected,
    this.expand = true,
    super.key,
  });

  final List<DeliveryTimeEntity> times;
  final int? selectedId;
  final ValueChanged<int> onSelected;
  final bool expand;

  static const _cardWidth = 148.0;
  static const _gap = 12.0;
  static const _stackedHeight = 104.0;

  @override
  Widget build(BuildContext context) {
    final scroller = ListView.separated(
      key: const Key('delivery-time-scroller'),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      itemCount: times.length,
      separatorBuilder: (context, index) => const SizedBox(width: _gap),
      itemBuilder: (context, index) {
        final slot = times[index];
        return SizedBox(
          width: _cardWidth,
          child: DeliveryTimeCard(
            slot: slot,
            selected: selectedId == slot.id,
            onTap: () => onSelected(slot.id),
          ),
        );
      },
    );

    if (expand) {
      return scroller;
    }

    return SizedBox(height: _stackedHeight, child: scroller);
  }
}
