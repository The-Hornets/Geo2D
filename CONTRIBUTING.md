# Contributing

## Ветки

Все ветки отводятся от `develop`, PR кидается в `develop`.

Формат: `<тип>/<краткое-описание>` — слова через дефис, только строчные буквы.

```
feat/segment-intersection
fix/point-distance-zero-division
refactor/projection-method
test/polygon-edge-cases
docs/circle-readme
chore/update-dependencies
```

## Коммиты

Формат: `<тип>: <что сделано>` — до 72 символов, глагол в инфинитиве.

```
feat: add intersection of two line segments
fix: fix division by zero in Point#distance
refactor: extract projection logic into a separate method
test: cover edge cases for Polygon
docs: describe Circle usage in README
chore: update dependencies
```

- Один коммит — одно логическое изменение
- Тело коммита — только если нужно объяснить *почему*, не *что*

## Pull Requests

**Название** — по той же схеме: `feat: support polygon intersection`

**Описание:**

```
## What's done
Short description of the change.

## Why / context
Only if not obvious from the code.

## How to verify
- [ ] bundle exec rspec
- [ ] Usage example: ...
```

- PR закрывает одну задачу — не мешать фичи и рефакторинг
- Размер до ~1000 строк diff, иначе делить на части
- Черновик оформляется как `Draft: <название>`
- Ревьюер даёт фидбек в течение 1 рабочего дня — иначе можно мёрджить самому
