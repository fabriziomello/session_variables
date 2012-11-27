\set ECHO 0
BEGIN;
\i sql/session_variables.sql
\set ECHO all
SELECT set_value('key', 'value');
SELECT set_value('Key', 'Value');
SELECT set_value('KEY', 'VALUE');
SELECT get_value('key');
SELECT get_value('Key');
SELECT get_value('KEY');
ROLLBACK;
