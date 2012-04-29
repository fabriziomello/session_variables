/*
 * Author: Fabrízio de Royes Mello
 * Created at: Thu Oct 27 14:37:36 -0200 2011
 *
 */ 

CREATE FUNCTION set_value(TEXT, TEXT) RETURNS void AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
      FROM pg_class
           JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
     WHERE relname = 'session_variables'
       AND relkind = 'r'
       AND nspname ~ '^pg_temp') THEN
    
    CREATE TEMP TABLE session_variables (
      key   TEXT NOT NULL PRIMARY KEY,
      value TEXT
    );
  END IF;

  IF get_value($1) IS NULL THEN
    INSERT INTO session_variables (key, value) VALUES($1, $2);
  ELSE
    UPDATE session_variables SET value = $2 WHERE key = $1;
  END IF;

  RETURN;
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION set_value(TEXT, TEXT) IS
'Create/Assign value to a new/existing session variable';

SET check_function_bodies TO OFF;
CREATE FUNCTION get_value(TEXT) RETURNS TEXT AS $$
  SELECT value 
    FROM session_variables 
   WHERE key = $1;
$$ LANGUAGE sql;
COMMENT ON FUNCTION get_value(TEXT) IS
'Returns the value of session variable passed as a parameter';

