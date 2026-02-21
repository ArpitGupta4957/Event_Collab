# Event Media Viewer

Production-ready Flutter mobile app demonstrating:
- Clean architecture (`models`, `services`, `providers`, `screens`, `widgets`)
- Provider state management
- Supabase events integration
- Unsplash image search with infinite pagination
- Hero animations, shimmer loading, cached images, and PhotoView zoom
- Light/Dark theme with Google Fonts

## 1) Configure keys

Copy `.env.example` to `.env` and fill:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `UNSPLASH_API_KEY`

`.env` is ignored by git and loaded at startup via `flutter_dotenv`.

## 2) Supabase table setup

Run this SQL in Supabase SQL editor:

```sql
create extension if not exists "pgcrypto";

create table if not exists public.events (
	id uuid primary key default gen_random_uuid(),
	name text not null,
	code text not null
);

insert into public.events (name, code)
values
	('Tech Fest 2025', 'TF25'),
	('Cultural Night', 'CN24'),
	('Hackathon', 'HK2025'),
	('Sports Day', 'SD24');
```

## 3) Install and run

```bash
flutter pub get
flutter run
```

## Folder structure

```text
lib/
 ├── main.dart
 ├── core/
 │    ├── theme.dart
 │    ├── constants.dart
 │    └── utils.dart
 ├── models/
 │    ├── event_model.dart
 │    └── photo_model.dart
 ├── services/
 │    ├── supabase_service.dart
 │    └── unsplash_service.dart
 ├── providers/
 │    ├── event_provider.dart
 │    └── photo_provider.dart
 ├── screens/
 │    ├── event_list_screen.dart
 │    ├── event_detail_screen.dart
 │    ├── photo_gallery_screen.dart
 │    └── photo_viewer_screen.dart
 └── widgets/
			├── event_card.dart
			├── photo_grid_item.dart
			├── loading_widget.dart
			├── empty_state_widget.dart
			└── error_widget.dart
```
