-- ============================================
-- ADD ATHLETES + REGISTER FOR OPEN 2026
-- ============================================
-- Run in Supabase SQL Editor
-- ============================================

-- Step 1: Insert athletes (skip if already exists by name)
INSERT INTO athletes (first_name, last_name, gender, level)
VALUES
    ('Mylene',           'Jamon',          'F', 'RX'),
    ('Marie Christine',  'Cote',           'F', 'RX'),
    ('Valentin',         'Chabanal',       'M', 'RX'),
    ('Patrice',          'Lelievre',       'M', 'RX'),
    ('Fabien',           'Lemarchandel',   'M', 'RX'),
    ('Franck',           'Carandante',     'M', 'RX'),
    ('Maxence',          'Gourdon',        'M', 'RX'),
    ('Nadege',           'Challande',      'F', 'RX'),
    ('Barbara',          'Cornuaud',       'F', 'RX'),
    ('Melanie',          'Chauvet',        'F', 'RX')
ON CONFLICT DO NOTHING;

-- Step 2: Register them for OPEN 2026 with level RX
-- (ON CONFLICT DO NOTHING = safe to run multiple times)
INSERT INTO tournament_participants (tournament_id, athlete_id, level)
SELECT
    (SELECT id FROM tournaments WHERE name ILIKE '%OPEN 2026%' LIMIT 1),
    a.id,
    'RX'
FROM athletes a
WHERE (a.first_name, a.last_name) IN (
    ('Mylene',          'Jamon'),
    ('Marie Christine', 'Cote'),
    ('Valentin',        'Chabanal'),
    ('Patrice',         'Lelievre'),
    ('Fabien',          'Lemarchandel'),
    ('Franck',          'Carandante'),
    ('Maxence',         'Gourdon'),
    ('Nadege',          'Challande'),
    ('Barbara',         'Cornuaud'),
    ('Melanie',         'Chauvet')
)
ON CONFLICT (tournament_id, athlete_id) DO NOTHING;

-- ============================================
-- VERIFICATION
-- ============================================
-- Check athletes were inserted:
-- SELECT id, first_name, last_name, gender, level FROM athletes ORDER BY last_name;

-- Check participants for OPEN 2026:
-- SELECT tp.id, a.first_name, a.last_name, a.gender, tp.level
-- FROM tournament_participants tp
-- JOIN athletes a ON a.id = tp.athlete_id
-- JOIN tournaments t ON t.id = tp.tournament_id
-- WHERE t.name ILIKE '%OPEN 2026%'
-- ORDER BY a.last_name;
