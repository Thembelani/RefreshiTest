import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';

class DeliveryTimeSlot {
  const DeliveryTimeSlot({required this.day, required this.time});

  final String day;
  final String time;
}

const _windowHours = <int>[9, 12, 15, 18];

String _formatHour(int hour) {
  final period = hour < 12 ? 'am' : 'pm';
  final display = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$display:00 $period';
}

final deliveryTimeSlots = [
  for (var day = 1; day <= 5; day++)
    for (final hour in _windowHours)
      DeliveryTimeSlot(day: '$day Dec', time: _formatHour(hour)),
];

class DeliveryTimeCard extends StatelessWidget {
  const DeliveryTimeCard({
    required this.slot,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final DeliveryTimeSlot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    return Material(
      color: selected
          ? colors.primary.withValues(alpha: 0.12)
          : colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.28),
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slot.day,
                    style: type.bodyMedium.copyWith(color: colors.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slot.time,
                    style: type.titleMedium.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Positioned(
                top: 6,
                right: 6,
                child: Icon(
                  Icons.check_circle,
                  color: colors.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DeliveryTimeScroller extends StatefulWidget {
  const DeliveryTimeScroller({this.expand = true, super.key});

  final bool expand;

  @override
  State<DeliveryTimeScroller> createState() => _DeliveryTimeScrollerState();
}

class _DeliveryTimeScrollerState extends State<DeliveryTimeScroller> {
  static const _cardWidth = 148.0;
  static const _gap = 12.0;
  static const _stackedHeight = 104.0;

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final scroller = ListView.separated(
      key: const Key('delivery-time-scroller'),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      itemCount: deliveryTimeSlots.length,
      separatorBuilder: (context, index) => const SizedBox(width: _gap),
      itemBuilder: (context, index) {
        return SizedBox(
          width: _cardWidth,
          child: DeliveryTimeCard(
            slot: deliveryTimeSlots[index],
            selected: _selectedIndex == index,
            onTap: () => setState(() => _selectedIndex = index),
          ),
        );
      },
    );

    if (widget.expand) {
      return scroller;
    }

    return SizedBox(height: _stackedHeight, child: scroller);
  }
}
