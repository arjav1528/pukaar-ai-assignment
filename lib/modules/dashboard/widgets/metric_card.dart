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
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (onAdd != null)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Add',
                      onPressed: onAdd,
                      icon: Icon(Icons.add_circle_outline, color: accent, size: 22.r),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                valueText,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
