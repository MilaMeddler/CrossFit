// ====================================
// КОНФИГУРАЦИЯ ПРИЛОЖЕНИЯ
// ====================================
// 
// ИНСТРУКЦИЯ:
// 1. Установите Google Apps Script (файл Code.gs)
// 2. Deploy → New deployment → Web app
// 3. Скопируйте URL Web App
// 4. Вставьте URL ниже вместо 'ВСТАВЬТЕ_ВАШ_URL_ЗДЕСЬ'

const CONFIG = {
    // URL вашего Google Apps Script Web App
    WEB_APP_URL: 'ВСТАВЬТЕ_ВАШ_URL_ЗДЕСЬ',
    
    // Время автообновления для leaderboard (миллисекунды)
    AUTO_REFRESH_INTERVAL: 10000, // 10 секунд
    
    // Timeout для запросов (миллисекунды)
    REQUEST_TIMEOUT: 15000 // 15 секунд
};

window.CONFIG = CONFIG;
