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
- 신규 코드는 `providers` / `models`를 쓴다.
  - 기존 `viewmodels` / `states` 디렉터리는 그대로 두고, 그 안의 코드를 수정할 때
    한 파일씩 옮긴다. 이름만 바꾸는 일괄 리네임은 하지 않는다.

## 상태를 어디에 둘까

디렉터리 이름보다 이 질문이 먼저다. Riverpod의 `Notifier`가 곧 ViewModel이므로
"MVVM을 쓸까"가 아니라 **"이 상태가 위젯보다 오래 사는가"**로 판단한다.

### 1. Provider(= ViewModel)에 둔다
- 화면을 벗어나도 유지돼야 하거나, 둘 이상이 읽는 상태
- 서버 호출·비동기 로딩·에러·폼 검증이 붙는 상태
- 예: `authProvider`, `signupProvider`, `mapScreenProvider`, `settingsProvider`

### 2. `setState`로 둔다
- 위젯 하나만 읽고 쓰고, 위젯이 사라지면 같이 사라지는 상태
- 바텀시트 안의 선택값, 토글 진행 중 플래그, 펼침/접힘 같은 것
- provider로 올리면 `autoDispose.family` + 식별용 키가 따라붙는다.
  그건 `setState`를 어렵게 재구현한 것이다.
- 부모가 새 값을 내려줄 때 따라가야 하면 `didUpdateWidget`에서 명시적으로 반영한다.

### 3. 만들지 않는다
- 다른 provider의 메서드를 그대로 호출만 하는 ViewModel은 두지 않는다.
- 위젯에서 `ref.read(대상provider.notifier)`를 직접 부른다.

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
- 저장소/서비스도 마찬가지다. 인터페이스와 구현이 1:1이고 구현이 전달만 하면
  중간 계층 없이 `datasource` 또는 유틸을 직접 쓴다.
  플랫폼 API를 감싸 테스트에서 갈아끼워야 하는 경우(`PermissionService`)만 예외다.

## 정리 대상 (2026-08-19 기준)

규칙에 맞지 않지만 아직 옮기지 않은 것들. 수정이 닿을 때 함께 정리한다.

| 위치 | 내용 |
| --- | --- |
| `features/*/presentation/viewmodels/` | 디렉터리 11개. 안의 provider 이름은 이미 대부분 `xxxProvider`라 파일 위치만 남았다. |
| `features/auth/verification/presentation/states/` | `models/`로 이동 |
| `features/map/shared/presentation/widgets/` | 15개. 실제로 공용인 것만 남기고 나머지는 소유 하위 feature로 |
| `features/map/routes/` | 다른 feature와 맞춰 `presentation/routes/`로 |
| `features/home/domain/enums/student_role_enum.dart` | `home`의 유일한 파일인데 실사용처는 `member`/`outing`. `core/enums/`로 |
| `features/auth/email_verification/data/models/request/email_verification/` | 경로에 feature 이름이 두 번 들어간다 |

## Git 네이밍

### 브랜치
`<타입>/#<이슈번호>-<영문 설명>`

| 타입 | 용도 |
| --- | --- |
| `feature` | 기능 추가 |
| `fix` | 버그 수정 |
| `refactor` | 동작 변경 없는 구조 정리 |
| `perf` | 성능 개선 |
| `docs` | 문서만 변경 |
| `release` | 배포 준비 (`release/v1.4.2` 처럼 이슈번호 없이) |

- 타입은 브랜치가 하는 일에 맞춘다. 리팩터링에 `feature`를 붙이지 않는다.
- 설명은 영문 kebab-case. 예: `refactor/#108-dead-code-cleanup`

### 커밋
`:gitmoji: :: <한글 설명>`

- gitmoji는 콜론 형식(`:sparkles:`)으로 쓴다. 유니코드 이모지(`✨`)를 섞지 않는다.
- 이슈 참조가 필요하면 설명 끝에 `(#126)`.

| gitmoji | 용도 |
| --- | --- |
| `:sparkles:` | 기능 추가 |
| `:bug:` | 버그 수정 |
| `:recycle:` | 리팩터링 |
| `:zap:` | 성능 개선 |
| `:memo:` | 문서 |
| `:green_heart:` | CI |
| `:bookmark:` | 버전업 |

### PR 제목

**작업 PR** (base: `develop`)

`🔀 :: (#<이슈번호>) - <한글 설명>`

- 이모지는 변경 성격과 무관하게 항상 `🔀`다. 커밋과 달리 유니코드 이모지를 쓴다.
- 예: `🔀 :: (#122) - QR 인식 실패 후 카메라 복귀 시 검은 화면으로 남던 문제 수정`

**배포 PR** (`develop` → `main`)

`v<버전>` 또는 `🔀 :: v<버전> - <한글 설명>`

- 버전만 쓰는 짧은 형태를 기본으로 한다. 예: `v1.4.5`
- 무엇이 나가는지 제목에 남기고 싶으면 긴 형태를 쓴다.
  예: `🔀 :: v1.4.4 - 핫플레이스 조회 기준 기간 1일로 변경`

### PR 공통
- `main`을 base로 여는 PR은 배포 PR뿐이다. 작업 브랜치에서 `main`으로 직접 열지 않는다.
- 본문은 `.github/PULL_REQUEST_TEMPLATE.md`를 채우고, 관련 이슈에 `Closes #N`을 남긴다.
- 배포 PR은 버전업 커밋(`:bookmark:`)이 `develop`에 올라간 뒤에 연다.

## 예외
- 외부 라이브러리/코드 생성기 제약이 있는 경우
- Flutter/Firebase/Kakao SDK 규약상 이름이 고정된 경우
- 예외를 둘 때는 PR 설명에 이유를 남긴다.
