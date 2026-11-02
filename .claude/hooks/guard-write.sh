#!/usr/bin/env bash
# PreToolUse(Write|Edit): protect generated and secret files.
source "$(dirname "$0")/lib.sh"
read_input
path="$(edited_path)"

case "$path" in
  assets/content/python/*)
    block "assets/content/python/ генерируется из tool/content/ (generate_python_course.py исполняет каждый сниппет реальным Python). Правьте исходник в tool/content/course/ и перегенерируйте: python3.12 tool/content/generate_python_course.py assets/content/python" ;;
  *.jks|*.keystore|key.properties|*/key.properties)
    block "Файлы ключей подписи не редактируются и не коммитятся. Ключ живёт в кэше GitHub Actions, см. docs/RELEASE.md." ;;
esac
exit 0
