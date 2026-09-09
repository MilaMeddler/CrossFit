-- Add division column to teams table
ALTER TABLE teams
    ADD COLUMN IF NOT EXISTS division TEXT;

COMMENT ON COLUMN teams.division IS
'Division for regular (non-Open) team tournaments. Set at team creation.
Values: elite, rx, intermediaire, scaled, foundations.
NULL for Open format tournaments (division is per WOD in scores table).';
