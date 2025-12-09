// ====================================
// API CLIENT - JSONP для обхода CORS
// ====================================

class CrossFitAPI {
    constructor(webAppUrl) {
        this.webAppUrl = webAppUrl;
        this.callbackCounter = 0;
    }

    // Универсальный метод для JSONP запросов
    jsonpRequest(action, data = null) {
        return new Promise((resolve, reject) => {
            const callbackName = 'jsonp_callback_' + (++this.callbackCounter);
            const timeout = setTimeout(() => {
                cleanup();
                reject(new Error('Request timeout'));
            }, window.CONFIG.REQUEST_TIMEOUT);

            window[callbackName] = (response) => {
                cleanup();
                if (response.error) {
                    reject(new Error(response.error));
                } else {
                    resolve(response);
                }
            };

            const cleanup = () => {
                clearTimeout(timeout);
                delete window[callbackName];
                if (script.parentNode) {
                    script.parentNode.removeChild(script);
                }
            };

            let url = `${this.webAppUrl}?action=${action}&callback=${callbackName}`;
            
            if (data) {
                // Для POST данных отправляем через URL параметры (ограничение JSONP)
                url += '&data=' + encodeURIComponent(JSON.stringify(data));
            }

            const script = document.createElement('script');
            script.src = url;
            script.onerror = () => {
                cleanup();
                reject(new Error('Script load error'));
            };

            document.body.appendChild(script);
        });
    }

    // GET запросы
    async getAllData() {
        return await this.jsonpRequest('getAllData');
    }

    async getAthletes() {
        return await this.jsonpRequest('getAthletes');
    }

    async getWODs() {
        return await this.jsonpRequest('getWODs');
    }

    async getResults() {
        return await this.jsonpRequest('getResults');
    }

    async getSettings() {
        return await this.jsonpRequest('getSettings');
    }

    // POST запросы (через GET с параметром data)
    async addAthlete(athlete) {
        return await this.jsonpRequest('addAthlete', athlete);
    }

    async addWOD(wod) {
        return await this.jsonpRequest('addWOD', wod);
    }

    async addResult(result) {
        return await this.jsonpRequest('addResult', result);
    }

    async deleteAthlete(id) {
        return await this.jsonpRequest('deleteAthlete', { id });
    }

    async deleteWOD(id) {
        return await this.jsonpRequest('deleteWOD', { id });
    }

    async deleteResult(id) {
        return await this.jsonpRequest('deleteResult', { id });
    }

    async updateSettings(settings) {
        return await this.jsonpRequest('updateSettings', settings);
    }
}

// Инициализация API
let api;

function initAPI() {
    if (!window.CONFIG || !window.CONFIG.WEB_APP_URL || window.CONFIG.WEB_APP_URL === 'ВСТАВЬТЕ_ВАШ_URL_ЗДЕСЬ') {
        console.error('❌ Google Apps Script URL not configured!');
        console.error('Please edit config.js and add your Web App URL');
        return null;
    }
    
    api = new CrossFitAPI(window.CONFIG.WEB_APP_URL);
    console.log('✅ API initialized');
    return api;
}

// Вспомогательные функции для показа сообщений
function showMessage(text, type = 'info') {
    const msg = document.getElementById('status-message');
    if (!msg) return;
    
    msg.textContent = text;
    msg.className = 'status-message ';
    
    switch(type) {
        case 'success':
            msg.className += 'status-success';
            break;
        case 'error':
            msg.className += 'status-error';
            break;
        case 'warning':
            msg.className += 'status-warning';
            break;
        default:
            msg.className += 'status-info';
    }
    
    msg.classList.remove('hidden');
    
    setTimeout(() => {
        msg.classList.add('hidden');
    }, 3000);
}

function showLoading(show = true) {
    const loader = document.getElementById('loading');
    if (loader) {
        if (show) {
            loader.classList.remove('hidden');
        } else {
            loader.classList.add('hidden');
        }
    }
}

// Проверка конфигурации при загрузке
document.addEventListener('DOMContentLoaded', () => {
    if (!window.CONFIG || window.CONFIG.WEB_APP_URL === 'ВСТАВЬТЕ_ВАШ_URL_ЗДЕСЬ') {
        const body = document.body;
        const warning = document.createElement('div');
        warning.className = 'config-warning';
        warning.innerHTML = `
            <h2>⚠️ Configuration Required</h2>
            <p>Please configure your Google Apps Script URL in <code>config.js</code></p>
            <ol>
                <li>Open your Google Sheet</li>
                <li>Extensions → Apps Script</li>
                <li>Copy the code from <code>Code.gs</code></li>
                <li>Deploy → New deployment → Web app</li>
                <li>Copy the URL and paste it in <code>config.js</code></li>
            </ol>
        `;
        body.insertBefore(warning, body.firstChild);
    }
});
