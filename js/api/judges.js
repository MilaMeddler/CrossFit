// api/judges.js
import { supabase } from "../supabase.js";

export const JudgesAPI = {
    async getAll() {
        const { data, error } = await supabase
            .from("judges")
            .select("*")
            .order("name");

        if (error) throw error;
        return data;
    },

    async create(judge) {
        const { data, error } = await supabase
            .from("judges")
            .insert(judge)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async update(id, dataUpdate) {
        const { data, error } = await supabase
            .from("judges")
            .update(dataUpdate)
            .eq("id", id)
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

