-- ============================================
-- НАСТРОЙКА БЕЗОПАСНОСТИ ДЛЯ CROSSFIT БД
-- ============================================
--
-- Что делает этот скрипт:
-- 1. Включает RLS (Row Level Security) для всех таблиц
-- 2. Разрешает ВСЕМ читать данные (для публичного просмотра результатов)
-- 3. Разрешает изменять данные ТОЛЬКО аутентифицированным админам
--
-- ============================================

-- Включаем RLS для всех таблиц
ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE judges ENABLE ROW LEVEL SECURITY;

-- ============================================
-- ПОЛИТИКИ ДЛЯ ТАБЛИЦЫ ATHLETES (Атлеты)
-- ============================================

-- Все могут читать атлетов
CREATE POLICY "athletes_public_read" ON athletes
    FOR SELECT
    USING (true);

-- Только аутентифицированные могут добавлять атлетов
CREATE POLICY "athletes_authenticated_insert" ON athletes
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Только аутентифицированные могут изменять атлетов
CREATE POLICY "athletes_authenticated_update" ON athletes
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

-- Только аутентифицированные могут удалять атлетов
CREATE POLICY "athletes_authenticated_delete" ON athletes
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- ПОЛИТИКИ ДЛЯ ТАБЛИЦЫ TEAMS (Команды)
-- ============================================

CREATE POLICY "teams_public_read" ON teams
    FOR SELECT
    USING (true);

CREATE POLICY "teams_authenticated_insert" ON teams
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "teams_authenticated_update" ON teams
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "teams_authenticated_delete" ON teams
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- ПОЛИТИКИ ДЛЯ ТАБЛИЦЫ TOURNAMENTS (Турниры)
-- ============================================

CREATE POLICY "tournaments_public_read" ON tournaments
    FOR SELECT
    USING (true);

CREATE POLICY "tournaments_authenticated_insert" ON tournaments
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournaments_authenticated_update" ON tournaments
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournaments_authenticated_delete" ON tournaments
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- ПОЛИТИКИ ДЛЯ ТАБЛИЦЫ WORKOUTS (WOD-ы)
-- ============================================

CREATE POLICY "workouts_public_read" ON workouts
    FOR SELECT
    USING (true);

CREATE POLICY "workouts_authenticated_insert" ON workouts
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "workouts_authenticated_update" ON workouts
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "workouts_authenticated_delete" ON workouts
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- ПОЛИТИКИ ДЛЯ ТАБЛИЦЫ SCORES (Результаты)
-- ============================================

CREATE POLICY "scores_public_read" ON scores
    FOR SELECT
    USING (true);

CREATE POLICY "scores_authenticated_insert" ON scores
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "scores_authenticated_update" ON scores
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "scores_authenticated_delete" ON scores
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- ПОЛИТИКИ ДЛЯ ТАБЛИЦЫ JUDGES (Судьи)
-- ============================================

CREATE POLICY "judges_public_read" ON judges
    FOR SELECT
    USING (true);

CREATE POLICY "judges_authenticated_insert" ON judges
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "judges_authenticated_update" ON judges
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "judges_authenticated_delete" ON judges
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- ГОТОВО!
-- ============================================
--
-- Теперь:
-- ✅ Все могут читать данные (результаты, атлеты, турниры)
-- ✅ Только авторизованные админы могут изменять данные
-- ❌ Анонимные пользователи НЕ могут писать в базу
--
-- Следующий шаг: настроить Supabase Auth для админа
-- ============================================
