-- ============================================
-- ADD ACTIVE DIVISIONS TO TOURNAMENTS
-- ============================================
-- Добавляет поддержку настраиваемых дивизионов для турниров
-- с фиксированным порядком приоритета:
-- Elite (1) > RX (2) > Intermédiaire (3) > Scaled (4) > Foundations (5)
-- ============================================

-- 1. Добавить колонку active_divisions в таблицу tournaments
ALTER TABLE tournaments
    ADD COLUMN IF NOT EXISTS active_divisions TEXT[]
    DEFAULT ARRAY['rx', 'scaled', 'foundations'];

-- 2. Обновить существующие турниры (если нужно)
-- По умолчанию все турниры будут использовать ['rx', 'scaled', 'foundations']
-- Это можно изменить в админке для каждого турнира

-- 3. Добавить комментарий к колонке
COMMENT ON COLUMN tournaments.active_divisions IS
'Активные дивизионы для турнира в порядке приоритета.
Возможные значения: elite, rx, intermediaire, scaled, foundations.
Порядок приоритета всегда фиксированный: elite > rx > intermediaire > scaled > foundations';

-- ============================================
-- VERIFICATION
-- ============================================
-- Проверить что колонка добавлена:
-- SELECT id, name, is_open, active_divisions FROM tournaments;

-- Пример установки дивизионов для турнира:
-- UPDATE tournaments
-- SET active_divisions = ARRAY['elite', 'rx', 'scaled']
-- WHERE id = 1;

-- ============================================
-- NOTES
-- ============================================
-- Значения дивизионов в массиве (нижний регистр):
-- - 'elite'         - Elite (высший уровень)
-- - 'rx'            - RX (элитный)
-- - 'intermediaire' - Intermédiaire (средний)
-- - 'scaled'        - Scaled (масштабированный)
-- - 'foundations'   - Foundations (базовый)
--
-- Для обычных турниров (is_open = false):
-- - Дивизион фиксируется в tournament_participants.division
-- - При подсчёте используется логика Open с тайбрейками
--
-- Для Open турниров (is_open = true):
-- - Дивизион указывается в scores.division для каждого результата
-- - Логика остаётся прежней
-- ============================================
