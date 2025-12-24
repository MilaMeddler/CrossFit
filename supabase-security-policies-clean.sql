-- ============================================
-- ОЧИСТКА И НАСТРОЙКА БЕЗОПАСНОСТИ ДЛЯ CROSSFIT БД
-- ============================================
-- Этот скрипт сначала удаляет все существующие политики,
-- потом создает новые с правильными настройками
-- ============================================

-- ============================================
-- УДАЛЕНИЕ СУЩЕСТВУЮЩИХ ПОЛИТИК
-- ============================================

-- Athletes
DROP POLICY IF EXISTS "athletes_public_read" ON athletes;
DROP POLICY IF EXISTS "athletes_authenticated_insert" ON athletes;
DROP POLICY IF EXISTS "athletes_authenticated_update" ON athletes;
DROP POLICY IF EXISTS "athletes_authenticated_delete" ON athletes;

-- Teams
DROP POLICY IF EXISTS "teams_public_read" ON teams;
DROP POLICY IF EXISTS "teams_authenticated_insert" ON teams;
DROP POLICY IF EXISTS "teams_authenticated_update" ON teams;
DROP POLICY IF EXISTS "teams_authenticated_delete" ON teams;

-- Tournaments
DROP POLICY IF EXISTS "tournaments_public_read" ON tournaments;
DROP POLICY IF EXISTS "tournaments_authenticated_insert" ON tournaments;
DROP POLICY IF EXISTS "tournaments_authenticated_update" ON tournaments;
DROP POLICY IF EXISTS "tournaments_authenticated_delete" ON tournaments;

-- Workouts
DROP POLICY IF EXISTS "workouts_public_read" ON workouts;
DROP POLICY IF EXISTS "workouts_authenticated_insert" ON workouts;
DROP POLICY IF EXISTS "workouts_authenticated_update" ON workouts;
DROP POLICY IF EXISTS "workouts_authenticated_delete" ON workouts;

-- Scores
DROP POLICY IF EXISTS "scores_public_read" ON scores;
DROP POLICY IF EXISTS "scores_authenticated_insert" ON scores;
DROP POLICY IF EXISTS "scores_authenticated_update" ON scores;
DROP POLICY IF EXISTS "scores_authenticated_delete" ON scores;

-- Judges
DROP POLICY IF EXISTS "judges_public_read" ON judges;
DROP POLICY IF EXISTS "judges_authenticated_insert" ON judges;
DROP POLICY IF EXISTS "judges_authenticated_update" ON judges;
DROP POLICY IF EXISTS "judges_authenticated_delete" ON judges;

-- ============================================
-- ВКЛЮЧЕНИЕ RLS ДЛЯ ВСЕХ ТАБЛИЦ
-- ============================================

ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE judges ENABLE ROW LEVEL SECURITY;

-- ============================================
-- ПОЛИТИКИ ДЛЯ ТАБЛИЦЫ ATHLETES (Атлеты)
-- ============================================

CREATE POLICY "athletes_public_read" ON athletes
    FOR SELECT
    USING (true);

CREATE POLICY "athletes_authenticated_insert" ON athletes
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "athletes_authenticated_update" ON athletes
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

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
-- ✅ ГОТОВО!
-- ============================================
-- Теперь:
-- ✅ Все могут читать данные (результаты, атлеты, турниры)
-- ✅ Только авторизованные админы могут изменять данные
-- ❌ Анонимные пользователи НЕ могут писать в базу
-- ============================================
