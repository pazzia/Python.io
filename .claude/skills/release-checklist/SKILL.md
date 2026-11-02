---
name: release-checklist
description: "Проверка готовности Bytecraft к выпуску: версия в pubspec, курс совпадает с генератором, анализ и тесты, подпись, заметки к выпуску. Используйте перед слиянием в main или когда пользователь говорит «готовим релиз»."
argument-hint: "[версия, например 0.4.0]"
---

# /release-checklist

Готовим выпуск `$ARGUMENTS`. Порядок выпуска описан в `docs/RELEASE.md`: сборка из `main` публикуется в Releases, номер сборки — номер запуска CI, подпись — ключ из кэша `bytecraft-signing-v1`.

Пройдите пункты и для каждого запишите **PASS / FAIL / NOT ASSESSED**, обязательно с доказательством: командой и её реальным выводом.

| # | Пункт | Как проверить |
|---|---|---|
| 1 | Версия в `pubspec.yaml` (часть до `+`) повышена относительно `origin/main` | `git diff origin/main -- pubspec.yaml` |
| 2 | Курс совпадает с генератором | `python3.12 tool/content/generate_python_course.py <tmp>` и `diff -r <tmp> assets/content/python` |
| 3 | Анализ чистый | `flutter analyze` |
| 4 | Тесты зелёные | `flutter test` |
| 5 | Последний CI ветки зелёный, включая Pyodide и smoke | GitHub Actions: статус проверок PR |
| 6 | Отпечаток подписи в комментарии CI к PR совпадает с прошлым релизом | раздел **signing** в комментарии CI |
| 7 | Workflow «Keep signing key» включён и последний запуск успешный | Actions → Keep signing key |
| 8 | Изменения формата сохранения сопровождаются новым `schemaVersion` и миграцией | `git diff origin/main -- lib/core/storage lib/features/*/data` |
| 9 | Изменения `GameRules` прошли `/balance-check` | история разговора или коммитов |
| 10 | UI-изменения проверены `/ux-check` со скриншотами | наличие скриншотов или отчёта |

Затем подготовьте черновик заметок к выпуску по `git log origin/main..HEAD --oneline`. Пишите по-русски, для игрока: что нового, что исправлено. Без внутренних деталей.

Итог: **READY**, если все пункты PASS; **NOT READY**, если есть FAIL; **NOT ASSESSED**, если важные пункты не удалось проверить. Слияние в `main` делает только пользователь.
