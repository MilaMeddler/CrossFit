-- ============================================
-- RENAME level TO division IN tournament_participants
-- ============================================
-- This migration renames the 'level' column to 'division'
-- to maintain consistency across Open and regular competitions
-- ============================================

-- Rename the column
ALTER TABLE tournament_participants
    RENAME COLUMN level TO division;

-- Update comment
COMMENT ON COLUMN tournament_participants.division IS 'Division for this tournament: RX, INTER, SCALE, or for Open: rx, scaled, foundations';

-- ============================================
-- VERIFICATION
-- ============================================
-- Check the column was renamed:
-- SELECT column_name, data_type FROM information_schema.columns
-- WHERE table_name = 'tournament_participants' AND column_name = 'division';
