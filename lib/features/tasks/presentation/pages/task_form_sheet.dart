import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/features/tasks/data/models/task.dart';

class TaskDraft {
  const TaskDraft({
    required this.title,
    required this.note,
    required this.isRepeating,
    required this.hasAlarm,
    required this.alarmMinutes,
  });

  final String title;
  final String? note;
  final bool isRepeating;
  final bool hasAlarm;
  final int? alarmMinutes;
}

class TaskFormSheet extends StatefulWidget {
  const TaskFormSheet({super.key, this.task});

  final Task? task;

  static Future<TaskDraft?> show(BuildContext context, {Task? task}) {
    return showModalBottomSheet<TaskDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskFormSheet(task: task),
    );
  }

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  static const _defaultAlarm = TimeOfDay(hour: 7, minute: 0);

  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late bool _isRepeating;
  late bool _hasAlarm;
  late TimeOfDay _alarmTime;

  bool get _isEditing => widget.task != null;
  bool _showTitleError = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _noteController = TextEditingController(text: task?.note ?? '');
    _isRepeating = task?.isRepeating ?? false;
    _hasAlarm = task?.hasAlarm ?? false;
    _alarmTime = task?.alarmMinutes == null
        ? _defaultAlarm
        : TimeOfDay(hour: task!.alarmHour, minute: task.alarmMinute);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickAlarmTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _alarmTime,
    );
    if (picked != null) setState(() => _alarmTime = picked);
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _showTitleError = true);
      return;
    }
    final note = _noteController.text.trim();

    Navigator.of(context).pop(
      TaskDraft(
        title: title,
        note: note.isEmpty ? null : note,
        isRepeating: _isRepeating,
        hasAlarm: _hasAlarm,
        alarmMinutes: _hasAlarm
            ? _alarmTime.hour * 60 + _alarmTime.minute
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Shrink with the keyboard so the save button is never behind it.
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: FractionallySizedBox(
        heightFactor: 0.94,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.parchment,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.inkMuted.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  Text(
                    _isEditing ? 'Edit Ritual' : 'New Ritual',
                    style: AppTypography.sheetTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isEditing
                        ? 'Change what it says, or how it comes back.'
                        : 'Give it a name, and shape how it shows up.',
                    style: AppTypography.subtitle,
                  ),

                  const SizedBox(height: 28),

                  Expanded(
                    child: ListView(
                      children: [
                        const _FieldLabel('TITLE'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _titleController,
                          autofocus: !_isEditing,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          style: AppTypography.fieldInput,
                          onChanged: (_) {
                            if (_showTitleError) {
                              setState(() => _showTitleError = false);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'e.g. Morning Run',
                            errorText: _showTitleError
                                ? 'Give the ritual a name to save it.'
                                : null,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const _FieldLabel('NOTES (OPTIONAL)'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _noteController,
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          style: AppTypography.body,
                          decoration: const InputDecoration(
                            hintText: 'Any details worth remembering',
                          ),
                        ),

                        const SizedBox(height: 28),

                        const _FieldLabel('HOW IT SHOWS UP'),
                        const SizedBox(height: 10),
                        _ToggleTile(
                          icon: CupertinoIcons.repeat,
                          color: AppColors.moss,
                          title: 'Repeats',
                          subtitle: 'Comes back on tomorrow’s list',
                          value: _isRepeating,
                          onChanged: (v) => setState(() => _isRepeating = v),
                        ),
                        const SizedBox(height: 12),
                        _ToggleTile(
                          icon: CupertinoIcons.alarm,
                          color: AppColors.clay,
                          title: 'Alarm',
                          subtitle: 'Sets an alarm in your clock app',
                          value: _hasAlarm,
                          onChanged: (v) => setState(() => _hasAlarm = v),
                          expanded: _hasAlarm
                              ? _AlarmTimeRow(
                                  time: _alarmTime,
                                  onTap: _pickAlarmTime,
                                )
                              : null,
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      _isEditing ? 'Save Changes' : 'Begin This Ritual',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.fieldLabel);
  }
}

class _AlarmTimeRow extends StatelessWidget {
  const _AlarmTimeRow({required this.time, required this.onTap});

  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Text('Rings at', style: AppTypography.toggleSubtitle),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.clay.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                time.format(context),
                style: AppTypography.toggleTitle.copyWith(
                  color: AppColors.clay,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.expanded,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  final Widget? expanded;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value ? color.withValues(alpha: 0.6) : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: value ? 0.16 : 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.toggleTitle),
                      Text(subtitle, style: AppTypography.toggleSubtitle),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: color,
                ),
              ],
            ),
            ?expanded,
          ],
        ),
      ),
    );
  }
}
