-- Add team_size column to tournaments table
ALTER TABLE tournaments
    ADD COLUMN IF NOT EXISTS team_size INTEGER DEFAULT 4;

COMMENT ON COLUMN tournaments.team_size IS
'Number of members per team for team tournaments. Default: 4.';
