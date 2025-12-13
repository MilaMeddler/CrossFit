// api/athletes.js
import { supabase } from "../supabase.js";

export const AthletesAPI = {
    async getAll() {
        const { data, error } = await supabase
            .from("athletes")
            .select("*")
            .order("last_name");

        if (error) throw error;
        return data;
    },

    async create(ath) {
        const { data, error } = await supabase
            .from("athletes")
            .insert(ath)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async update(id, dataUpdate) {
        const { data, error } = await supabase
            .from("athletes")
            .update(dataUpdate)
            .eq("id", id)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async delete(id) {
        const { error } = await supabase
            .from("athletes")
            .delete()
            .eq("id", id);

        if (error) throw error;
        return true;
    }
};
