\set ECHO 0
BEGIN;
\i sql/session_variables.sql
\set ECHO all

-- Tests goes here.

ROLLBACK;
