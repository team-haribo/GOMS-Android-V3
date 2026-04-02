# GOMS 네이밍 규칙

이 문서는 폴더/파일 네이밍 혼용을 줄이기 위한 기준이다.
기존 코드는 점진적으로 이 규칙에 맞춰 정리한다.

## 목적
- 탐색 비용 감소
- 기능 위치 예측 가능성 확보
- 유사 개념의 중복 이름 방지
- 신규 코드에서 혼용 재발 방지

## 기본 원칙
- 같은 책임에는 같은 이름을 쓴다.
- 작은 feature일수록 단순한 구조를 우선한다.
- 이름이 계층을 설명해야지, 개인 취향을 반영하면 안 된다.
- 신규 코드는 이 문서를 기준으로 작성한다.

## 디렉터리 규칙

### UI 진입점
- 화면 단위: `screens`
- 재사용 UI 조각: `widgets`
- Riverpod 상태 소스: `providers`
- UI 상태 모델: `models`

### 금지/비권장 이름
- `pages` 사용 금지
  - 기존 `pages`는 점진적으로 `screens`로 이동한다.
- `viewmodels` 사용 금지
  - Riverpod `Notifier`, `AsyncNotifier`, `Provider`는 모두 `providers` 아래에 둔다.
- `states` 디렉터리 사용 금지
  - UI 상태 타입은 `models` 아래에 둔다.

## 파일 규칙

### screen
- 전체 화면 진입 위젯은 `*_screen.dart`
- 예: `login_screen.dart`, `my_page_screen.dart`

### widget
- 화면 일부를 구성하는 위젯은 역할 기반 이름을 사용한다.
- 예: `settings_section.dart`, `member_card.dart`

### provider
- Riverpod provider/notifier 정의 파일은 `*_provider.dart`
- 예: `login_provider.dart`, `session_provider.dart`
- 파일 내부 클래스 이름은 역할을 드러내되, 파일명은 provider 기준으로 맞춘다.

### model
- UI 상태/폼 상태/뷰 전용 모델은 `models` 아래에 둔다.
- 상태 타입 파일명은 `*_state.dart`
- 예: `login_state.dart`, `verify_state.dart`

## 기능별 권장 구조

### 작은 feature
```text
feature/
  presentation/
    screens/
    widgets/
    providers/
    models/
```

### 중간 feature
```text
feature/
  data/
  presentation/
```

### 큰 feature
```text
feature/
  data/
  domain/
  presentation/
```

## layer 네이밍 규칙
- `data`: remote/local datasource, dto, repository impl
- `domain`: entity, repository interface
- `presentation`: screen, widget, provider, model

## usecase 규칙
- 단순 repository 전달만 하는 usecase는 만들지 않는다.
- 실제 정책/조합/검증/트랜잭션 경계가 있을 때만 usecase를 둔다.
- 작은 feature에서는 repository 직접 호출을 기본으로 한다.

## shared 규칙
- 진짜로 둘 이상의 하위 feature가 공용으로 쓰는 경우에만 `shared`를 쓴다.
- 특정 feature 내부 전용이면 해당 feature 바로 아래에 둔다.
- `shared`는 편의 폴더가 아니라 소유권이 명확한 공용 코드만 둔다.

## 마이그레이션 규칙
- 새 코드는 반드시 이 문서를 따른다.
- 기존 코드는 수정이 닿는 범위에서 함께 정리한다.
- 대규모 일괄 변경보다 feature 단위 점진 정리를 우선한다.

## 현재 결정 사항
- `screen`으로 통일한다. `page`는 더 이상 추가하지 않는다.
- `provider`로 통일한다. `viewmodel`은 더 이상 추가하지 않는다.
- `model`로 통일한다. `state` 전용 디렉터리는 더 이상 추가하지 않는다.
- pass-through `usecase`는 더 이상 기본값이 아니다.

## 예외
- 외부 라이브러리/코드 생성기 제약이 있는 경우
- Flutter/Firebase/Kakao SDK 규약상 이름이 고정된 경우
- 예외를 둘 때는 PR 설명에 이유를 남긴다.
