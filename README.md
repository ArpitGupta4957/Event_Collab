<div align="center">

# ✅ Event Media Viewer

**A modern, production-ready Flutter app for event discovery and media browsing**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev/)
[![Provider](https://img.shields.io/badge/State-Provider-6.1.5-8E44AD)](.)
[![Supabase](https://img.shields.io/badge/Supabase-Postgres-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com/)
[![Unsplash](https://img.shields.io/badge/Images-Unsplash-black?logo=unsplash)](https://unsplash.com/developers)

*Event listing • Add events • Infinite image gallery • Fullscreen zoom viewer • Light/Dark mode*

</div>

---

## 🎯 Overview

Event Media Viewer is a clean-architecture mobile app that lets users:
- Browse events from Supabase
- Create new events with event code
- Explore event-based image galleries from Unsplash
- View photos in immersive fullscreen mode with pinch-to-zoom

The app focuses on smooth UX using shimmer placeholders, hero transitions, animated screens, pagination, and persistent theme mode.

---

## 📸 App Preview

| Splash Screen | Event List | Photo Gallery | Photo Viewer |
|---|---|---|---|
| ![Splash](Imgs/screen.jpeg) | ![Events](Imgs/event_list.jpeg) | ![Gallery](Imgs/photo_gallery.jpeg) | ![Viewer](Imgs/photo_viewer.jpeg) |

---

## 🏗️ App Architecture

```text
┌──────────────────────────────────────────────────────────────┐
│                        Flutter App UI                        │
│  Splash → Event List → Event Detail → Gallery → Viewer       │
└─────────────────────────────┬────────────────────────────────┘
															│
										Provider State Layer
								(EventProvider, PhotoProvider,
										 ThemeProvider)
															│
				 ┌────────────────────┴────────────────────┐
				 │                                         │
	 SupabaseService                           UnsplashService
 (events read/create)                     (search + pagination)
				 │                                         │
			Supabase DB                             Unsplash API
```

---

## ✨ Core Features

### 📅 Event Management
- Fetch events from Supabase (`events` table)
- Add new events from app UI (name + code)
- Pull-to-refresh with loading, error, and empty states

### 🖼️ Media Gallery
- Search Unsplash photos by event name
- Infinite scroll pagination (`page`, `per_page=20`)
- Cached images with fade-in grid animation
- Fullscreen PageView + PhotoView zoom

### 🎨 Premium UX
- Animated splash screen
- Hero transitions (event cards and image tiles)
- Shimmer loading skeletons
- Persisted theme mode: System / Light / Dark

---

## 🛠️ Technology Stack

- **Framework:** Flutter (latest stable)
- **State Management:** Provider
- **Backend/Data:** Supabase Postgres
- **Image API:** Unsplash Search API
- **Networking:** http
- **Caching:** cached_network_image
- **Zoom Viewer:** photo_view
- **UI/Fonts:** Material 3 + Google Fonts
- **Animations:** AnimatedSwitcher, Hero, SmoothPageIndicator, Shimmer

---

## 📁 Project Structure

```text
lib/
 ├── main.dart
 ├── core/
 │   ├── constants.dart
 │   ├── theme.dart
 │   └── utils.dart
 ├── models/
 │   ├── event_model.dart
 │   └── photo_model.dart
 ├── services/
 │   ├── supabase_service.dart
 │   └── unsplash_service.dart
 ├── providers/
 │   ├── event_provider.dart
 │   ├── photo_provider.dart
 │   └── theme_provider.dart
 ├── screens/
 │   ├── splash_screen.dart
 │   ├── event_list_screen.dart
 │   ├── event_detail_screen.dart
 │   ├── photo_gallery_screen.dart
 │   └── photo_viewer_screen.dart
 └── widgets/
		 ├── event_card.dart
		 ├── photo_grid_item.dart
		 ├── loading_widget.dart
		 ├── empty_state_widget.dart
		 └── error_widget.dart
```

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK installed
- Supabase project
- Unsplash developer key

### 1) Install dependencies

```bash
flutter pub get
```

### 2) Configure environment

```bash
cp .env.example .env
```

Update `.env`:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
UNSPLASH_API_KEY=your_unsplash_access_key
```

### 3) Setup Supabase table and policies

Run in Supabase SQL Editor:

```sql
create extension if not exists "pgcrypto";

create table if not exists public.events (
	id uuid primary key default gen_random_uuid(),
	name text not null,
	code text not null unique,
	created_at timestamptz not null default now()
);

create index if not exists idx_events_name on public.events (name);

do $$
begin
	if not exists (
		select 1 from pg_constraint where conname = 'events_name_not_blank'
	) then
		alter table public.events
			add constraint events_name_not_blank
			check (length(trim(name)) > 0);
	end if;

	if not exists (
		select 1 from pg_constraint where conname = 'events_code_not_blank'
	) then
		alter table public.events
			add constraint events_code_not_blank
			check (length(trim(code)) > 0);
	end if;
end $$;

insert into public.events (name, code)
values
	('Tech Fest 2025', 'TF25'),
	('Cultural Night', 'CN24'),
	('Hackathon', 'HK2025'),
	('Sports Day', 'SD24')
on conflict (code) do nothing;

alter table public.events enable row level security;

drop policy if exists "Allow read events" on public.events;
drop policy if exists "Allow insert events" on public.events;

create policy "Allow read events"
on public.events
for select
to anon, authenticated
using (true);

create policy "Allow insert events"
on public.events
for insert
to anon, authenticated
with check (
	length(trim(name)) > 0
	and length(trim(code)) > 0
);
```

### 4) Run app

```bash
flutter run
```

---

## 🧪 Quality Checks

```bash
flutter analyze
flutter test
```

---

## 🔐 Notes
- `.env.example` is committed for onboarding
- Supabase insert policy is required for in-app event creation

---

<div align="center">

**Built for smooth event discovery and beautiful media exploration.**

</div>
