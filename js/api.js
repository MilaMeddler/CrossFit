// ====================================
// SUPABASE API CLIENT
// ====================================

// Создаём клиент Supabase
const supabase = window.supabase.createClient(
    window.CONFIG.SUPABASE_URL,
    window.CONFIG.SUPABASE_ANON_KEY
);

// Единый класс API (аналог старого JSONP)
class CrossFitAPI {
    constructor() {
        console.log("✅ Supabase API initialized");
    }

    // ==========================
    // COMPETITIONS
    // ==========================
    async getCompetitions() {
        const { data, error } = await supabase
            .from('competitions')
            .select('*')
            .order('id');

        if (error) throw error;
        return data;
    }

    // ==========================
    // ATHLETES
    // ==========================
    async getAthletes() {
        const { data, error } = await supabase
            .from('athletes')
            .select('*')
            .order('id');

        if (error) throw error;
        return data;
    }

    async addAthlete(athlete) {
        const { data, error } = await supabase
            .from('athletes')
            .insert(athlete)
            .select();

        if (error) throw error;
        return data;
    }

    async deleteAthlete(id) {
        const { error } = await supabase
            .from('athletes')
            .delete()
            .eq('id', id);

        if (error) throw error;
        return true;
    }

    // ==========================
    // WORKOUTS (WOD)
    // ==========================
    async getWODs() {
        const { data, error } = await supabase
            .from('workouts')
            .select('*')
            .order('id');

        if (error) throw error;
        return data;
    }

    async addWOD(wod) {
        const { data, error } = await supabase
            .from('workouts')
            .insert(wod)
            .select();

        if (error) throw error;
        return data;
    }

    async deleteWOD(id) {
        const { error } = await supabase
            .from('workouts')
            .delete()
            .eq('id', id);

        if (error) throw error;
        return true;
    }

    // ==========================
    // SCORES (RESULTS)
    // ==========================
    async getResults() {
        const { data, error } = await supabase
            .from('scores')
            .select('*')
            .order('id');

        if (error) throw error;
        return data;
    }

    async addResult(result) {
        const { data, error } = await supabase
            .from('scores')
            .insert(result)
            .select();

        if (error) throw error;
        return data;
    }

    async deleteResult(id) {
        const { error } = await supabase
            .from('scores')
            .delete()
            .eq('id', id);

        if (error) throw error;
        return true;
    }

    // ==========================
    // SETTINGS (если понадобится)
    // ==========================
    async getSettings() {
        const { data, error } = await supabase
            .from('settings')
            .select('*')
            .limit(1);

        if (error) throw error;
        return data?.[0] || {};
    }

    async updateSettings(settings) {
        const { data, error } = await supabase
            .from('settings')
            .update(settings)
            .eq('id', settings.id)
            .select();

        if (error) throw error;
        return data;
    }

    // ==========================
    // GET ALL DATA (как раньше)
    // ==========================
    async getAllData() {
        const [athletes, workouts, results, competitions] = await Promise.all([
            this.getAthletes(),
            this.getWODs(),
            this.getResults(),
            this.getCompetitions()
        ]);

        return {
            athletes,
            workouts,
            results,
            competitions
        };
    }
}


// ====================================
// ИНИЦИАЛИЗАЦИЯ API
// ====================================

let api = null;

function initAPI() {
    api = new CrossFitAPI();
    return api;
}


// ====================================
// UI HELPERS (оставляем без изменений)
// ====================================

function showMessage(text, type = 'info') {
    const msg = document.getElementById('status-message');
    if (!msg) return;

    msg.textContent = text;
    msg.className = 'status-message ';

    switch (type) {
        case 'success':
            msg.classList.add('status-success');
            break;
        case 'error':
            msg.classList.add('status-error');
            break;
        case 'warning':
            msg.classList.add('status-warning');
            break;
        default:
            msg.classList.add('status-info');
    }

    msg.classList.remove('hidden');

    setTimeout(() => msg.classList.add('hidden'), 3000);
}

function showLoading(show = true) {
    const loader = document.getElementById('loading');
    if (!loader) return;

    loader.classList.toggle('hidden', !show);
}

document.addEventListener('DOMContentLoaded', () => {
    initAPI();
});
