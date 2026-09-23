-- Проверка структуры таблицы wod_results
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'wod_results'
ORDER BY ordinal_position;
