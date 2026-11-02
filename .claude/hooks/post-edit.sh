#!/usr/bin/env bash
# PostToolUse(Write|Edit): reminders that keep UI and economy rules honest.
# Never blocks; only adds context for Claude.
source "$(dirname "$0")/lib.sh"
read_input
path="$(edited_path)"
text="$(added_text)"
msgs=()

if [[ "$path" == lib/*.dart && "$path" != lib/core/theme/* ]]; then
  if grep -Eq 'Color\(0x|Colors\.[a-z]' <<<"$text"; then
    msgs+=("Цвет задан литералом вне lib/core/theme ($path). Используйте AppColors/GameColors или Theme.of(context); новый цвет — новый токен в lib/core/theme и строка в docs/DESIGN.md.")
  fi
  if grep -Eq 'fontSize:[[:space:]]*[0-9]' <<<"$text"; then
    msgs+=("fontSize задан числом ($path). Шкала шрифтов — в lib/core/theme/app_typography.dart (30/26/24/20/17/15/13).")
  fi
fi

if [[ "$path" == lib/features/*/domain/*.dart && "$path" != */game_rules.dart ]]; then
  if grep -Eq '(xp|coins?|lives|price|bonus|reward)[A-Za-z]*[[:space:]]*[=:+*-][[:space:]]*[0-9]{2,}' <<<"$text"; then
    msgs+=("Похоже на число экономики в domain-коде ($path). Все такие числа живут в GameRules (game_rules.dart), иначе их не видит /balance-check.")
  fi
fi

if [[ "$path" == tool/content/* ]]; then
  msgs+=("Изменён исходник курса. Перегенерируйте: python3.12 tool/content/generate_python_course.py assets/content/python — генератор исполнит все сниппеты.")
fi

[ ${#msgs[@]} -eq 0 ] && exit 0
note PostToolUse "$(printf '%s\n' "${msgs[@]}")"
