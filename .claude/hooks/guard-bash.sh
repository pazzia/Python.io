#!/usr/bin/env bash
# PreToolUse(Bash): git safety + checks before `git commit`.
# Blocks: pushes to main/master, force pushes, history rewrites.
# On `git commit`: verifies that the course assets match the generator.
source "$(dirname "$0")/lib.sh"
read_input
cmd="$(json_field tool_input.command)"
[ -n "$cmd" ] || exit 0

# --- git push -----------------------------------------------------------------
if grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-[^[:space:]]+)*[[:space:]]+push([[:space:]]|$)' <<<"$cmd"; then
  if grep -Eq '(--force|[[:space:]]-f([[:space:]]|$)|[[:space:]]\+[^[:space:]]+)' <<<"$cmd"; then
    block "Force push запрещён в этом проекте. Если история действительно должна быть переписана, это делает владелец вручную."
  fi
  if grep -Eq '(:|[[:space:]])(refs/heads/)?(main|master)([[:space:]]|$)' <<<"$cmd"; then
    block "Пуш в main запрещён: main — продовая ветка, туда попадают только слияния PR по решению владельца. Пушьте в рабочую ветку."
  fi
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  if [[ "$branch" == main || "$branch" == master ]] && ! grep -Eq 'push[[:space:]]+(-[^[:space:]]+[[:space:]]+)*[^-[:space:]]+[[:space:]]+[^-[:space:]]' <<<"$cmd"; then
    block "Текущая ветка — $branch, а пуш без явной ветки ушёл бы в неё. Создайте рабочую ветку."
  fi
fi

# --- git commit ---------------------------------------------------------------
if grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)' <<<"$cmd"; then
  staged="$(git diff --cached --name-only 2>/dev/null)"
  # `git commit -a` / `-am` also takes tracked changes.
  if grep -Eq 'commit[[:space:]].*(-a[[:space:]]|-a$|-am|--all)' <<<"$cmd"; then
    staged="$staged"$'\n'"$(git diff --name-only 2>/dev/null)"
  fi

  if grep -Eq '^(assets/content/python/|tool/content/)' <<<"$staged"; then
    py="$(command -v python3.12 || true)"
    if [ -z "$py" ]; then
      note PreToolUse "NOT ASSESSED: курс не перепроверен перед коммитом — нет python3.12 (генератор требует ровно 3.12). Проверку выполнит CI (шаг «Check course content»). Сообщите об этом пользователю."
    fi
    tmp="$(mktemp -d)"
    if ! "$py" tool/content/generate_python_course.py "$tmp" >"$tmp.log" 2>&1; then
      tail -20 "$tmp.log" >&2
      rm -rf "$tmp" "$tmp.log"
      block "Генератор курса упал (вывод выше). Коммит остановлен: исправьте исходники в tool/content/."
    fi
    if ! diff -rq "$tmp" assets/content/python >"$tmp.diff" 2>&1; then
      head -20 "$tmp.diff" >&2
      rm -rf "$tmp" "$tmp.log" "$tmp.diff"
      block "assets/content/python не совпадает с генератором (различия выше). Запустите: python3.12 tool/content/generate_python_course.py assets/content/python — и закоммитьте результат вместе с исходниками."
    fi
    rm -rf "$tmp" "$tmp.log" "$tmp.diff"
  fi

  if grep -q 'lib/features/gamification/domain/game_rules.dart' <<<"$staged"; then
    note PreToolUse "В коммите изменены числа экономики (GameRules). Если /balance-check для этого изменения ещё не запускали — предложите пользователю."
  fi
fi
exit 0
