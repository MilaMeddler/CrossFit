# Security Fix: Maintenance Mode Toggle Error

## Problem

The maintenance mode toggle switch in the admin panel shows the error:
```
❌ Erreur lors de la mise à jour
```

## Root Cause

The `app_settings` table was missing Row Level Security (RLS) policies. When RLS is enabled on a table without proper policies, even authenticated users cannot access it.

## Solution

Apply the RLS policies for the `app_settings` table to allow:
- **Public (anyone)**: Can read settings (SELECT)
- **Authenticated admins**: Can insert/update settings (INSERT/UPDATE)

## How to Fix

### Option 1: Quick Fix (Apply specific file)

Run the fix script in Supabase SQL Editor:

```bash
# Copy the content of fix-app-settings-permissions.sql
# Then paste and run it in Supabase Dashboard > SQL Editor
```

### Option 2: Full Security Policies (Recommended)

Re-run the complete security policies file which now includes app_settings:

```bash
# Run the updated supabase-security-policies.sql in Supabase SQL Editor
# This will update all security policies including app_settings
```

## Verification

After applying the fix, verify the policies are active:

```sql
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE tablename = 'app_settings';
```

You should see 3 policies:
1. `app_settings_select_public` (SELECT)
2. `app_settings_insert_admin` (INSERT)
3. `app_settings_update_admin` (UPDATE)

## Testing

1. Log in to the admin panel
2. Try toggling the "Mode maintenance" switch
3. It should now work without errors
4. Check the status changes between ON/OFF

## Files Modified

- `supabase-security-policies.sql` - Updated to include app_settings policies
- `fix-app-settings-permissions.sql` - Standalone fix script (NEW)
- `SECURITY_FIX_README.md` - This documentation (NEW)
