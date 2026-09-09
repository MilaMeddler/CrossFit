-- Allow public (anon) INSERT for team self-registration
-- Athletes type their own names + create their team

-- Athletes: allow public insert (find-or-create by name)
DROP POLICY IF EXISTS "athletes_insert_public" ON athletes;
CREATE POLICY "athletes_insert_public" ON athletes
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

-- Teams: allow public insert
DROP POLICY IF EXISTS "teams_insert_public" ON teams;
CREATE POLICY "teams_insert_public" ON teams
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);
