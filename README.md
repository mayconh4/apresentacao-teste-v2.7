# BarberApp

App de gestão e agendamento para barbearias. **Estado atual: estrutura inicial + testes** (sem UI completa nem backend conectado).

## Stack
- **Flutter** (Dart) — app único Android/iOS
- **Riverpod** — gerência de estado
- **GoRouter** — navegação
- **Supabase** — Auth, PostgreSQL, Realtime, Storage
- **Asaas** — pagamentos PIX

## Estrutura
```
lib/
  core/            # config, tema, utils
  data/
    models/        # Service, Barber, Appointment, FinanceEntry
    repositories/  # BookingRepository (interface) + stub em memória
  features/
    booking/       # agendamento (cliente)
      domain/      # availability (slots livres), loyalty (fidelidade)
    barber_dashboard/
      domain/      # finance_calculator (faturamento, comissão, metas)
    auth/
test/              # testes unitários espelhando lib/
```

## Lógica de negócio testada
- **AvailabilityService** — geração de horários livres (passo, almoço, conflitos, cancelados)
- **FinanceCalculator** — faturamento, nº de cortes, comissão, lucro, progresso de meta
- **LoyaltyService** — recompensas (10→1), dias sem corte
- **Appointment** — duração, sobreposição, serialização JSON
- **InMemoryBookingRepository** — criação com bloqueio de horário duplicado

## Como rodar
```bash
flutter pub get
flutter test          # roda a suíte de testes
flutter analyze       # lint
flutter run           # executa o app (placeholder de UI)
```

Configuração sensível via `--dart-define` (ver `lib/core/config/app_config.dart`):
```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

## Roadmap
Ver o documento de plano técnico. Fases: 1) MVP Cliente (agendamento + PIX) · 2) MVP Barbeiro (dashboard) · 3) IA & relatórios · 4) monetização (fidelidade, Clube VIP).
