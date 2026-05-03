import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.valueText,
    required this.subtitle,
    required this.accent,
    this.onAdd,
  });

  final String title;
  final String valueText;
  final String subtitle;
  final Color accent;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onAdd,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(
                color: accent,
                child: SizedBox(width: 4.w),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 8.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (onAdd != null)
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Add',
                              onPressed: onAdd,
                              icon: Icon(Icons.add_rounded, color: accent, size: 24.r),
                            ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        valueText,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.25,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
