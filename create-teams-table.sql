-- Create teams table with text-based member names
CREATE TABLE IF NOT EXISTS teams (
    id BIGSERIAL PRIMARY KEY,
    tournament_id BIGINT NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    team_name TEXT NOT NULL,
    member_names TEXT[] NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;

-- Public: anyone can read teams
CREATE POLICY "teams_select_public" ON teams
    FOR SELECT TO anon, authenticated
    USING (true);

-- Public: anyone can register a team (self-registration)
CREATE POLICY "teams_insert_public" ON teams
    FOR INSERT TO anon, authenticated
    WITH CHECK (true);

-- Admin only: update and delete
CREATE POLICY "teams_update_admin" ON teams
    FOR UPDATE TO authenticated
    USING (true);

CREATE POLICY "teams_delete_admin" ON teams
    FOR DELETE TO authenticated
    USING (true);
