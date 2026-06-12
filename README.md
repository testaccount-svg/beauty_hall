# CosmoShop — Flutter интернет-магазин косметики

## 🗄️ MockAPI — структура таблиц

Создайте проект на [mockapi.io](https://mockapi.io) и добавьте 2 таблицы.

### Таблица `products`
| Поле | Тип | Пример |
|------|-----|--------|
| id | String (auto) | "1" |
| name | String | "Помада стойкая матовая" |
| description | String | "Долгостойкая помада..." |
| price | Number | 1500 |
| imageUrl | String | "https://..." |
| category | String | "lips" / "eyes" / "skin" / "hair" / "nails" |
| stock | Number | 25 |
| isAvailable | Boolean | true |
| createdAt | String | "2024-01-15T10:00:00.000Z" |

### Таблица `orders`
| Поле | Тип | Пример |
|------|-----|--------|
| id | String (auto) | "1" |
| customerName | String | "Айгуль Бекова" |
| customerPhone | String | "+7 777 123 45 67" |
| address | String | "г. Алматы, ул. Абая 10, кв. 5" |
| items | Array | [{productId, productName, price, quantity, imageUrl}] |
| totalAmount | Number | 4500 |
| status | String | "pending" / "confirmed" / "shipping" / "delivered" / "cancelled" |
| note | String | "Позвоните перед доставкой" |
| createdAt | String | "2024-01-15T10:00:00.000Z" |

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
| Вход | Email + пароль (admin@cosmo.com / admin123) |
| Товары | Список, добавление, редактирование, удаление |
| Заказы | Список всех заказов, смена статуса, удаление |

---

## 🔑 Вход администратора
```
Email:  admin@cosmo.com
Пароль: admin123
```
Чтобы сменить — откройте `lib/config.dart`.

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
