### Таблица `products` — примеры для MockAPI

| Поле | Пример 1 | Пример 2 | Пример 3 |
|------|----------|----------|----------|
| name | "Помада стойкая матовая" | "Тональный крем SPF30" | "Тушь для ресниц объёмная" |
| description | "Стойкая помада до 12 часов, не оставляет следов" | "Лёгкое покрытие с защитой от солнца" | "Придаёт объём и длину, не осыпается" |
| price | 350 | 890 | 420 |
| imageUrl | "https://picsum.photos/seed/lipstick/400/400" | "https://picsum.photos/seed/foundation/400/400" | "https://picsum.photos/seed/mascara/400/400" |
| category | "lips" | "skin" | "eyes" |
| stock | 30 | 15 | 22 |
| isAvailable | true | true | false |

> Цены в **KGS (сом)**. Реальный диапазон: бюджетная косметика 150–500 сом, средний сегмент 500–1500 сом.

---

### Таблица `orders` — примеры для MockAPI

| Поле | Пример 1 | Пример 2 |
|------|----------|----------|
| customerName | "Айзат Матисакова" | "Жылдыз Эргешова" |
| customerPhone | "+996 700 123 456" | "+996 555 987 654" |
| address | "г. Ош, мкр. Достук, ул. Ленина 45, кв. 12" | "г. Ош, Жийде базар, ул. Курманжан Датка 18" |
| totalAmount | 1240 | 3780 |
| status | "pending" | "delivered" |
| note | "Позвоните за 30 минут до доставки" | "Оставить у соседей если меня нет дома" |

---

### `lib/config.dart` — обновлённые учётные данные

```dart
class Config {
  static const String mockApiBase = 'https://YOUR_ID.mockapi.io/api/v1';

  // Администратор
  static const String adminEmail    = 'admin@cosmosh.kg';
  static const String adminPassword = 'admin123';

  // Валюта
  static const String currency      = 'сом';
  static const String currencyCode  = 'KGS';
}
```

---
