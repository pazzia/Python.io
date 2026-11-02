---
paths:
  - "assets/content/**"
  - "tool/content/**"
  - "tool/pyodide/**"
---

# Правила контента курса

- Источник истины — `tool/content/` (`course/*.py`, `bclib.py`, `glossary.py`). JSON в `assets/content/python/` только генерируется.
- После правки исходника: `python3.12 tool/content/generate_python_course.py assets/content/python`. Генератор исполняет каждый пример реальным Python и проверяет:
  - ожидаемый вывод;
  - полноту допустимых порядков в ordering-задачах;
  - что bug-finder уровни действительно ломаются и чинятся.
- Результат должен быть детерминированным: CI сравнивает прогоны с `PYTHONHASHSEED=1` и `2`. Не полагайтесь на порядок `set` и `dict` из внешних данных.
- Программы курса должны работать и в Pyodide (`tool/pyodide/check_content.mjs`): без сети, без потоков ОС, без `input()` в коде, который исполняется на устройстве.
- Стиль тем и уроков — `docs/TOPIC_STYLE.md`. Тексты по-русски, код и идентификаторы по-английски.
- Новый тип задания — это payload + parser + validator + renderer (ADR-3). Неизвестный тип клиент пропускает (ADR-13), поэтому старые версии не ломаются.
- Сложность уровня влияет на награду через `LevelRole` (lesson / practice / challenge / boss). Роль выбирайте по сути задания, а не ради XP.
