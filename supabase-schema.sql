-- Memo 애플리케이션을 위한 Supabase 스키마
-- 기존 메모 타입 인터페이스와 완전 호환되도록 설계

-- memos 테이블 생성
CREATE TABLE IF NOT EXISTS public.memos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    category TEXT NOT NULL,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- updated_at 자동 업데이트를 위한 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- updated_at 트리거 생성
CREATE TRIGGER update_memos_updated_at 
    BEFORE UPDATE ON public.memos 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_memos_category ON public.memos(category);
CREATE INDEX IF NOT EXISTS idx_memos_created_at ON public.memos(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_memos_title ON public.memos(title);
CREATE INDEX IF NOT EXISTS idx_memos_tags ON public.memos USING GIN(tags);

-- RLS (Row Level Security) 정책 (현재는 모든 사용자가 접근 가능)
-- 향후 사용자 인증을 추가할 때 수정 가능
ALTER TABLE public.memos ENABLE ROW LEVEL SECURITY;

-- 모든 사용자가 모든 메모에 접근 가능한 정책 (임시)
CREATE POLICY "Enable all access for memos" ON public.memos
    FOR ALL USING (true);

-- 샘플 데이터 삽입 (선택사항)
INSERT INTO public.memos (title, content, category, tags) VALUES
    ('첫 번째 메모', '안녕하세요! 첫 번째 메모입니다.', 'personal', ARRAY['환영', '시작']),
    ('프로젝트 계획', 'React + Supabase 프로젝트 진행', 'work', ARRAY['프로젝트', 'React', 'Supabase']),
    ('학습 노트', 'TypeScript 고급 기능 학습', 'study', ARRAY['TypeScript', '학습'])
ON CONFLICT (id) DO NOTHING;