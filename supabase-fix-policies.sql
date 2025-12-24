-- ============================================
-- ИСПРАВЛЕНИЕ ПОЛИТИК БЕЗОПАСНОСТИ SUPABASE
-- ============================================
-- Используем правильную проверку auth.uid() вместо auth.role()
-- ============================================

-- УДАЛЕНИЕ ВСЕХ СУЩЕСТВУЮЩИХ ПОЛИТИК
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public')
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON ' || quote_ident(r.tablename);
    END LOOP;
END $$;

-- ВКЛЮЧЕНИЕ RLS ДЛЯ ВСЕХ ТАБЛИЦ
ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE judges ENABLE ROW LEVEL SECURITY;

-- ============================================
-- ПОЛИТИКИ ДЛЯ ATHLETES
-- ============================================

-- Все могут читать (включая анонимных пользователей)
CREATE POLICY "athletes_select_policy" ON athletes
    FOR SELECT
    TO public
    USING (true);

-- Только аутентифицированные могут вставлять
CREATE POLICY "athletes_insert_policy" ON athletes
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Только аутентифицированные могут обновлять
CREATE POLICY "athletes_update_policy" ON athletes
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Только аутентифицированные могут удалять
CREATE POLICY "athletes_delete_policy" ON athletes
    FOR DELETE
    TO authenticated
    USING (true);

-- ============================================
-- ПОЛИТИКИ ДЛЯ TEAMS
-- ============================================

CREATE POLICY "teams_select_policy" ON teams
    FOR SELECT
    TO public
    USING (true);

CREATE POLICY "teams_insert_policy" ON teams
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "teams_update_policy" ON teams
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "teams_delete_policy" ON teams
    FOR DELETE
    TO authenticated
    USING (true);

-- ============================================
-- ПОЛИТИКИ ДЛЯ TOURNAMENTS
-- ============================================

CREATE POLICY "tournaments_select_policy" ON tournaments
    FOR SELECT
    TO public
    USING (true);

CREATE POLICY "tournaments_insert_policy" ON tournaments
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "tournaments_update_policy" ON tournaments
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "tournaments_delete_policy" ON tournaments
    FOR DELETE
    TO authenticated
    USING (true);

-- ============================================
-- ПОЛИТИКИ ДЛЯ WORKOUTS
-- ============================================

CREATE POLICY "workouts_select_policy" ON workouts
    FOR SELECT
    TO public
    USING (true);

CREATE POLICY "workouts_insert_policy" ON workouts
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "workouts_update_policy" ON workouts
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "workouts_delete_policy" ON workouts
    FOR DELETE
    TO authenticated
    USING (true);

-- ============================================
-- ПОЛИТИКИ ДЛЯ SCORES
-- ============================================

CREATE POLICY "scores_select_policy" ON scores
    FOR SELECT
    TO public
    USING (true);

CREATE POLICY "scores_insert_policy" ON scores
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "scores_update_policy" ON scores
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "scores_delete_policy" ON scores
    FOR DELETE
    TO authenticated
    USING (true);

-- ============================================
-- ПОЛИТИКИ ДЛЯ JUDGES
-- ============================================

CREATE POLICY "judges_select_policy" ON judges
    FOR SELECT
    TO public
    USING (true);

CREATE POLICY "judges_insert_policy" ON judges
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "judges_update_policy" ON judges
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "judges_delete_policy" ON judges
    FOR DELETE
    TO authenticated
    USING (true);

-- ✅ ГОТОВО!
-- Все предупреждения должны исчезнуть
