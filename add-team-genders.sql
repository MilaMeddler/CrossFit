-- Add team gender category support
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
