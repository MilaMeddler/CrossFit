-- Create app_settings table for maintenance mode and other global settings
create table if not exists app_settings (
  key text primary key,
  value text not null,
  updated_at timestamptz default now()
);

-- Insert initial maintenance_mode setting
insert into app_settings (key, value)
values ('maintenance_mode', 'false')
on conflict (key) do nothing;

-- Add comment for documentation
comment on table app_settings is 'Global application settings and configuration';
comment on column app_settings.key is 'Setting key (e.g., maintenance_mode)';
comment on column app_settings.value is 'Setting value as text';
comment on column app_settings.updated_at is 'Last update timestamp';
