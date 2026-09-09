-- Fix active_divisions for tournaments that were created with old code
-- (which saved all 5 divisions for Open format tournaments)
--
-- Run this in Supabase SQL Editor to see which tournaments need fixing:
SELECT id, name, is_open, competition_type, active_divisions
FROM tournaments
ORDER BY id DESC;

-- After identifying the tournament ID, update it:
-- Example for Open team tournament with only rx, scaled, foundations:
-- UPDATE tournaments
--     SET active_divisions = ARRAY['rx', 'scaled', 'foundations']
--     WHERE id = <YOUR_TOURNAMENT_ID>;

-- Example for regular tournament with elite, rx, scaled:
-- UPDATE tournaments
--     SET active_divisions = ARRAY['elite', 'rx', 'scaled']
--     WHERE id = <YOUR_TOURNAMENT_ID>;
