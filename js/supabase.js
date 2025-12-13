import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm";

const SUPABASE_URL = "https://gbdanipvnqrggjjoebtn.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdiZGFuaXB2bnFyZ2dqam9lYnRuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzNjYyNzUsImV4cCI6MjA4MDk0MjI3NX0.cRSuKatOSWgcbyhqAJ_5oWnENZK5sQZaZiGL15uytME";


export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

export function handleSupabaseError(context, error) {
    console.error(`Supabase Error in ${context}:`, error);
    return {
        success: false,
        error: error?.message || error
    };
}
