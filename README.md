# CosmoShop — Flutter интернет-магазин косметики

## 🗄️ MockAPI — структура таблиц

Создайте проект на [mockapi.io](https://mockapi.io) и добавьте 2 таблицы.

### Таблица `products`

| Поле | Тип | Пример |
|------|-----|--------|
| id | String (auto) | "1" |
| name | String | "Помада стойкая матовая" |
| description | String | "Стойкая помада до 12 часов, не оставляет следов" |
| price | Number | 350 |
| imageUrl | String | "https://picsum.photos/seed/lipstick/400/400" |
| category | String | "lips" / "eyes" / "skin" / "hair" / "nails" |
| stock | Number | 30 |
| isAvailable | Boolean | true |
| createdAt | String | "2024-01-15T10:00:00.000Z" |

> 💡 Цены в **сомах (KGS)**. Диапазон: бюджетный сегмент 150–500 сом, средний 500–1500 сом.

#### Примеры товаров для заполнения

| name | description | price | category | stock |
|------|-------------|-------|----------|-------|
| Помада стойкая матовая | Стойкая помада до 12 часов, не оставляет следов | 350 | lips | 30 |
| Тональный крем SPF30 | Лёгкое покрытие с защитой от солнца | 890 | skin | 15 |
| Тушь для ресниц объёмная | Придаёт объём и длину, не осыпается | 420 | eyes | 22 |
| Хайлайтер сияющий | Стойкое сияние на скулах и переносице | 480 | skin | 18 |
| Карандаш для бровей | Натуральный эффект, водостойкий | 220 | eyes | 35 |
| Блеск для губ увлажняющий | С витамином Е, 8 оттенков | 190 | lips | 40 |
| Маска для волос питательная | Восстанавливает повреждённые волосы | 650 | hair | 12 |
| Лак для ногтей стойкий | Держится до 10 дней без сколов | 180 | nails | 50 |

---

### Таблица `orders`

| Поле | Тип | Пример |
|------|-----|--------|
| id | String (auto) | "1" |
| customerName | String | "Айзат Матисакова" |
| customerPhone | String | "+996 700 123 456" |
| address | String | "г. Ош, мкр. Достук, ул. Ленина 45, кв. 12" |
| items | Array | [{productId, productName, price, quantity, imageUrl}] |
| totalAmount | Number | 1240 |
| status | String | "pending" / "confirmed" / "shipping" / "delivered" / "cancelled" |
| note | String | "Позвоните за 30 минут до доставки" |
| createdAt | String | "2024-01-15T10:00:00.000Z" |

#### Примеры заказов для заполнения

| customerName | customerPhone | address | totalAmount | status | note |
|--------------|---------------|---------|-------------|--------|------|
| Айзат Матисакова | +996 700 123 456 | г. Ош, мкр. Достук, ул. Ленина 45, кв. 12 | 1240 | pending | Позвоните за 30 минут до доставки |
| Жылдыз Эргешова | +996 555 987 654 | г. Ош, Жийде базар, ул. Курманжан Датка 18 | 3780 | delivered | Оставить у соседей если меня нет дома |
| Нурзат Токтосунова | +996 772 456 789 | г. Ош, мкр. Нариман, ул. Масалиева 7 | 870 | confirmed | — |
| Гүлнара Асанова | +996 700 321 654 | г. Ош, ул. Навои 33, кв. 5 | 540 | shipping | Только после 18:00 |
| Аида Мамытбекова | +996 558 111 222 | г. Ош, мкр. Черёмушки, ул. Фрунзе 12 | 1960 | cancelled | — |

---

После создания вставьте Base URL в `lib/config.dart`:

```dart
static const String mockApiBase = 'https://YOUR_ID.mockapi.io/api/v1';
```

---

## 🚀 Запуск

```bash
flutter pub get
flutter run
```

---

## 📱 Экраны

### Покупатель

| Экран | Описание |
|-------|----------|
| Каталог | Список товаров, поиск, фильтр по категориям |
| Карточка товара | Детали, добавление в корзину |
| Корзина | Список товаров, изменение количества |
| Оформление заказа | Форма с именем, телефоном, адресом |
| Успешный заказ | Подтверждение с номером заказа |

### Администратор

| Экран | Описание |
|-------|----------|
| Вход | Email + пароль (admin@cosmosh.kg / admin123) |
| Товары | Список, добавление, редактирование, удаление |
| Заказы | Список всех заказов, смена статуса, удаление |

---

## 🔑 Вход администратора

```
Email:  admin@cosmosh.kg
Пароль: admin123
```

Чтобы сменить — откройте `lib/config.dart`.

---

## ⚙️ `lib/config.dart`

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

## 📂 Структура проекта

```
lib/
├── main.dart
├── config.dart
├── models/
│   ├── product_model.dart
│   ├── order_model.dart
│   └── cart_item_model.dart
├── services/
│   ├── api_service.dart
│   └── shop_provider.dart
├── widgets/
│   ├── product_card.dart
│   └── order_status_badge.dart
└── screens/
    ├── buyer/
    │   ├── catalog_screen.dart
    │   ├── product_detail_screen.dart
    │   ├── cart_screen.dart
    │   ├── checkout_screen.dart
    │   └── order_success_screen.dart
    └── admin/
        ├── admin_login_screen.dart
        ├── admin_screen.dart
        ├── admin_products_tab.dart
        ├── admin_product_form.dart
        └── admin_orders_tab.dart
```
