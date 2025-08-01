# 메모 앱 시스템 아키텍처

## 개요

Next.js 기반의 클라이언트 사이드 메모 관리 애플리케이션으로, 로컬스토리지를 데이터 저장소로 사용하는 SPA 구조입니다.

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
        G[localStorageUtils<br/>데이터 액세스]
        H[Browser LocalStorage<br/>데이터 저장소]
        
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
- **localStorageUtils**: 브라우저 로컬스토리지와의 인터페이스
- **Browser LocalStorage**: 실제 데이터 저장소

### 지원 요소
- **memo.ts**: 타입 정의 (Memo, MemoFormData, Category 등)
- **seedData.ts**: 초기 샘플 데이터 생성

## 주요 데이터 플로우

1. **메모 생성**: UI → useMemos → localStorageUtils → LocalStorage
2. **메모 조회**: LocalStorage → localStorageUtils → useMemos → UI
3. **메모 수정**: UI → useMemos → localStorageUtils → LocalStorage
4. **메모 삭제**: UI → useMemos → localStorageUtils → LocalStorage
5. **검색/필터링**: UI → useMemos (메모리 내 필터링)

## 기술 스택

- **Frontend**: Next.js 15, React 19, TypeScript
- **스타일링**: Tailwind CSS
- **상태 관리**: React Hooks (useState, useEffect, useMemo, useCallback)
- **데이터 저장**: Browser LocalStorage
- **테스팅**: Playwright
- **개발 도구**: ESLint, Prettier

## 특징

- **클라이언트 사이드 앱**: 별도 백엔드 없이 브라우저에서 완전 동작
- **실시간 검색**: 메모리 내에서 즉시 검색/필터링
- **반응형 UI**: Tailwind CSS 기반 모바일 친화적 인터페이스
- **타입 안전성**: TypeScript로 완전한 타입 안전성 보장
- **컴포넌트 재사용**: 모듈화된 컴포넌트 구조

## 확장 가능성

- 백엔드 API 연동을 위한 데이터 레이어 추상화 준비
- PWA 기능 추가 가능
- 실시간 동기화 기능 확장 가능
- 파일 첨부, 이미지 지원 등 확장 기능 추가 가능