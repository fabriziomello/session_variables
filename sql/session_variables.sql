/*
 * Author: Fabrízio de Royes Mello
 * Created at: Thu Oct 27 14:37:36 -0200 2011
 *
 */ 

CREATE FUNCTION get_value(TEXT) RETURNS TEXT AS $$
  SELECT key FROM session_variables WHERE key = $1;
$$ LANGUAGE sql;
COMMENT ON FUNCTION get_value(TEXT) IS
'Returns the value of session variable passed by parameter';


CREATE FUNCTION set_value(TEXT, TEXT) RETURNS void AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
      FROM pg_class
           JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
     WHERE relname = 'session_variables'
       AND relkind = 'r'
       AND nspname ~ '^pg_temp') THEN
    
    /* Just with 9.1+ version */
    CREATE TEMP UNLOGGED TABLE session_variables (
      key   TEXT,
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
COMMENT ON FUNCTION get_value(TEXT) IS
'Create/Set session variable with new value';


