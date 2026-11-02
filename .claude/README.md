# .claude — настройка Claude Code для Bytecraft

Главные правила — в `CLAUDE.md` в корне. Здесь лежит то, что их обеспечивает.

| Папка | Что внутри |
|---|---|
| `settings.json` | Запреты (`rm -rf`, force push, пуш в main, `reset --hard`, чтение ключей) и подключение хуков |
| `hooks/` | `guard-bash.sh`: пуши и проверка курса перед коммитом. `guard-write.sh`: защита генерируемого контента и ключей. `post-edit.sh`: напоминания о токенах темы и `GameRules`. `session-start.sh`: состояние ветки и чекпоинт |
| `rules/` | Правила по путям: `content.md`, `gamification.md`, `ui.md` |
| `agents/` | `economy-designer`, `ux-reviewer`, `qa-lead` — только читают, код не правят |
| `skills/` | `/balance-check`, `/ux-check`, `/bug-report`, `/release-checklist` |
| `templates/` | `ux-spec.md` — спека экрана до вёрстки |

Хукам нужны `bash` и `python3`; для проверки курса перед коммитом — `python3.12`. Если `python3.12` нет, хук сообщает «NOT ASSESSED» и коммит не блокирует: проверку выполнит CI.

Чтобы временно выключить хуки у себя, используйте `.claude/settings.local.json` (не коммитится).

Идеи взяты из [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) (MIT): протокол «вопрос → варианты → решение → черновик → одобрение», правила по путям, вердикт NOT ASSESSED, обязательный скриншот для визуальных задач, чекпоинт сессии. Тексты переписаны под этот проект.
