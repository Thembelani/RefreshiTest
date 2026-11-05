import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/domain/entities/delivery_time.dart';

part 'delivery_time_scroller.dart';

class DeliveryTimeCard extends StatelessWidget {
  const DeliveryTimeCard({
    required this.slot,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final DeliveryTimeEntity slot;
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
