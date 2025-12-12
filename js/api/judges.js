// api/judges.js
import { supabase } from "./supabase.js";

export const JudgesAPI = {
    async getAll() {
        const { data, error } = await supabase
            .from("judges")
            .select("*")
            .order("name");

        if (error) throw error;
        return data;
    },

    async create(j) {
        const { data, error } = await supabase
            .from("judges")
            .insert(j)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async delete(id) {
        const { error } = await supabase
            .from("judges")
            .delete()
            .eq("id", id);

        if (error) throw error;
        return true;
    }
};
