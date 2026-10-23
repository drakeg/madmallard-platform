# PostgreSQL initialization

This directory is reserved for vetted application-specific database initialization.

Do not place passwords in SQL files committed to Git. Use a one-time bootstrap
script with environment-provided secrets, or upstream application migrations.
Supabase requires its own supported database roles, extensions, and migrations;
do not point it at an uninitialized generic PostgreSQL database.

Initialization scripts run only when the PostgreSQL volume is empty.
