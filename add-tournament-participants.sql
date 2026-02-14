-- ============================================
-- ADD TOURNAMENT PARTICIPANTS TABLE
-- ============================================
-- This creates a registration system where athletes
-- are registered for specific tournaments with a level
-- ============================================

-- Create tournament_participants table
CREATE TABLE IF NOT EXISTS tournament_participants (
    id SERIAL PRIMARY KEY,
    tournament_id INTEGER NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    athlete_id INTEGER NOT NULL REFERENCES athletes(id) ON DELETE CASCADE,
    level VARCHAR(10) NOT NULL, -- RX, INTER, SCALE for this specific tournament
    created_at TIMESTAMP DEFAULT NOW(),

    -- One athlete can only be registered once per tournament
    UNIQUE(tournament_id, athlete_id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_tournament_participants_tournament
    ON tournament_participants(tournament_id);

CREATE INDEX IF NOT EXISTS idx_tournament_participants_athlete
    ON tournament_participants(athlete_id);

-- Enable RLS (Row Level Security)
ALTER TABLE tournament_participants ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "tournament_participants_select_public" ON tournament_participants;
DROP POLICY IF EXISTS "tournament_participants_insert_admin" ON tournament_participants;
DROP POLICY IF EXISTS "tournament_participants_update_admin" ON tournament_participants;
DROP POLICY IF EXISTS "tournament_participants_delete_admin" ON tournament_participants;

-- Public: Can read all registrations
CREATE POLICY "tournament_participants_select_public" ON tournament_participants
    FOR SELECT
    USING (true);

-- Admin only: Insert, Update, Delete
CREATE POLICY "tournament_participants_insert_admin" ON tournament_participants
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournament_participants_update_admin" ON tournament_participants
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournament_participants_delete_admin" ON tournament_participants
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- NOTES
-- ============================================
-- After creating this table, you need to:
-- 1. Register athletes for tournaments via admin panel
-- 2. Update leaderboard.html to load only registered participants
-- 3. Update athlete.html to check if athlete is registered
--
-- The old 'level' column in 'athletes' table can stay for reference,
-- but level per tournament will now come from tournament_participants
-- ============================================

-- Example query to get participants for a tournament:
-- SELECT tp.*, a.first_name, a.last_name, a.gender
-- FROM tournament_participants tp
-- JOIN athletes a ON tp.athlete_id = a.id
-- WHERE tp.tournament_id = 1
-- ORDER BY a.last_name;
