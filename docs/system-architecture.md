# 메모 앱 시스템 아키텍처

## 개요

Next.js 기반의 풀스택 메모 관리 애플리케이션으로, Supabase를 백엔드로 사용하는 현대적인 웹 애플리케이션입니다.

## 시스템 아키텍처 다이어그램

```mermaid
graph TB
    subgraph "사용자 인터페이스 레이어"
        A[page.tsx<br/>메인 페이지] --> B[MemoList<br/>메모 목록]
        A --> C[MemoForm<br/>메모 작성/수정]
        B --> D[MemoItem<br/>메모 아이템]
        B --> E[MemoViewer<br/>메모 상세보기]
        
        style A fill:#e3f2fd
        style B fill:#e8f5e8
        style C fill:#e8f5e8
        style D fill:#e8f5e8
        style E fill:#e8f5e8
    end

    subgraph "비즈니스 로직 레이어"
        F[useMemos Hook<br/>상태 관리 & 비즈니스 로직]
        
        style F fill:#fff3e0
    end

    subgraph "데이터 레이어"
        G[Supabase Client<br/>데이터 액세스]
        H[Supabase Database<br/>PostgreSQL]
        
        style G fill:#fce4ec
        style H fill:#f3e5f5
    end

    subgraph "타입 & 유틸리티"
        I[memo.ts<br/>타입 정의]
        J[seedData.ts<br/>샘플 데이터]
        
        style I fill:#e0f2f1
        style J fill:#e0f2f1
    end

    subgraph "Next.js 프레임워크"
        K[App Router<br/>라우팅]
        L[Client Components<br/>CSR]
        
        style K fill:#f1f8e9
        style L fill:#f1f8e9
    end

    %% 데이터 플로우
    A --> F
    B --> F
    C --> F
    F --> G
    G --> H

    %% 타입 의존성
    F -.-> I
    A -.-> I
    B -.-> I
    C -.-> I
    G -.-> I

    %% 샘플 데이터
    J --> G

    %% Next.js 레이어
    K --> A
    L --> A
    L --> B
    L --> C
    L --> D
    L --> E
```

## 컴포넌트별 역할

### UI 컴포넌트
- **page.tsx**: 애플리케이션의 메인 페이지, 전체 레이아웃과 상태 관리
- **MemoList**: 메모 목록 표시, 검색/필터링 기능
- **MemoForm**: 메모 생성/수정 폼 (모달 방식)
- **MemoItem**: 개별 메모 카드 표시
- **MemoViewer**: 메모 상세 보기 (읽기 전용)

### 비즈니스 로직
- **useMemos Hook**: 메모 CRUD, 검색, 필터링, 통계 등 모든 비즈니스 로직 관리

### 데이터 레이어
- **Supabase Client**: Supabase 데이터베이스와의 인터페이스, 실시간 기능 지원
- **Supabase Database**: PostgreSQL 기반 클라우드 데이터베이스

### 지원 요소
- **memo.ts**: 타입 정의 (Memo, MemoFormData, Category 등)
- **seedData.ts**: 초기 샘플 데이터 생성

## 주요 데이터 플로우

1. **메모 생성**: UI → useMemos → Supabase Client → PostgreSQL Database
2. **메모 조회**: PostgreSQL Database → Supabase Client → useMemos → UI
3. **메모 수정**: UI → useMemos → Supabase Client → PostgreSQL Database
4. **메모 삭제**: UI → useMemos → Supabase Client → PostgreSQL Database
5. **검색/필터링**: UI → useMemos (클라이언트 사이드 필터링)

## 기술 스택

- **Frontend**: Next.js 15, React 19, TypeScript
- **Backend**: Supabase (PostgreSQL + Real-time + Auth)
- **스타일링**: Tailwind CSS
- **상태 관리**: React Hooks (useState, useEffect, useMemo, useCallback)
- **데이터베이스**: PostgreSQL (via Supabase)
- **API**: Supabase Client Library (@supabase/supabase-js)
- **테스팅**: Playwright
- **개발 도구**: ESLint, Prettier

## 특징

- **풀스택 애플리케이션**: Supabase 백엔드와 완전 통합
- **실시간 기능**: Supabase Realtime으로 실시간 데이터 동기화 가능
- **클라우드 기반**: 안정적인 PostgreSQL 데이터베이스
- **타입 안전성**: TypeScript로 완전한 타입 안전성 보장
- **반응형 UI**: Tailwind CSS 기반 모바일 친화적 인터페이스
- **확장 가능한 아키텍처**: 인증, 파일 저장소 등 추가 기능 확장 용이

## 확장 가능성

- **사용자 인증**: Supabase Auth로 다중 사용자 지원
- **실시간 협업**: Supabase Realtime으로 실시간 메모 공유
- **파일 첨부**: Supabase Storage로 이미지/파일 첨부 기능
- **PWA**: 오프라인 기능과 푸시 알림
- **모바일 앱**: React Native로 네이티브 앱 확장
- 파일 첨부, 이미지 지원 등 확장 기능 추가 가능