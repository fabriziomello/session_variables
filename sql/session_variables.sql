/*
 * Author: Fabrízio de Royes Mello
 * Created at: Thu Oct 27 14:37:36 -0200 2011
 *
 */

CREATE FUNCTION set_value(TEXT, TEXT) RETURNS void AS $$
BEGIN
  PERFORM set_config('session_variables.'||$1, $2, false);
  RETURN;
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION set_value(TEXT, TEXT) IS
'Create/Assign value to a new/existing session variable';

SET check_function_bodies TO OFF;
CREATE FUNCTION get_value(TEXT) RETURNS TEXT AS $$
  SELECT current_setting('session_variables.'||$1);
$$ LANGUAGE sql;
COMMENT ON FUNCTION get_value(TEXT) IS
'Returns the value of session variable passed as a parameter';

