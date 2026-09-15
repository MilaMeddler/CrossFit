-- Add team gender category support
-- Run in Supabase SQL Editor

ALTER TABLE tournaments
    ADD COLUMN IF NOT EXISTS team_genders TEXT[];

COMMENT ON COLUMN tournaments.team_genders IS
'Gender categories allowed for team tournament (e.g. ["mixte","hommes","femmes"]).
If only one value, no gender selection shown at registration or leaderboard filter.
NULL means no gender restriction (treated as ["mixte"]).';

ALTER TABLE teams
    ADD COLUMN IF NOT EXISTS gender TEXT;

COMMENT ON COLUMN teams.gender IS
'Gender category of the team: mixte, hommes, or femmes.
NULL if tournament has only one gender category.';

-- Explicit grants (required for new tables from Oct 30, 2026 — good practice always)
-- These columns are on existing tables so grants already exist,
-- but if you ever recreate the tables, include these:

-- GRANT SELECT ON public.tournaments TO anon;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON public.tournaments TO authenticated;
-- GRANT SELECT, INSERT ON public.teams TO anon;
-- GRANT SELECT, UPDATE, DELETE ON public.teams TO authenticated;
