--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.12 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: auto_post_task_completion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_post_task_completion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.completed = TRUE AND (OLD.completed IS NULL OR OLD.completed = FALSE) THEN
    INSERT INTO posts (challenge_id, user_id, username, content, created_at)
    SELECT 
      NEW.challenge_id,
      NEW.user_id,
      (SELECT username FROM profiles WHERE id = NEW.user_id),
      'Completed task: ' || NEW.action,
      NOW()
    WHERE EXISTS (SELECT 1 FROM challenges WHERE id = NEW.challenge_id);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.auto_post_task_completion() OWNER TO postgres;

--
-- Name: cleanup_expired_stories(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_expired_stories() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  story_record RECORD;
  file_path TEXT;
BEGIN
  -- Get all expired stories
  FOR story_record IN
    SELECT id, media_url FROM stories 
    WHERE expires_at < NOW()
  LOOP
    -- Delete the associated storage file
    -- Extract the filename from the media_url
    IF story_record.media_url IS NOT NULL THEN
      -- Extract the file path after /stories/
      BEGIN
        file_path := SUBSTRING(story_record.media_url FROM '/stories/(.*)$');
        
        IF file_path IS NOT NULL AND file_path != '' THEN
          -- Delete the file from storage (ignore errors if file doesn't exist)
          BEGIN
            PERFORM storage.delete('stories', file_path);
          EXCEPTION WHEN OTHERS THEN
            -- Log error but continue processing
            RAISE NOTICE 'Error deleting storage object %: %', file_path, SQLERRM;
          END;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        -- Continue if path extraction fails
        RAISE NOTICE 'Could not parse file path from URL %: %', story_record.media_url, SQLERRM;
      END;
    END IF;
    
    -- Delete the story views related to this story
    BEGIN
      DELETE FROM story_views WHERE story_id = story_record.id;
    EXCEPTION WHEN OTHERS THEN
      -- Log error but continue processing
      RAISE NOTICE 'Error deleting story views for story %: %', story_record.id, SQLERRM;
    END;
    
    -- Delete the story itself
    BEGIN
      DELETE FROM stories WHERE id = story_record.id;
    EXCEPTION WHEN OTHERS THEN
      -- Log error
      RAISE NOTICE 'Error deleting story %: %', story_record.id, SQLERRM;
    END;
  END LOOP;
END;
$_$;


ALTER FUNCTION public.cleanup_expired_stories() OWNER TO postgres;

--
-- Name: increment_usage_count(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_usage_count(type_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE challenge_types
  SET usage_count = usage_count + 1
  WHERE id = type_id;
END;
$$;


ALTER FUNCTION public.increment_usage_count(type_id integer) OWNER TO postgres;

--
-- Name: insert_automated_post(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_automated_post(p_challenge_id uuid, p_content text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
  VALUES (p_challenge_id, p_content, '00000000-0000-0000-0000-000000000000', NOW(), '{}'::TEXT[]);
END;
$$;


ALTER FUNCTION public.insert_automated_post(p_challenge_id uuid, p_content text) OWNER TO postgres;

--
-- Name: notify_challenge_edit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_challenge_edit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Insert automated post
  INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
  VALUES (
    NEW.id,
    format('#%s has been updated!', NEW.title),
    '00000000-0000-0000-0000-000000000000',
    NOW(),
    '{}'::TEXT[]
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_challenge_edit() OWNER TO postgres;

--
-- Name: notify_challenge_time_remaining(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_challenge_time_remaining() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  challenge RECORD;
BEGIN
  FOR challenge IN
    SELECT id, title, end_datetime
    FROM challenges
    WHERE end_datetime > NOW()
  LOOP
    -- Calculate time remaining in minutes
    WITH time_diff AS (
      SELECT EXTRACT(EPOCH FROM (challenge.end_datetime - NOW())) / 60 AS minutes_left
    )
    -- Insert notifications based on time remaining
    INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
    SELECT
      challenge.id,
      CASE
        WHEN td.minutes_left <= 10 AND td.minutes_left > 9 THEN format('#%s ends in 10 minutes!', challenge.title)
        WHEN td.minutes_left <= 60 AND td.minutes_left > 59 THEN format('#%s ends in 1 hour!', challenge.title)
        WHEN td.minutes_left <= 1440 AND td.minutes_left > 1439 THEN format('#%s ends in 24 hours!', challenge.title)
        WHEN td.minutes_left <= 10080 AND td.minutes_left > 10079 THEN format('#%s ends in 1 week!', challenge.title)
        ELSE NULL
      END,
      '00000000-0000-0000-0000-000000000000',
      NOW(),
      '{}'::TEXT[]
    FROM time_diff td
    WHERE CASE
      WHEN td.minutes_left <= 10 AND td.minutes_left > 9 THEN true
      WHEN td.minutes_left <= 60 AND td.minutes_left > 59 THEN true
      WHEN td.minutes_left <= 1440 AND td.minutes_left > 1439 THEN true
      WHEN td.minutes_left <= 10080 AND td.minutes_left > 10079 THEN true
      ELSE false
    END
    ON CONFLICT DO NOTHING; -- Avoid duplicate notifications
  END LOOP;
END;
$$;


ALTER FUNCTION public.notify_challenge_time_remaining() OWNER TO postgres;

--
-- Name: notify_ranking_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_ranking_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  challenge_title TEXT;
  user_first_name TEXT;
  user_last_name TEXT;
  user_username TEXT;
  participant_count INT;
  top_10_percent INT;
BEGIN
  SELECT title INTO challenge_title
  FROM challenges
  WHERE id = NEW.challenge_id;

  SELECT first_name, last_name, username INTO user_first_name, user_last_name, user_username
  FROM profiles
  WHERE id = NEW.user_id;

  SELECT COUNT(*) INTO participant_count
  FROM challenge_participants
  WHERE challenge_id = NEW.challenge_id;

  top_10_percent := CEIL(participant_count * 0.1);

  IF (
    SELECT COUNT(*)
    FROM challenge_participants
    WHERE challenge_id = NEW.challenge_id
    AND score > NEW.score
  ) < top_10_percent THEN
    INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
    VALUES (
      NEW.challenge_id,
      format('<@%s> %s %s moved into the top 10%% of <#%s>!', user_username, user_first_name, user_last_name, challenge_title),
      NULL,
      NOW(),
      '{}'::TEXT[]
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_ranking_update() OWNER TO postgres;

--
-- Name: notify_task_completion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_task_completion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  challenge_title TEXT;
  user_first_name TEXT;
  user_last_name TEXT;
  user_username TEXT;
BEGIN
  SELECT title INTO challenge_title
  FROM challenges
  WHERE id = NEW.challenge_id;

  SELECT first_name, last_name, username INTO user_first_name, user_last_name, user_username
  FROM profiles
  WHERE id = NEW.user_id;

  INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
  VALUES (
    NEW.challenge_id,
    format('<@%s> %s %s completed a task in <#%s>!', user_username, user_first_name, user_last_name, challenge_title),
    NULL,
    NOW(),
    '{}'::TEXT[]
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_task_completion() OWNER TO postgres;

--
-- Name: notify_task_edit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_task_edit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  challenge_title TEXT;
BEGIN
  -- Fetch challenge title
  SELECT title INTO challenge_title
  FROM challenges
  WHERE id = NEW.challenge_id;

  -- Insert automated post
  INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
  VALUES (
    NEW.challenge_id,
    format('A task in #%s has been updated!', challenge_title),
    '00000000-0000-0000-0000-000000000000',
    NOW(),
    '{}'::TEXT[]
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_task_edit() OWNER TO postgres;

--
-- Name: notify_task_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_task_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  challenge_title TEXT;
BEGIN
  -- Fetch challenge title
  SELECT title INTO challenge_title
  FROM challenges
  WHERE id = NEW.challenge_id;

  -- Insert automated post
  INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
  VALUES (
    NEW.challenge_id,
    format('A new task has been added to #%s!', challenge_title),
    '00000000-0000-0000-0000-000000000000',
    NOW(),
    '{}'::TEXT[]
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_task_update() OWNER TO postgres;

--
-- Name: notify_user_joined(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_user_joined() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  challenge_title TEXT;
  user_first_name TEXT;
  user_last_name TEXT;
BEGIN
  SELECT title INTO challenge_title
  FROM challenges
  WHERE id = NEW.challenge_id;

  SELECT first_name, last_name INTO user_first_name, user_last_name
  FROM profiles
  WHERE id = NEW.user_id;

  INSERT INTO posts (challenge_id, content, user_id, created_at, media_urls)
  VALUES (
    NEW.challenge_id,
    format('%s %s joined #%s!', user_first_name, user_last_name, challenge_title),
    '00000000-0000-0000-0000-000000000000',
    NOW(),
    '{}'::TEXT[]
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_user_joined() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: supabase_admin
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: blocks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blocks (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    blocker_id uuid,
    blocked_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.blocks OWNER TO postgres;

--
-- Name: bookmarks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookmarks (
    user_id uuid NOT NULL,
    content_type text NOT NULL,
    content_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bookmarks OWNER TO postgres;

--
-- Name: challenge_lobbies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_lobbies (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    challenge_id uuid,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.challenge_lobbies OWNER TO postgres;

--
-- Name: challenge_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_participants (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    challenge_id uuid,
    user_id uuid,
    joined_at timestamp without time zone DEFAULT now(),
    "position" integer DEFAULT 0,
    score numeric DEFAULT 0
);


ALTER TABLE public.challenge_participants OWNER TO postgres;

--
-- Name: challenge_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    usage_count integer DEFAULT 0
);


ALTER TABLE public.challenge_types OWNER TO postgres;

--
-- Name: challenge_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.challenge_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.challenge_types_id_seq OWNER TO postgres;

--
-- Name: challenge_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.challenge_types_id_seq OWNED BY public.challenge_types.id;


--
-- Name: challenges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenges (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    participants_current integer DEFAULT 0,
    participants_max integer,
    cost numeric DEFAULT 0.00,
    prize_pool numeric DEFAULT 0.00,
    scoring_type text NOT NULL,
    is_public boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    challenge_name text,
    challenge_type text,
    max_participants integer,
    buy_in_cost numeric,
    additional_prize_money numeric,
    prize_type text,
    prize_amount numeric,
    number_of_winners integer,
    is_private boolean DEFAULT false,
    invitation_link text,
    cover_media text,
    start_datetime timestamp with time zone,
    end_datetime timestamp with time zone,
    creator_id uuid,
    creator_participating boolean DEFAULT false
);


ALTER TABLE public.challenges OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    post_id uuid,
    user_id uuid,
    content text,
    created_at timestamp without time zone DEFAULT now(),
    parent_id uuid
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: follows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follows (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    follower_id uuid,
    following_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.follows OWNER TO postgres;

--
-- Name: friends; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friends (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    friend_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.friends OWNER TO postgres;

--
-- Name: friendships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friendships (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    friend_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.friendships OWNER TO postgres;

--
-- Name: group_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_members (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    group_id uuid,
    user_id uuid
);


ALTER TABLE public.group_members OWNER TO postgres;

--
-- Name: message_threads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_threads (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_message_preview text
);


ALTER TABLE public.message_threads OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    thread_id uuid NOT NULL,
    user_id uuid NOT NULL,
    content text,
    media_url text[],
    created_at timestamp with time zone DEFAULT now(),
    edited_at timestamp with time zone,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: news_feed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.news_feed (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    message text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.news_feed OWNER TO postgres;

--
-- Name: post_reactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_reactions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    post_id uuid,
    user_id uuid,
    reaction_type text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.post_reactions OWNER TO postgres;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    content text,
    color_code text,
    created_at timestamp without time zone DEFAULT now(),
    challenge_id uuid,
    media_url text[] DEFAULT ARRAY[]::text[],
    parent_id uuid,
    media_urls text[] DEFAULT '{}'::text[]
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: private_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.private_groups (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.private_groups OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    first_name text,
    last_name text,
    username text,
    profile_photo_url text,
    phone_number text,
    phone_number_raw text,
    address text,
    participates_in_challenges boolean DEFAULT false,
    gender text,
    dob date,
    height integer DEFAULT 0,
    weight integer DEFAULT 0,
    body_fat_percentage integer DEFAULT 0,
    bmi double precision,
    bmr double precision,
    first_name_public boolean DEFAULT false,
    last_name_public boolean DEFAULT false,
    username_public boolean DEFAULT true,
    phone_number_public boolean DEFAULT false,
    address_public boolean DEFAULT false,
    participates_in_challenges_public boolean DEFAULT false,
    gender_public boolean DEFAULT false,
    dob_public boolean DEFAULT false,
    height_public boolean DEFAULT false,
    weight_public boolean DEFAULT false,
    body_fat_percentage_public boolean DEFAULT false,
    profile_photo_url_public boolean DEFAULT true,
    bmi_public boolean DEFAULT false,
    bmr_public boolean DEFAULT false
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: social_channels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.social_channels (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    is_public boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.social_channels OWNER TO postgres;

--
-- Name: stories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stories (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    media_url text NOT NULL,
    text_overlay text,
    interactive_element jsonb,
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone NOT NULL,
    views integer DEFAULT 0,
    text_position text DEFAULT 'center'::text,
    font_color text DEFAULT '#ffffff'::text,
    font_size text DEFAULT 'medium'::text,
    CONSTRAINT check_font_size CHECK ((font_size = ANY (ARRAY['small'::text, 'medium'::text, 'large'::text]))),
    CONSTRAINT check_text_position CHECK ((text_position = ANY (ARRAY['top'::text, 'center'::text, 'bottom'::text])))
);


ALTER TABLE public.stories OWNER TO postgres;

--
-- Name: story_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.story_views (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    story_id uuid NOT NULL,
    viewed_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.story_views OWNER TO postgres;

--
-- Name: task_completions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_completions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    task_id uuid,
    user_id uuid,
    challenge_id uuid,
    submitted_data jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'pending'::character varying
);


ALTER TABLE public.task_completions OWNER TO postgres;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    challenge_id uuid,
    action text NOT NULL,
    frequency text NOT NULL,
    verification_type text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    require_attachment boolean DEFAULT false,
    completed boolean DEFAULT false,
    user_id uuid,
    requires_attachment boolean DEFAULT false,
    media_url text,
    require_video_completion boolean DEFAULT false
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: thread_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thread_participants (
    thread_id uuid NOT NULL,
    user_id uuid NOT NULL,
    joined_at timestamp with time zone DEFAULT now(),
    last_read_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.thread_participants OWNER TO postgres;

--
-- Name: user_challenge_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_challenge_logs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    challenge_id uuid,
    metric_value integer,
    logged_at timestamp without time zone DEFAULT now(),
    proof_url text
);


ALTER TABLE public.user_challenge_logs OWNER TO postgres;

--
-- Name: user_challenges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_challenges (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    challenge_id uuid,
    joined_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_challenges OWNER TO postgres;

--
-- Name: user_relationships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_relationships (
    follower_id uuid NOT NULL,
    following_id uuid NOT NULL,
    relationship_type text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_relationships OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    email text NOT NULL,
    username text,
    bio text,
    avatar_url text,
    favorite_color text,
    first_name text DEFAULT ''::text NOT NULL,
    last_name text DEFAULT ''::text NOT NULL,
    phone_number text DEFAULT ''::text NOT NULL,
    address text DEFAULT ''::text NOT NULL,
    participates_in_challenges boolean DEFAULT false NOT NULL,
    gender text,
    height_inches integer,
    weight_lbs integer,
    body_fat_percentage integer,
    dob date,
    CONSTRAINT gender_check CHECK ((gender = ANY (ARRAY['male'::text, 'female'::text]))),
    CONSTRAINT users_body_fat_percentage_check CHECK (((body_fat_percentage >= 3) AND (body_fat_percentage <= 60)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: whispers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.whispers (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    sender_id uuid,
    recipient_id uuid,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    read boolean DEFAULT false
);


ALTER TABLE public.whispers OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2025_04_13; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_13 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_13 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_14; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_14 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_14 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_15; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_15 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_15 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_16; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_16 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_17; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_17 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_17 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_18; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_18 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_18 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_19; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_19 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_19 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_20; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_20 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_20 OWNER TO supabase_admin;

--
-- Name: messages_2025_04_21; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_04_21 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_04_21 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: messages_2025_04_13; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_13 FOR VALUES FROM ('2025-04-13 00:00:00') TO ('2025-04-14 00:00:00');


--
-- Name: messages_2025_04_14; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_14 FOR VALUES FROM ('2025-04-14 00:00:00') TO ('2025-04-15 00:00:00');


--
-- Name: messages_2025_04_15; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_15 FOR VALUES FROM ('2025-04-15 00:00:00') TO ('2025-04-16 00:00:00');


--
-- Name: messages_2025_04_16; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_16 FOR VALUES FROM ('2025-04-16 00:00:00') TO ('2025-04-17 00:00:00');


--
-- Name: messages_2025_04_17; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_17 FOR VALUES FROM ('2025-04-17 00:00:00') TO ('2025-04-18 00:00:00');


--
-- Name: messages_2025_04_18; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_18 FOR VALUES FROM ('2025-04-18 00:00:00') TO ('2025-04-19 00:00:00');


--
-- Name: messages_2025_04_19; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_19 FOR VALUES FROM ('2025-04-19 00:00:00') TO ('2025-04-20 00:00:00');


--
-- Name: messages_2025_04_20; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_20 FOR VALUES FROM ('2025-04-20 00:00:00') TO ('2025-04-21 00:00:00');


--
-- Name: messages_2025_04_21; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_04_21 FOR VALUES FROM ('2025-04-21 00:00:00') TO ('2025-04-22 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: challenge_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_types ALTER COLUMN id SET DEFAULT nextval('public.challenge_types_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	66881872-3418-4596-b875-d372be74fdf5	{"action":"user_signedup","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 03:50:15.054383+00	
00000000-0000-0000-0000-000000000000	33369836-ae1d-4fd7-9617-55e988266bed	{"action":"login","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 03:50:15.064813+00	
00000000-0000-0000-0000-000000000000	b88a7ca0-9017-4823-9c1d-770067f45b12	{"action":"logout","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 03:55:56.203657+00	
00000000-0000-0000-0000-000000000000	70e97b48-f8fd-4024-8043-fba306fe1bfc	{"action":"login","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 03:56:26.90368+00	
00000000-0000-0000-0000-000000000000	7f2a9d06-f576-4719-9252-f8ae8de1cf71	{"action":"logout","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 04:07:31.558893+00	
00000000-0000-0000-0000-000000000000	2295554d-8536-4055-9749-138df17ccb15	{"action":"login","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:08:00.116916+00	
00000000-0000-0000-0000-000000000000	2903b09b-f179-44bd-b15a-f63a2d20d592	{"action":"logout","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 04:08:31.779276+00	
00000000-0000-0000-0000-000000000000	c9730ddc-e995-42ff-9a1a-47e2c612b819	{"action":"user_signedup","actor_id":"3a6b889d-3160-4887-b133-c39a7cef4859","actor_username":"test@test.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 04:15:57.267738+00	
00000000-0000-0000-0000-000000000000	8529886b-69bd-4ce5-80e3-4b0318c2a315	{"action":"login","actor_id":"3a6b889d-3160-4887-b133-c39a7cef4859","actor_username":"test@test.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:15:57.272005+00	
00000000-0000-0000-0000-000000000000	d6fcd534-5b04-4e2c-b115-20dcde312177	{"action":"logout","actor_id":"3a6b889d-3160-4887-b133-c39a7cef4859","actor_username":"test@test.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 04:16:11.23032+00	
00000000-0000-0000-0000-000000000000	8f7d5dfa-6d20-4cd6-a29d-109f719e3a8f	{"action":"user_signedup","actor_id":"9f73c994-395c-49b9-96a0-fd6f7471bd39","actor_username":"none1@none1.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 04:21:13.454134+00	
00000000-0000-0000-0000-000000000000	57065cbd-0c3a-4f9c-9812-711d76004f63	{"action":"login","actor_id":"9f73c994-395c-49b9-96a0-fd6f7471bd39","actor_username":"none1@none1.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:21:13.458634+00	
00000000-0000-0000-0000-000000000000	4b0a27a1-db4e-476c-89bc-aed5f777de57	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"test@test.com","user_id":"3a6b889d-3160-4887-b133-c39a7cef4859","user_phone":""}}	2025-02-26 04:27:36.376778+00	
00000000-0000-0000-0000-000000000000	742ed0b2-32dc-4419-8fb9-56a768ff3b7c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"none@none.com","user_id":"0389831a-959d-46bf-bc63-8910060ce10c","user_phone":""}}	2025-02-26 04:27:36.388654+00	
00000000-0000-0000-0000-000000000000	ad223517-76a6-43a9-939e-99cbfaa07914	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"none1@none1.com","user_id":"9f73c994-395c-49b9-96a0-fd6f7471bd39","user_phone":""}}	2025-02-26 04:27:36.389414+00	
00000000-0000-0000-0000-000000000000	8d36dfda-c894-420c-9984-c02939bff6fa	{"action":"user_signedup","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 04:28:22.625551+00	
00000000-0000-0000-0000-000000000000	cf0c5a76-b073-42b8-a269-4db91804d73d	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:28:22.628758+00	
00000000-0000-0000-0000-000000000000	8f6de197-d4ba-4de2-84d7-6300c75856c4	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 20:03:44.341769+00	
00000000-0000-0000-0000-000000000000	8f0b7483-143c-4ce4-850c-62df7c49aa45	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 20:03:44.351162+00	
00000000-0000-0000-0000-000000000000	ca99103f-26c3-4a88-8ba6-7950cf22312a	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 20:33:15.485994+00	
00000000-0000-0000-0000-000000000000	b9c04c95-6d1c-4b91-bdc9-c31c3894e949	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 20:51:16.138477+00	
00000000-0000-0000-0000-000000000000	4399dc33-cf89-4bc7-93d7-22f624acb6ea	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 20:57:59.829465+00	
00000000-0000-0000-0000-000000000000	6750286b-8e8c-4067-b992-f424e83c4f0d	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 20:59:26.167054+00	
00000000-0000-0000-0000-000000000000	d140c967-181c-4cfe-ad7f-13507c5ee384	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 21:57:56.245716+00	
00000000-0000-0000-0000-000000000000	ce182510-9f71-4714-b87d-483a1c738175	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 21:57:56.248+00	
00000000-0000-0000-0000-000000000000	5a0c6812-140b-40ce-a4fc-592668f2687f	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 22:56:24.077481+00	
00000000-0000-0000-0000-000000000000	70feb18d-e47b-47ea-9863-689d09af366b	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 22:56:24.07842+00	
00000000-0000-0000-0000-000000000000	9341a581-6ad5-459e-8e1c-d43866e00d20	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 23:54:36.868777+00	
00000000-0000-0000-0000-000000000000	6945752b-7fc2-4d24-9bab-a6807053f77f	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 23:54:36.871329+00	
00000000-0000-0000-0000-000000000000	015808e7-8a1a-4744-8329-b01d18b15dcb	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 00:52:42.169541+00	
00000000-0000-0000-0000-000000000000	d4237323-d9bf-4b01-83e6-2e0350d4e4e9	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 00:52:42.171553+00	
00000000-0000-0000-0000-000000000000	acb9110a-90b6-4db6-982e-1bee71ac1b84	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 01:50:48.295378+00	
00000000-0000-0000-0000-000000000000	07c8a50a-533b-4cb0-8ba1-4abff123c766	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 01:50:48.296259+00	
00000000-0000-0000-0000-000000000000	418334f0-4265-4f1c-80ce-5c881fac2890	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 02:49:01.208148+00	
00000000-0000-0000-0000-000000000000	e665ae6f-d48b-4412-bd1d-62d98c5ba4db	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 02:49:01.208944+00	
00000000-0000-0000-0000-000000000000	20f0cd25-22a0-47b8-abde-e9690d4875aa	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 03:48:49.205383+00	
00000000-0000-0000-0000-000000000000	269a78bf-1cc8-4d9e-8516-2b43782642ec	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 03:48:49.206824+00	
00000000-0000-0000-0000-000000000000	7fce4d96-f257-499e-b2f2-18f1ab4021b8	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-27 04:22:49.537404+00	
00000000-0000-0000-0000-000000000000	75fcc4b6-4319-4af3-b4ef-ea5ed7e7dd17	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 04:51:57.412848+00	
00000000-0000-0000-0000-000000000000	402b8ef6-1124-46c3-b149-9199a918fd1c	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 13:20:42.124878+00	
00000000-0000-0000-0000-000000000000	440204d1-551f-4b82-a8a6-48ec0bd487e4	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-27 13:21:50.123627+00	
00000000-0000-0000-0000-000000000000	d6dadf72-2b18-4275-b436-a1e505a6c3f9	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 17:27:35.974524+00	
00000000-0000-0000-0000-000000000000	08d0906b-e19b-492e-b2f6-b700d2a2d1ee	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-27 17:28:09.009653+00	
00000000-0000-0000-0000-000000000000	f3d55199-db10-4710-9383-ec5a32528768	{"action":"user_signedup","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-27 17:48:46.116249+00	
00000000-0000-0000-0000-000000000000	fa0866a0-89dc-4955-b244-8fae724a573a	{"action":"login","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 17:48:46.122059+00	
00000000-0000-0000-0000-000000000000	bc661d2f-102c-4966-b2c7-eec464ce80df	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 18:57:40.175453+00	
00000000-0000-0000-0000-000000000000	487f128a-a50d-4cc0-a3e6-8bc862793972	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 19:55:44.696865+00	
00000000-0000-0000-0000-000000000000	858fffe0-7792-4960-ad43-685d08a2cef3	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 19:55:44.699817+00	
00000000-0000-0000-0000-000000000000	2ee1aeb6-f079-4d58-8d07-afb9c3049f99	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 20:53:47.952778+00	
00000000-0000-0000-0000-000000000000	bfd49678-9dac-4a40-82de-bb26c997de70	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 20:53:47.955421+00	
00000000-0000-0000-0000-000000000000	7140638a-0078-47b7-b268-935452864176	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 21:51:52.017274+00	
00000000-0000-0000-0000-000000000000	278f46e1-a47b-4e33-ab24-bbeb8d594301	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 21:51:52.019873+00	
00000000-0000-0000-0000-000000000000	e3b19a16-c2bf-45bc-b9aa-3ec58407c897	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 22:50:33.273268+00	
00000000-0000-0000-0000-000000000000	b7e55ae9-8140-4bfa-8a9c-da4eea9b7ac9	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 22:50:33.274707+00	
00000000-0000-0000-0000-000000000000	97347e31-ac2d-4466-9614-2624697c2b32	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 23:48:51.709942+00	
00000000-0000-0000-0000-000000000000	a9c03b51-0368-45d1-9d03-e47037a4fc8d	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 23:48:51.711322+00	
00000000-0000-0000-0000-000000000000	50a1954f-b23c-4012-b4cd-6a49fcf30d68	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 00:46:58.493295+00	
00000000-0000-0000-0000-000000000000	e73005ca-9301-4fbc-904c-05c5572f875b	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 00:46:58.494777+00	
00000000-0000-0000-0000-000000000000	d0c63595-4864-49e5-9187-552ff380eb88	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:45:23.733034+00	
00000000-0000-0000-0000-000000000000	3b3dbbe1-e6fc-4804-80a8-799db0e59616	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:45:23.733922+00	
00000000-0000-0000-0000-000000000000	08765907-8967-43ff-8301-a2c1eb1b51f8	{"action":"token_refreshed","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:46:32.239292+00	
00000000-0000-0000-0000-000000000000	8ccb9944-3533-458f-9f68-d2a2277d14dc	{"action":"token_revoked","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:46:32.24013+00	
00000000-0000-0000-0000-000000000000	8836eb3a-87e9-435c-82b9-5d1153bb600b	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 02:43:51.671864+00	
00000000-0000-0000-0000-000000000000	8123a7ec-9140-48d3-87a9-e0ae1a59597a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 02:43:51.673872+00	
00000000-0000-0000-0000-000000000000	b6fa0945-e4ef-41b7-9bbd-80db95461eaa	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 03:42:00.206399+00	
00000000-0000-0000-0000-000000000000	6f9b6eec-2a4c-4aa9-8482-e46ccb017769	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 03:42:00.209068+00	
00000000-0000-0000-0000-000000000000	8007a1e2-6522-4450-b00e-853503440e47	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 04:40:19.829086+00	
00000000-0000-0000-0000-000000000000	6e01375f-8e76-4a64-a1a0-f1656ca7b46a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 04:40:19.831711+00	
00000000-0000-0000-0000-000000000000	0dd3fb5b-b93b-4b76-ab78-ec84d0194011	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 05:41:27.162786+00	
00000000-0000-0000-0000-000000000000	caa4dfee-9533-47a5-b457-c256daced912	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 05:41:27.16376+00	
00000000-0000-0000-0000-000000000000	34dcde8f-5b07-4599-ad87-6aec547f0b0d	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 07:05:58.104282+00	
00000000-0000-0000-0000-000000000000	0e848047-0c68-4646-9dfd-ece729e0c7f2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 07:05:58.12173+00	
00000000-0000-0000-0000-000000000000	ab166d24-11c0-4dc9-8496-a519bbec5948	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 10:01:37.689715+00	
00000000-0000-0000-0000-000000000000	18871dfe-6ee0-4d5e-8ef5-9323f857e6a6	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 10:01:37.691803+00	
00000000-0000-0000-0000-000000000000	c4c96b0f-08ec-4d5d-ba40-8bf1f0a8d7d8	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 11:57:50.203103+00	
00000000-0000-0000-0000-000000000000	69430e2b-c408-4063-a7ca-d22b8d164987	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 11:57:50.204062+00	
00000000-0000-0000-0000-000000000000	70c34021-28fe-4f4c-87e6-c58d84381f66	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 13:03:35.507456+00	
00000000-0000-0000-0000-000000000000	fc73b9ae-2561-4f4a-bfc1-2cb9735ff371	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 13:03:35.508344+00	
00000000-0000-0000-0000-000000000000	00b3423d-27ca-4271-a64c-d906afb29110	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 14:52:47.667896+00	
00000000-0000-0000-0000-000000000000	40295f01-ad5e-4ec4-9f0c-47c58dcd1be2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 14:52:47.676332+00	
00000000-0000-0000-0000-000000000000	fdc8261f-7d4c-47f7-b682-545fcc535d63	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:01:07.088804+00	
00000000-0000-0000-0000-000000000000	26de1ed8-2e1f-4635-a1d5-79c8845fb9fe	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:01:07.090281+00	
00000000-0000-0000-0000-000000000000	c54bee62-3bcb-4797-8108-bda1a454f0be	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:59:13.434958+00	
00000000-0000-0000-0000-000000000000	a7a322a1-0a6c-4599-a774-201d7c0c0d39	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:59:13.436526+00	
00000000-0000-0000-0000-000000000000	3fec69ca-85ca-43e0-9430-8f18cf0d4fc4	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 17:13:34.49523+00	
00000000-0000-0000-0000-000000000000	7141a4f1-e8c4-49b2-93a0-a1a584c9eaa1	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 17:13:34.507754+00	
00000000-0000-0000-0000-000000000000	4f15da09-5dc4-46db-a0a7-7f123b4f615b	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-03 17:48:21.207273+00	
00000000-0000-0000-0000-000000000000	9a82e0a1-a79f-438a-ba32-7b3c0ad9d970	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 17:48:22.638964+00	
00000000-0000-0000-0000-000000000000	2fb69fd1-5190-4d90-9645-a8a1427eef79	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 18:46:46.185754+00	
00000000-0000-0000-0000-000000000000	0dc58c68-4117-46cc-83f5-0c6e4255ca69	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 18:46:46.187828+00	
00000000-0000-0000-0000-000000000000	8b2499bc-ae34-418b-85dd-2f575735fc56	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 19:14:04.798068+00	
00000000-0000-0000-0000-000000000000	ba5dea8d-cc96-4307-abef-3946752de766	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 19:45:08.126234+00	
00000000-0000-0000-0000-000000000000	66d1bf5d-ee73-4ef7-8c70-abc5bafda9bd	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 19:45:08.128341+00	
00000000-0000-0000-0000-000000000000	7fb137d6-d386-4aef-a467-3ca088ce1860	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:12:18.082392+00	
00000000-0000-0000-0000-000000000000	bf5bd79f-c314-4c58-bfbe-b5c249bca136	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:12:18.084626+00	
00000000-0000-0000-0000-000000000000	38dedb99-1e91-406d-a733-7156b1a3bbcc	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:43:40.823863+00	
00000000-0000-0000-0000-000000000000	a5d57cba-6d7c-4425-bb3d-ed9f1aa66980	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:43:40.826807+00	
00000000-0000-0000-0000-000000000000	b4de527f-430e-4ed4-a4a4-5abca2de9c13	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:10:56.431339+00	
00000000-0000-0000-0000-000000000000	7fd316b5-d84b-4a06-b76a-3839a5260f4a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:10:56.433495+00	
00000000-0000-0000-0000-000000000000	17c69881-7a3e-4ece-9bb3-34177c2aeb7d	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:41:54.986075+00	
00000000-0000-0000-0000-000000000000	044b2393-8255-4525-a1b9-5bd42bf1d063	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:41:54.988917+00	
00000000-0000-0000-0000-000000000000	072dd65c-7b7b-4cdf-bc19-71ad077b7bca	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:09:15.890197+00	
00000000-0000-0000-0000-000000000000	cc8958c3-2766-4ed0-a324-f9ab0a50dc9a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:09:15.89348+00	
00000000-0000-0000-0000-000000000000	9374f892-c30d-4516-b553-28d9b31848bd	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:40:02.496562+00	
00000000-0000-0000-0000-000000000000	9573e9b6-9310-4396-9059-a2360c0cb493	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:40:02.499202+00	
00000000-0000-0000-0000-000000000000	8b22a67c-5b8e-4f1d-a5dd-25f2f9b95694	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-03 23:02:54.266271+00	
00000000-0000-0000-0000-000000000000	ded3a3b2-0c22-4c84-bfa2-fdd872d2bff9	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 23:02:55.943543+00	
00000000-0000-0000-0000-000000000000	bc58acbb-db3d-4d0b-bb79-658d72937ad6	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 23:04:34.125315+00	
00000000-0000-0000-0000-000000000000	1d581882-9f69-40f2-aac6-1d3ddcf1722a	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:01:04.349298+00	
00000000-0000-0000-0000-000000000000	9f9e5373-2769-4c67-8680-79dee1915d40	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:01:04.351391+00	
00000000-0000-0000-0000-000000000000	b6547450-c83e-4620-b42b-2a7b3526702c	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:02:34.293493+00	
00000000-0000-0000-0000-000000000000	c171435f-edb3-49d9-a7cf-459a900151a7	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:02:34.294358+00	
00000000-0000-0000-0000-000000000000	b267bb43-b484-4c8f-8bd2-ef54028765f2	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:59:24.843274+00	
00000000-0000-0000-0000-000000000000	daf02d31-815a-4f19-a7e3-dcc3032715e2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:59:24.846356+00	
00000000-0000-0000-0000-000000000000	e91afc17-d2fc-482f-9249-f6b7da2665cc	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:00:42.329117+00	
00000000-0000-0000-0000-000000000000	84f74e62-f5d2-470a-8d2f-69ceca198337	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:00:42.330081+00	
00000000-0000-0000-0000-000000000000	2706aa18-63b7-4d84-b00b-03f466990954	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:58:20.020252+00	
00000000-0000-0000-0000-000000000000	06004f75-9381-4940-8a7f-19818844e333	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:58:20.023829+00	
00000000-0000-0000-0000-000000000000	357780f8-1269-4126-8858-7e2e6ae08158	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:59:45.87792+00	
00000000-0000-0000-0000-000000000000	0bd08b3d-6d80-49f2-badf-9e29bbb5dc8d	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:59:45.878762+00	
00000000-0000-0000-0000-000000000000	63014b4e-26fa-4fe5-8a98-989a2212d46e	{"action":"token_refreshed","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 02:40:25.583443+00	
00000000-0000-0000-0000-000000000000	c9ccd8a7-a447-476f-a471-646e69a39c9b	{"action":"token_revoked","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 02:40:25.586156+00	
00000000-0000-0000-0000-000000000000	24ee0113-cf6e-4f13-a1f1-60faa1415a0a	{"action":"logout","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 02:42:52.599058+00	
00000000-0000-0000-0000-000000000000	4c6ca3ea-e76b-47bf-b139-83bd8455c981	{"action":"user_recovery_requested","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"user"}	2025-03-04 02:43:16.358924+00	
00000000-0000-0000-0000-000000000000	e1b754be-60a0-4b5e-bb35-a6c4a8e1b3ab	{"action":"login","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 02:43:35.835073+00	
00000000-0000-0000-0000-000000000000	a2d3bebe-2a2d-4d6e-a98a-db1c23c551c2	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 03:33:34.820104+00	
00000000-0000-0000-0000-000000000000	681dd504-d25c-4bdc-8e2e-57f37ad9454b	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 03:33:34.821002+00	
00000000-0000-0000-0000-000000000000	5edf6159-564d-4edb-b2f3-79bf228a369c	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 04:30:08.723869+00	
00000000-0000-0000-0000-000000000000	26b1b838-77e2-4f3a-9938-c842eefbb8a1	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-04 04:30:28.584694+00	
00000000-0000-0000-0000-000000000000	0ccd45af-4247-4edd-bcce-991e737e83d0	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 04:41:53.114894+00	
00000000-0000-0000-0000-000000000000	bd5cadb0-3e3d-4d31-8e87-930ed7c9abf0	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-04 04:41:54.396276+00	
00000000-0000-0000-0000-000000000000	5a233e48-18d0-45e0-ab43-8b7669055430	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 05:39:58.587683+00	
00000000-0000-0000-0000-000000000000	d10599e7-0406-4953-ba54-980b15e66f48	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 05:39:58.593773+00	
00000000-0000-0000-0000-000000000000	2ee1ffb9-74d5-4739-9d14-1e9e56151df0	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 06:38:13.252626+00	
00000000-0000-0000-0000-000000000000	d848ecb5-6d69-4773-8d31-d4521aca834f	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 06:38:13.269882+00	
00000000-0000-0000-0000-000000000000	834631f4-2d5b-462e-b1d3-313534b90f3e	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 07:50:35.508124+00	
00000000-0000-0000-0000-000000000000	f4b36064-8f7e-4cf9-aa37-cdf6552ead5e	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 07:50:35.508945+00	
00000000-0000-0000-0000-000000000000	8fe5b88b-1b71-4759-8bd1-82d8db959919	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 09:36:22.82058+00	
00000000-0000-0000-0000-000000000000	3d66edfb-1c80-4e16-bb2a-83c1cadfafbb	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 09:36:22.822666+00	
00000000-0000-0000-0000-000000000000	1f71f77a-9026-47b7-9c27-13135016b3ab	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 11:14:15.438599+00	
00000000-0000-0000-0000-000000000000	2572d105-66c7-4c5c-a0d0-3602808b7922	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 11:14:15.445041+00	
00000000-0000-0000-0000-000000000000	bbd40a22-be9f-475a-b34f-174d65fba671	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 12:37:26.879537+00	
00000000-0000-0000-0000-000000000000	a32225b5-86ed-4114-a292-b8307973b9b2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 12:37:26.881185+00	
00000000-0000-0000-0000-000000000000	e04cc2bd-faa5-49f8-8a58-308a767aec57	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 13:43:56.496217+00	
00000000-0000-0000-0000-000000000000	37e2c8cc-e364-4ca9-b591-6c2a1660c0be	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 13:43:56.498208+00	
00000000-0000-0000-0000-000000000000	98d362f8-9e77-4174-9b3c-376fcdd737c9	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 14:43:06.579955+00	
00000000-0000-0000-0000-000000000000	2209860b-f995-4c33-bc47-34f1c4fc4c5d	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 14:43:06.582684+00	
00000000-0000-0000-0000-000000000000	698d25cc-a5f0-490a-b28a-6e5c50c667ce	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:42:06.630959+00	
00000000-0000-0000-0000-000000000000	ff6f5843-b973-4f42-aa07-a0cc03952dbc	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:42:06.633303+00	
00000000-0000-0000-0000-000000000000	41c8c935-06d5-4422-8e7b-339b3c50237d	{"action":"token_refreshed","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:55:21.273477+00	
00000000-0000-0000-0000-000000000000	47b8b304-f53e-4870-a54e-147ee3b2c9eb	{"action":"token_revoked","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:55:21.27502+00	
00000000-0000-0000-0000-000000000000	f3e058c1-fda8-4b6d-b061-c681bc26f7b4	{"action":"logout","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 16:00:31.469124+00	
00000000-0000-0000-0000-000000000000	363883ae-65b0-43db-8bb3-16069eaa2031	{"action":"login","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-04 16:01:05.250434+00	
00000000-0000-0000-0000-000000000000	9e6a2b87-e020-4ac2-a578-aca9e3dcc65a	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 16:40:47.745788+00	
00000000-0000-0000-0000-000000000000	ed72f7bd-ab65-4359-a5ae-7e26cdfcecc9	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 16:40:47.749052+00	
00000000-0000-0000-0000-000000000000	b2b5bc3f-cd5d-4594-bac3-59d379869a2a	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 17:39:23.651855+00	
00000000-0000-0000-0000-000000000000	6b32fd2b-0694-4ea7-9f21-3f9fbe65f612	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 17:39:23.654428+00	
00000000-0000-0000-0000-000000000000	e62fdbca-d1d9-4791-9a57-55dbf39d8b9f	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 23:01:52.280091+00	
00000000-0000-0000-0000-000000000000	45f3dadb-f242-47d3-ae31-bd58eb169a2f	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 23:01:52.288304+00	
00000000-0000-0000-0000-000000000000	63a85ac8-6718-4a3c-82ec-99dc2adf882c	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:00:27.241918+00	
00000000-0000-0000-0000-000000000000	30188980-c9e1-4167-aeca-706fca6b03ca	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:00:27.244891+00	
00000000-0000-0000-0000-000000000000	79021f78-d60a-48a7-80ab-8b6cc6982f61	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:59:27.152267+00	
00000000-0000-0000-0000-000000000000	f50799b0-bbb1-4147-a453-463ab7f43718	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:59:27.154849+00	
00000000-0000-0000-0000-000000000000	613a7f3d-9e1c-4ad9-9491-7f603b880c94	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-04-10 20:07:51.642632+00	
00000000-0000-0000-0000-000000000000	fc6acd32-5f52-4f9a-b05f-c3ce7e41e952	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-04-10 20:07:51.644561+00	
00000000-0000-0000-0000-000000000000	ac7621ca-d0e2-4f27-901d-c328c7a93643	{"action":"user_signedup","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-04-11 01:32:57.38559+00	
00000000-0000-0000-0000-000000000000	e164d62a-c73c-4a63-a1eb-e047dd0a8127	{"action":"login","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-11 01:32:57.391059+00	
00000000-0000-0000-0000-000000000000	02d48c6b-4807-409f-acc0-9ea7f878b14f	{"action":"user_repeated_signup","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-04-11 01:36:24.38836+00	
00000000-0000-0000-0000-000000000000	203d5627-ebfe-4698-92b9-4d36cbc08937	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 02:31:20.897398+00	
00000000-0000-0000-0000-000000000000	0fa32f55-547f-44b8-92d8-e9a9476acdef	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 02:31:20.898342+00	
00000000-0000-0000-0000-000000000000	ae18a4d3-9289-4b67-95fa-a9c86be579d6	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 16:31:03.402425+00	
00000000-0000-0000-0000-000000000000	455b879f-a1df-4981-9e96-693d4fdfcc1b	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 16:31:03.406933+00	
00000000-0000-0000-0000-000000000000	9323cbb1-0899-44e7-8d56-fbead48d859e	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 17:30:30.247038+00	
00000000-0000-0000-0000-000000000000	ea0348d1-0597-4038-a6df-05675675b3f5	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 17:30:30.252712+00	
00000000-0000-0000-0000-000000000000	67dd600c-8aa1-4397-b6fd-28eca4bca868	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 18:29:36.247623+00	
00000000-0000-0000-0000-000000000000	0b9cef6c-7d5d-42d2-ac12-b0faaff3cb87	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 18:29:36.248573+00	
00000000-0000-0000-0000-000000000000	c1e39578-e548-4156-ad12-7511ee678599	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 19:30:08.530545+00	
00000000-0000-0000-0000-000000000000	8fdc204c-47a0-4ceb-befd-6c9c01acf182	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 19:30:08.531513+00	
00000000-0000-0000-0000-000000000000	91e8679a-a7aa-4971-a96b-eaedf366f449	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 03:03:20.909812+00	
00000000-0000-0000-0000-000000000000	ef1379fd-bb08-49d5-b1d0-eec29516ecee	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 03:03:20.913703+00	
00000000-0000-0000-0000-000000000000	49497bb7-a37f-48b6-a0ca-5f4deb1c8367	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 04:02:08.731711+00	
00000000-0000-0000-0000-000000000000	36d17d78-dd4c-407b-96c2-d15e774a01e3	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 04:02:08.733296+00	
00000000-0000-0000-0000-000000000000	b181d194-0128-4c1f-bfdb-136a267608c7	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 05:07:23.108041+00	
00000000-0000-0000-0000-000000000000	98129b45-fcdf-4174-9276-e22ddd326338	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 05:07:23.109015+00	
00000000-0000-0000-0000-000000000000	6126e396-70ad-4aaf-9534-d28934d560f3	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 07:42:54.034665+00	
00000000-0000-0000-0000-000000000000	6fc27dd2-2b56-4236-8d26-0d439c9d72c2	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 07:42:54.035716+00	
00000000-0000-0000-0000-000000000000	e3081602-64d0-4822-8cdb-28e5bea973f8	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 09:20:06.548639+00	
00000000-0000-0000-0000-000000000000	3daf9df6-7124-43c1-be7c-9fe7decaaa68	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 09:20:06.549536+00	
00000000-0000-0000-0000-000000000000	5526431c-5fb7-497a-afc7-314989c286f2	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 11:24:55.219801+00	
00000000-0000-0000-0000-000000000000	04d90a44-e55c-4243-81e2-41587ce6e4ed	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 11:24:55.22077+00	
00000000-0000-0000-0000-000000000000	459df3eb-3e51-4cd3-bf9f-e671d0c4eae8	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 13:04:27.295905+00	
00000000-0000-0000-0000-000000000000	cbd64c08-261c-4f4c-a871-cadffd41cb91	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 13:04:27.296899+00	
00000000-0000-0000-0000-000000000000	7e85c1b4-5abd-4f3d-b2b0-871425d2dc03	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 14:41:53.976508+00	
00000000-0000-0000-0000-000000000000	13d606fb-bf8e-4473-960f-f1f581d2e216	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 14:41:53.977475+00	
00000000-0000-0000-0000-000000000000	6bc7c3ec-3713-4088-a783-4f5293fba913	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 15:45:53.980563+00	
00000000-0000-0000-0000-000000000000	693aaac6-f5d6-4574-9080-9a8a8f7fe2c9	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 15:45:53.981545+00	
00000000-0000-0000-0000-000000000000	932ff643-dd01-4a09-a4b4-b1c5bbc553f5	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 16:56:33.347619+00	
00000000-0000-0000-0000-000000000000	21c579a4-8a06-4dc9-942a-cc0e6bd84ed6	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 16:56:33.348642+00	
00000000-0000-0000-0000-000000000000	290c2815-2258-4cf7-b167-d91fe87cd5f5	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 18:09:34.586832+00	
00000000-0000-0000-0000-000000000000	2cf77c2c-cdab-40a8-aa0a-496da02cc003	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 18:09:34.587912+00	
00000000-0000-0000-0000-000000000000	1fee2c3e-c3bf-4de6-a0fd-b29f122ceb15	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 19:10:19.827628+00	
00000000-0000-0000-0000-000000000000	5352d90b-6247-43ab-92f8-18e36b032e9b	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 19:10:19.828714+00	
00000000-0000-0000-0000-000000000000	8a297e77-69d2-45d8-ad84-3bc6074f0595	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 20:11:27.838955+00	
00000000-0000-0000-0000-000000000000	cf1e909f-93c0-4eb6-8785-74a263d0effc	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 20:11:27.839903+00	
00000000-0000-0000-0000-000000000000	0174b773-d29b-439d-946c-6c2cc0bb9da5	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 21:12:43.602991+00	
00000000-0000-0000-0000-000000000000	6851b09a-b45a-4864-a23f-4e2434884fc0	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 21:12:43.604033+00	
00000000-0000-0000-0000-000000000000	bab78438-f358-4024-bf82-99e83fcefd77	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 22:13:26.563801+00	
00000000-0000-0000-0000-000000000000	649c3b2b-d05c-4d72-9912-5f7e4b8baab8	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 22:13:26.564844+00	
00000000-0000-0000-0000-000000000000	c9ede235-0427-42dd-b954-259f1e856f3f	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 23:54:29.401575+00	
00000000-0000-0000-0000-000000000000	5dc72580-e6c6-492c-89a7-d253db199e53	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 23:54:29.402498+00	
00000000-0000-0000-0000-000000000000	57eeb372-f075-4e77-b615-ff922c9b2a3f	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 01:16:41.319581+00	
00000000-0000-0000-0000-000000000000	d39b0f7b-9194-4c35-8a6c-51b6244f1ad5	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 01:16:41.320523+00	
00000000-0000-0000-0000-000000000000	25c14268-986e-4ea5-919c-998e7d76dd8e	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 03:18:32.163091+00	
00000000-0000-0000-0000-000000000000	7ab92459-1abd-490c-9370-eaec226e701c	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 03:18:32.164107+00	
00000000-0000-0000-0000-000000000000	43e2b60c-810a-463f-9ea0-0fb3275b655f	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 05:56:58.071144+00	
00000000-0000-0000-0000-000000000000	02bc3cd5-6e36-4b01-869c-c6ae86d8c865	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 05:56:58.072164+00	
00000000-0000-0000-0000-000000000000	3b7974e4-457e-4219-9fb2-6c9cbc329065	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 10:04:11.007926+00	
00000000-0000-0000-0000-000000000000	70899236-133f-4ee9-991b-07f1a7bf71ef	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 10:04:11.008986+00	
00000000-0000-0000-0000-000000000000	12377fab-ec9b-49b2-a74e-503cd937a72b	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 12:03:56.098038+00	
00000000-0000-0000-0000-000000000000	ec7a1215-bdbd-47bf-a921-b66665e21c52	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 12:03:56.099095+00	
00000000-0000-0000-0000-000000000000	065915eb-1403-47aa-bb3c-5e26a75b790a	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 13:44:52.034741+00	
00000000-0000-0000-0000-000000000000	aeed7f0f-71cc-42b9-bda2-742c2f80ae22	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 13:44:52.035677+00	
00000000-0000-0000-0000-000000000000	1657d4f3-06d7-41e3-9ee0-f22bbca2ab75	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 15:10:08.555374+00	
00000000-0000-0000-0000-000000000000	7fbdbbed-9688-4b21-8fa4-e3e53789ad6c	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 15:10:08.556366+00	
00000000-0000-0000-0000-000000000000	e6307f4d-0d43-411d-acc1-7fc336c4134b	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 16:11:08.418997+00	
00000000-0000-0000-0000-000000000000	4f2ccac7-0f70-4d66-86df-86b7c30408a7	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 16:11:08.419957+00	
00000000-0000-0000-0000-000000000000	d2106cdb-16d7-4c0f-a1b3-d57229ea29f0	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 17:14:53.541224+00	
00000000-0000-0000-0000-000000000000	aca7b63a-40cf-4ed8-8412-52103d59a224	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 17:14:53.542199+00	
00000000-0000-0000-0000-000000000000	83a635b6-7829-41d4-913b-04b22ac11657	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 18:51:57.50481+00	
00000000-0000-0000-0000-000000000000	234dd989-cc0a-47a3-988f-6b0e72444c6e	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 18:51:57.505762+00	
00000000-0000-0000-0000-000000000000	e3731022-06ba-487a-af56-d19d31d2efb4	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 20:16:55.232228+00	
00000000-0000-0000-0000-000000000000	3afac461-3af2-4b61-a2ab-5cb105c29305	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 20:16:55.233269+00	
00000000-0000-0000-0000-000000000000	d138d7ea-a91b-4379-a171-67a2db46345b	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 21:18:13.851326+00	
00000000-0000-0000-0000-000000000000	b6484cc4-9fa4-4dd4-ba7d-39c069ea9e96	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 21:18:13.852342+00	
00000000-0000-0000-0000-000000000000	4cb79f2f-9ae9-46aa-a836-13e68b08981d	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 22:18:57.78221+00	
00000000-0000-0000-0000-000000000000	30a72980-c325-4bc8-8736-13b2eb5994af	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 22:18:57.783147+00	
00000000-0000-0000-0000-000000000000	39d37903-cbc5-4201-aa95-355fb7542efe	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 23:18:20.27593+00	
00000000-0000-0000-0000-000000000000	b626d366-3b65-4478-adf4-efd8ef300fc9	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-17 23:18:20.276916+00	
00000000-0000-0000-0000-000000000000	7436b87b-b440-4d14-af81-dd570901c1d2	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 00:17:29.350229+00	
00000000-0000-0000-0000-000000000000	8e3d60f5-c4c7-4018-999c-8495744e485b	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 00:17:29.351153+00	
00000000-0000-0000-0000-000000000000	b0c034d5-8ecc-48ab-b915-d95161422f75	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 01:16:29.352715+00	
00000000-0000-0000-0000-000000000000	54fb87e8-c64a-4e99-b9ac-1207a3f77212	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 01:16:29.353663+00	
00000000-0000-0000-0000-000000000000	9e73872c-28b2-4cb0-a387-abfcec565ca6	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 02:15:28.364655+00	
00000000-0000-0000-0000-000000000000	9319152d-763a-4cf6-b42b-5463f147d8be	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 02:15:28.365641+00	
00000000-0000-0000-0000-000000000000	21f621f1-ccf6-492e-8ab2-2cb88d916011	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 03:58:41.702239+00	
00000000-0000-0000-0000-000000000000	ea5b1fc1-8509-4fed-8898-b9dfded72bc3	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 03:58:41.703117+00	
00000000-0000-0000-0000-000000000000	f986a6de-373b-4d95-9a84-04889a2b5454	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 06:00:30.99122+00	
00000000-0000-0000-0000-000000000000	abace4ba-1697-4a9a-9acd-ee34db494c2b	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 06:00:30.992172+00	
00000000-0000-0000-0000-000000000000	81632835-af88-4c41-a49a-0c18c41eaf94	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 08:26:47.549259+00	
00000000-0000-0000-0000-000000000000	430d4b56-cd11-42c3-890d-e84446cdeb58	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 08:26:47.55022+00	
00000000-0000-0000-0000-000000000000	1b068792-cd2e-4366-b9d0-b785f6302494	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 11:34:27.101903+00	
00000000-0000-0000-0000-000000000000	909c7081-63d0-4382-a370-8aa072592b6b	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 11:34:27.102953+00	
00000000-0000-0000-0000-000000000000	1e1c48c8-261d-4965-83b4-87fb23a3e923	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 12:42:57.212606+00	
00000000-0000-0000-0000-000000000000	d6a2fcd0-b03b-40a9-8b6a-f7d337665bb6	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 12:42:57.213569+00	
00000000-0000-0000-0000-000000000000	974c620e-ff7f-424d-9925-b96e58d3568a	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 14:00:11.0401+00	
00000000-0000-0000-0000-000000000000	59ec180c-12db-4696-b75d-24b91b2fa0c6	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 14:00:11.041167+00	
00000000-0000-0000-0000-000000000000	d9813d60-6332-403c-a543-07b33800c0e2	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 16:02:25.733104+00	
00000000-0000-0000-0000-000000000000	34fdf6e5-9aa1-4277-b0f0-7ab6aa11bf14	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 16:02:25.734164+00	
00000000-0000-0000-0000-000000000000	a8a6d0a2-2b71-4c79-9a54-827e961f3ec2	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 17:01:01.427511+00	
00000000-0000-0000-0000-000000000000	3725fa51-2bc1-4030-a5c6-a698a01e8bb3	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 17:01:01.429107+00	
00000000-0000-0000-0000-000000000000	fb2cea88-a1e7-450d-a964-85600ae27382	{"action":"token_refreshed","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 18:00:01.42191+00	
00000000-0000-0000-0000-000000000000	02c0dce8-ab31-428e-8ac2-cc2e6804a1c0	{"action":"token_revoked","actor_id":"fd667865-de1e-4f75-9701-db02d60d2b6e","actor_username":"danielpadraic@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-18 18:00:01.423422+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
4174dc1e-6d0b-4e69-a716-1654abf40f1e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{"sub": "4174dc1e-6d0b-4e69-a716-1654abf40f1e", "email": "none@none.com", "email_verified": false, "phone_verified": false}	email	2025-02-26 04:28:22.623013+00	2025-02-26 04:28:22.623059+00	2025-02-26 04:28:22.623059+00	fbc6d881-93bc-4ca1-92db-f8bd15bbae66
8935db97-9a3d-4058-9589-6e0f9b01ee84	8935db97-9a3d-4058-9589-6e0f9b01ee84	{"sub": "8935db97-9a3d-4058-9589-6e0f9b01ee84", "email": "grant@gravicdesign.com", "email_verified": false, "phone_verified": false}	email	2025-02-27 17:48:46.112031+00	2025-02-27 17:48:46.112089+00	2025-02-27 17:48:46.112089+00	c7bfb735-3fea-43d2-a8a1-54301017cf2c
fd667865-de1e-4f75-9701-db02d60d2b6e	fd667865-de1e-4f75-9701-db02d60d2b6e	{"sub": "fd667865-de1e-4f75-9701-db02d60d2b6e", "email": "danielpadraic@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-04-11 01:32:57.38082+00	2025-04-11 01:32:57.380878+00	2025-04-11 01:32:57.380878+00	499395a9-b470-4b25-bd5f-1b7413743a2a
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
36137970-d1f3-49b9-bd41-ad5065de0ce1	2025-03-04 04:41:54.407501+00	2025-03-04 04:41:54.407501+00	password	32436595-e359-4b78-8491-cbb4669a7cce
962c97ff-d6a0-4363-99c4-07d4111b69ad	2025-03-04 16:01:05.259023+00	2025-03-04 16:01:05.259023+00	password	659c424a-24ab-4be2-b865-58318d9a9163
3b649b0c-41b9-4e0c-8ddb-646197ea978a	2025-04-11 01:32:57.394891+00	2025-04-11 01:32:57.394891+00	password	737ac178-9a50-438e-8b29-091ada633ed4
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	73	QgdX6znWNMEvtoeTFJ0ohA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 15:42:06.6351+00	2025-03-04 16:40:47.749553+00	CweUi9AobRgp85doXrk0oA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	76	XY70qMvu4Zg2kvExidXWgg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 16:40:47.751312+00	2025-03-04 17:39:23.655503+00	QgdX6znWNMEvtoeTFJ0ohA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	77	943UzdcCmtxaTEHsG4aYwA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 17:39:23.656745+00	2025-03-04 23:01:52.288827+00	XY70qMvu4Zg2kvExidXWgg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	78	w_avnHKRBlQIpdBR8-0aNA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 23:01:52.29233+00	2025-03-05 00:00:27.245398+00	943UzdcCmtxaTEHsG4aYwA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	79	v9MeelDpg1HJWPvVq-24iQ	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-05 00:00:27.246572+00	2025-03-05 00:59:27.155339+00	w_avnHKRBlQIpdBR8-0aNA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	64	1ObvibdocmLQqYdMeTzqfg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 04:41:54.403567+00	2025-03-04 05:39:58.594307+00	\N	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	65	7iHimsAiXt_L2WDldeLqeA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 05:39:58.600785+00	2025-03-04 06:38:13.270534+00	1ObvibdocmLQqYdMeTzqfg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	66	vC09PfXWQZDKKuDLCDwfpA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 06:38:13.278168+00	2025-03-04 07:50:35.509424+00	7iHimsAiXt_L2WDldeLqeA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	67	g7e7yZF_ajcXqgk0dULSIg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 07:50:35.510046+00	2025-03-04 09:36:22.8232+00	vC09PfXWQZDKKuDLCDwfpA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	68	MRYoevE2HxaU6k2jKgpctg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 09:36:22.824394+00	2025-03-04 11:14:15.445633+00	g7e7yZF_ajcXqgk0dULSIg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	69	kzMzkLhmLvV709s9XSJ0oQ	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 11:14:15.449854+00	2025-03-04 12:37:26.881673+00	MRYoevE2HxaU6k2jKgpctg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	70	sgrOHk0GCWt2MhW6-y2xKQ	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 12:37:26.883195+00	2025-03-04 13:43:56.498676+00	kzMzkLhmLvV709s9XSJ0oQ	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	71	ptHdgRv0n6EFb1K0SwcZ1w	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 13:43:56.501598+00	2025-03-04 14:43:06.583162+00	sgrOHk0GCWt2MhW6-y2xKQ	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	72	CweUi9AobRgp85doXrk0oA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 14:43:06.586134+00	2025-03-04 15:42:06.633839+00	ptHdgRv0n6EFb1K0SwcZ1w	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	75	YRwFCbWBvwXDYWpIxdsy2A	8935db97-9a3d-4058-9589-6e0f9b01ee84	f	2025-03-04 16:01:05.255037+00	2025-03-04 16:01:05.255037+00	\N	962c97ff-d6a0-4363-99c4-07d4111b69ad
00000000-0000-0000-0000-000000000000	80	RS-lzBb2MUmzHREj0vthvg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-05 00:59:27.155938+00	2025-04-10 20:07:51.64515+00	v9MeelDpg1HJWPvVq-24iQ	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	81	4U2TUw-3jAc1BAhcSTm2pg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f	2025-04-10 20:07:51.645935+00	2025-04-10 20:07:51.645935+00	RS-lzBb2MUmzHREj0vthvg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	82	KWshbR-1k7vbC5L4lXMlqw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-11 01:32:57.393012+00	2025-04-11 02:31:20.898881+00	\N	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	83	Eg_ptCtjWJPVo4s38Zj2dA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-11 02:31:20.899524+00	2025-04-11 16:31:03.407492+00	KWshbR-1k7vbC5L4lXMlqw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	84	mLplRCQZYEW9Hz1wYCgSLA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-11 16:31:03.40933+00	2025-04-11 17:30:30.253372+00	Eg_ptCtjWJPVo4s38Zj2dA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	85	PkQTnBynJMQTBNHSyiOdOQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-11 17:30:30.254152+00	2025-04-11 18:29:36.24912+00	mLplRCQZYEW9Hz1wYCgSLA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	86	Rewg578-ZpAG1uFW2QQRQw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-11 18:29:36.249827+00	2025-04-11 19:30:08.532074+00	PkQTnBynJMQTBNHSyiOdOQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	87	QkyTqQpBy93ayFcfSHn7Zg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-11 19:30:08.532729+00	2025-04-16 03:03:20.914855+00	Rewg578-ZpAG1uFW2QQRQw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	88	LNWxef1Lhum8G38JImzETQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 03:03:20.915543+00	2025-04-16 04:02:08.73385+00	QkyTqQpBy93ayFcfSHn7Zg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	89	FUU3zajU5wp-_ox6ZzRvjg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 04:02:08.734539+00	2025-04-16 05:07:23.10957+00	LNWxef1Lhum8G38JImzETQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	90	k49q6TI-OF-OTGazb37ACQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 05:07:23.110254+00	2025-04-16 07:42:54.036298+00	FUU3zajU5wp-_ox6ZzRvjg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	91	rV125YAKhuuPnQkwO8u61w	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 07:42:54.037066+00	2025-04-16 09:20:06.550043+00	k49q6TI-OF-OTGazb37ACQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	92	gBN-EcR-ym4vICkCbrog0Q	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 09:20:06.550685+00	2025-04-16 11:24:55.221321+00	rV125YAKhuuPnQkwO8u61w	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	93	dHjQRAcuwkfR0sC9LJ02UQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 11:24:55.22197+00	2025-04-16 13:04:27.297438+00	gBN-EcR-ym4vICkCbrog0Q	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	94	EnjVjIc5SCAnPf56lIvknA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 13:04:27.298096+00	2025-04-16 14:41:53.978029+00	dHjQRAcuwkfR0sC9LJ02UQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	95	t3PxChTMWw3hmO5nxmgGVQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 14:41:53.97865+00	2025-04-16 15:45:53.982066+00	EnjVjIc5SCAnPf56lIvknA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	96	LVgeIhuqXdUEvIxkRyUtlA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 15:45:53.982861+00	2025-04-16 16:56:33.349214+00	t3PxChTMWw3hmO5nxmgGVQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	97	_ZEJdoh6TmV5rCeqiZE2bg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 16:56:33.34995+00	2025-04-16 18:09:34.588557+00	LVgeIhuqXdUEvIxkRyUtlA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	98	ldiJvfW9X5lkzColQiKXLA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 18:09:34.589334+00	2025-04-16 19:10:19.829331+00	_ZEJdoh6TmV5rCeqiZE2bg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	99	16X6LLVNRyWwAFzQG6Y_Jg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 19:10:19.830109+00	2025-04-16 20:11:27.840426+00	ldiJvfW9X5lkzColQiKXLA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	100	7mvrqJihhe8K6O79lfduEg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 20:11:27.841152+00	2025-04-16 21:12:43.604639+00	16X6LLVNRyWwAFzQG6Y_Jg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	101	O6fv36Rp2hDDXVXcr6FC7Q	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 21:12:43.605382+00	2025-04-16 22:13:26.565405+00	7mvrqJihhe8K6O79lfduEg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	102	NwYmY2vTb66fSloff7CsVw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 22:13:26.566068+00	2025-04-16 23:54:29.402997+00	O6fv36Rp2hDDXVXcr6FC7Q	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	103	YpVibAlcutN4sGJYdQh6Aw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-16 23:54:29.40369+00	2025-04-17 01:16:41.321174+00	NwYmY2vTb66fSloff7CsVw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	104	HjGwq9AAkrYGc6V2xBGZGA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 01:16:41.321909+00	2025-04-17 03:18:32.164648+00	YpVibAlcutN4sGJYdQh6Aw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	105	Bo0SDKtGKLkDjEavmgcgzQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 03:18:32.165359+00	2025-04-17 05:56:58.072816+00	HjGwq9AAkrYGc6V2xBGZGA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	106	QrYQpCekEfNwyzWvDiMsEw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 05:56:58.07358+00	2025-04-17 10:04:11.009564+00	Bo0SDKtGKLkDjEavmgcgzQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	107	egL4ihN7aOpH5FDcRtDcMw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 10:04:11.010379+00	2025-04-17 12:03:56.100005+00	QrYQpCekEfNwyzWvDiMsEw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	108	GOSJcv7T3MqDLFj53DKcJA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 12:03:56.100851+00	2025-04-17 13:44:52.036157+00	egL4ihN7aOpH5FDcRtDcMw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	109	-udLgJQfhN4bUJyT--JapQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 13:44:52.036867+00	2025-04-17 15:10:08.55701+00	GOSJcv7T3MqDLFj53DKcJA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	110	H01uxXi72LqNPOh-nDVGhQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 15:10:08.557721+00	2025-04-17 16:11:08.42054+00	-udLgJQfhN4bUJyT--JapQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	111	kmkyyNCFcVZDC_4T1lylZA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 16:11:08.421294+00	2025-04-17 17:14:53.54274+00	H01uxXi72LqNPOh-nDVGhQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	112	BEjIb39QBQxmszAKlf2YZQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 17:14:53.543408+00	2025-04-17 18:51:57.506259+00	kmkyyNCFcVZDC_4T1lylZA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	113	SQtjLgPbvHLq8A6sWRyKTQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 18:51:57.506918+00	2025-04-17 20:16:55.233792+00	BEjIb39QBQxmszAKlf2YZQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	114	hSQJM0Yr4UqUh5FtH-doww	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 20:16:55.234474+00	2025-04-17 21:18:13.85301+00	SQtjLgPbvHLq8A6sWRyKTQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	115	BjwDmc6PS29Xpdhq3Lgx_A	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 21:18:13.853701+00	2025-04-17 22:18:57.783643+00	hSQJM0Yr4UqUh5FtH-doww	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	116	jTOLkYI1L6bdTrnkeGUcpg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 22:18:57.784327+00	2025-04-17 23:18:20.277454+00	BjwDmc6PS29Xpdhq3Lgx_A	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	117	pH8s5BNilDYCfNNsGMKNaw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-17 23:18:20.278117+00	2025-04-18 00:17:29.353387+00	jTOLkYI1L6bdTrnkeGUcpg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	118	j3TUd9AaWCw0DoMraQWzDg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 00:17:29.354136+00	2025-04-18 01:16:29.354195+00	pH8s5BNilDYCfNNsGMKNaw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	119	B8mRy_SIG57qjNCQM0mp3w	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 01:16:29.354909+00	2025-04-18 02:15:28.366206+00	j3TUd9AaWCw0DoMraQWzDg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	120	G7GDyFgjNANoOK4l-93m_g	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 02:15:28.366825+00	2025-04-18 03:58:41.703623+00	B8mRy_SIG57qjNCQM0mp3w	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	121	sGSlJtk_mxQx11-wJsCayg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 03:58:41.704286+00	2025-04-18 06:00:30.992843+00	G7GDyFgjNANoOK4l-93m_g	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	122	yE9fEuobMAX88pLPXmNMZA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 06:00:30.993526+00	2025-04-18 08:26:47.550778+00	sGSlJtk_mxQx11-wJsCayg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	123	0xyiZ_YhrRI56_3wnprUng	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 08:26:47.551559+00	2025-04-18 11:34:27.103595+00	yE9fEuobMAX88pLPXmNMZA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	124	aGMLojNeBxjRmKd9Axgj3w	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 11:34:27.10434+00	2025-04-18 12:42:57.214055+00	0xyiZ_YhrRI56_3wnprUng	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	125	WMBffgOhQ2WTaVckXvOlTg	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 12:42:57.215444+00	2025-04-18 14:00:11.041755+00	aGMLojNeBxjRmKd9Axgj3w	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	126	0cZGcCGZPIWEyXgckNZ-TA	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 14:00:11.042609+00	2025-04-18 16:02:25.734696+00	WMBffgOhQ2WTaVckXvOlTg	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	127	AuuWtPeaheEev4_LOc8iPw	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 16:02:25.73539+00	2025-04-18 17:01:01.429653+00	0cZGcCGZPIWEyXgckNZ-TA	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	128	t21xm-z9Z79nGj-cenV6xQ	fd667865-de1e-4f75-9701-db02d60d2b6e	t	2025-04-18 17:01:01.430352+00	2025-04-18 18:00:01.425206+00	AuuWtPeaheEev4_LOc8iPw	3b649b0c-41b9-4e0c-8ddb-646197ea978a
00000000-0000-0000-0000-000000000000	129	RFUHfxMaxTAyHUG-DXIOrQ	fd667865-de1e-4f75-9701-db02d60d2b6e	f	2025-04-18 18:00:01.4273+00	2025-04-18 18:00:01.4273+00	t21xm-z9Z79nGj-cenV6xQ	3b649b0c-41b9-4e0c-8ddb-646197ea978a
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
962c97ff-d6a0-4363-99c4-07d4111b69ad	8935db97-9a3d-4058-9589-6e0f9b01ee84	2025-03-04 16:01:05.251813+00	2025-03-04 16:01:05.251813+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	5.182.32.111	\N
36137970-d1f3-49b9-bd41-ad5065de0ce1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 04:41:54.401933+00	2025-04-10 20:07:51.648565+00	\N	aal1	\N	2025-04-10 20:07:51.648486	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36	184.155.198.138	\N
3b649b0c-41b9-4e0c-8ddb-646197ea978a	fd667865-de1e-4f75-9701-db02d60d2b6e	2025-04-11 01:32:57.391783+00	2025-04-18 18:00:01.431979+00	\N	aal1	\N	2025-04-18 18:00:01.431895	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	184.155.198.138	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	8935db97-9a3d-4058-9589-6e0f9b01ee84	authenticated	authenticated	grant@gravicdesign.com	$2a$10$WiGaopt1K5.ibhOzT7dRsue4PZD7VDXIF8zeURUh9ohbnvGOx179q	2025-02-27 17:48:46.117546+00	\N		\N		2025-03-04 02:43:16.361382+00			\N	2025-03-04 16:01:05.251106+00	{"provider": "email", "providers": ["email"]}	{"sub": "8935db97-9a3d-4058-9589-6e0f9b01ee84", "email": "grant@gravicdesign.com", "email_verified": true, "phone_verified": false}	\N	2025-02-27 17:48:46.096097+00	2025-03-04 16:01:05.258494+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4174dc1e-6d0b-4e69-a716-1654abf40f1e	authenticated	authenticated	none@none.com	$2a$10$0GxlfcyxYBuy9q/gA2x9gOTqfs0Qv/Yg1lSuOu8ovH/H.cKWtBFNW	2025-02-26 04:28:22.626012+00	\N		\N		\N			\N	2025-03-04 04:41:54.401281+00	{"provider": "email", "providers": ["email"]}	{"sub": "4174dc1e-6d0b-4e69-a716-1654abf40f1e", "email": "none@none.com", "email_verified": true, "phone_verified": false}	\N	2025-02-26 04:28:22.617771+00	2025-04-10 20:07:51.647078+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	fd667865-de1e-4f75-9701-db02d60d2b6e	authenticated	authenticated	danielpadraic@gmail.com	$2a$10$h6E0XCjoPNdXjBa8zYvs3uS85G3otdo/M8Uqdj4Ab4aoH/1EY1yTe	2025-04-11 01:32:57.386457+00	\N		\N		\N			\N	2025-04-11 01:32:57.391709+00	{"provider": "email", "providers": ["email"]}	{"sub": "fd667865-de1e-4f75-9701-db02d60d2b6e", "email": "danielpadraic@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-04-11 01:32:57.373115+00	2025-04-18 18:00:01.428986+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: cron; Owner: supabase_admin
--

COPY cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) FROM stdin;
2	0 * * * *	SELECT cleanup_expired_stories();	localhost	5432	postgres	postgres	t	cleanup-expired-stories
\.


--
-- Data for Name: job_run_details; Type: TABLE DATA; Schema: cron; Owner: supabase_admin
--

COPY cron.job_run_details (jobid, runid, job_pid, database, username, command, status, return_message, start_time, end_time) FROM stdin;
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blocks (id, blocker_id, blocked_id, created_at) FROM stdin;
\.


--
-- Data for Name: bookmarks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookmarks (user_id, content_type, content_id, created_at) FROM stdin;
\.


--
-- Data for Name: challenge_lobbies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_lobbies (id, challenge_id, name, created_at) FROM stdin;
\.


--
-- Data for Name: challenge_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_participants (id, challenge_id, user_id, joined_at, "position", score) FROM stdin;
ae09871a-9983-417f-9007-26554abe4bf5	287e5a38-68db-4587-a7f3-cc16f1530206	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 19:11:17.757431	0	0
0e3abda7-4a60-4c22-b24b-38be28991705	0439a9ac-83ba-4073-9590-956d5852ddf4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 20:53:46.047087	0	0
4ce800e5-b617-4de1-86e9-9ce48faffbe2	d636f426-a9ad-44ec-a91a-337fc0b422bd	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 20:53:51.595193	0	0
36c552ab-5a6a-4b7a-bd3a-77d180981d86	09b58dac-817c-494e-aff1-fccd7a920616	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 21:04:42.265665	0	0
051dfce7-c827-46df-9686-76e1878855ed	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 23:01:35.818903	0	0
dbad233e-4e2a-42a5-ad6a-887031db1bc7	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:42:12.847017	0	0
a47e96e9-501b-4da4-b4ea-5a77b899ca54	287e5a38-68db-4587-a7f3-cc16f1530206	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:42:16.274837	0	0
de33db24-a0d8-44c2-abd2-4811fff7d73b	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:45:06.29535	0	0
922c432f-ac77-4a74-82ec-f60a491691e4	287e5a38-68db-4587-a7f3-cc16f1530206	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:45:31.889004	0	0
1e662743-1d7b-4257-beba-5a15a09c91d9	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-03 23:24:06.190678	0	0
057984dd-4dec-4b35-907d-34162f5778ab	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-03 23:24:08.858413	0	0
7d274d90-1cb2-4658-be45-52ff430ddb2f	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-03 23:24:11.224573	0	0
14290ebf-38af-448e-8cc1-e43a4c1ab022	2d7e28dc-f82f-4b74-a30e-6a1ad5d3f210	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 00:55:06.283038	0	0
058cd0a3-abad-44ef-b134-e079bb9575e6	fd339687-04aa-46ca-8b51-7b1f9dd83203	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:44:01.076622	0	0
b01c05b0-0987-45bb-8c51-f892369bd920	f063d1f4-0b98-436b-a401-75cd670e5127	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:49:38.702171	0	0
e340bd7c-6a14-4dca-8c35-1ff5326487d5	5e1adc0e-7401-4995-a2f8-d9340123a07a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 04:25:17.526023	0	0
\.


--
-- Data for Name: challenge_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_types (id, name, usage_count) FROM stdin;
1	Fitness	0
2	Other	0
\.


--
-- Data for Name: challenges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenges (id, title, type, participants_current, participants_max, cost, prize_pool, scoring_type, is_public, created_at, created_by, challenge_name, challenge_type, max_participants, buy_in_cost, additional_prize_money, prize_type, prize_amount, number_of_winners, is_private, invitation_link, cover_media, start_datetime, end_datetime, creator_id, creator_participating) FROM stdin;
0439a9ac-83ba-4073-9590-956d5852ddf4	Test Challenge 1	Reading Books	1	0	0.00	0.00	Points	t	2025-02-27 02:15:45.546221+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	5	0	winner_takes_all	\N	\N	f	\N	\N	2025-03-20 21:01:12.417385+00	2025-03-05 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
2d7e28dc-f82f-4b74-a30e-6a1ad5d3f210	Jane's Walking Challenge	Fitness	1	0	0.00	0.00	Distance	t	2025-02-27 02:29:25.357343+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	400	0	winner_takes_all	\N	\N	f	\N	\N	2025-02-27 21:01:12.417385+00	2025-03-22 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
d636f426-a9ad-44ec-a91a-337fc0b422bd	Grant's Challenge	Fitness	1	5	0.00	0.00	Consistency	t	2025-02-27 13:21:14.908055+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	20	200	winner_takes_all	\N	\N	f	\N	\N	2025-03-15 21:01:12.417385+00	2025-03-22 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
287e5a38-68db-4587-a7f3-cc16f1530206	Gravic Challenge	Fitness	1	6	0.00	0.00	Points	t	2025-02-27 17:49:41.083809+00	8935db97-9a3d-4058-9589-6e0f9b01ee84	\N	\N	\N	10	100	winner_takes_all	\N	\N	f	\N	\N	2025-03-03 16:00:00+00	2025-03-28 16:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
09b58dac-817c-494e-aff1-fccd7a920616	Bob's Running Challenge	Fitness	1	0	0.00	0.00	Time (High)	t	2025-02-27 04:59:56.112283+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	25	350	tournament	\N	\N	f	\N	\N	2025-03-28 21:01:12.417385+00	2025-04-01 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
e793e456-36fa-47d2-a143-c1bb42742ed5	bl0b-a-thon	Fitness	0	250	0.00	0.00	Time (High)	t	2025-02-27 22:15:23.737916+00	\N	\N	\N	\N	25	25000	tournament	\N	\N	t	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1740694523059-1024.png	2025-02-28 15:15:00+00	2025-03-03 15:15:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
fd339687-04aa-46ca-8b51-7b1f9dd83203	bl0b-run	Fitness	0	10000	0.00	0.00	Consistency	t	2025-03-04 01:44:00.973373+00	\N	\N	\N	\N	100	2500	evenly_distributed	\N	1000	f	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1741052639691-Asset%201@4x.png	2025-03-05 10:00:00+00	2025-03-31 10:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t
f063d1f4-0b98-436b-a401-75cd670e5127	Bible in 90-Days	Bible Reading	0	0	0.00	0.00	Consistency	t	2025-03-04 01:49:38.532532+00	\N	\N	\N	\N	0	0	just_for_fun	\N	\N	f	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1741052977711-bible.jpg	2025-03-04 09:00:00+00	2025-04-01 00:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t
5e1adc0e-7401-4995-a2f8-d9340123a07a	Jay's Chores	Chore Challenge!	0	1	0.00	0.00	Consistency	t	2025-03-04 01:51:30.990814+00	\N	\N	\N	\N	0	5	winner_takes_all	\N	\N	t	\N	\N	2025-03-09 00:00:00+00	2025-03-16 00:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
364a2611-28e0-4aa9-9f81-9b5f56961837	Jonathan's Workout Challenge	Fitness	0	0	0.00	0.00	Consistency	t	2025-03-04 16:21:12.76892+00	\N	\N	\N	\N	20	150	tournament	\N	\N	f	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1741105272110-bible.jpg	2025-03-05 00:00:00+00	2025-04-04 00:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, post_id, user_id, content, created_at, parent_id) FROM stdin;
\.


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follows (id, follower_id, following_id, created_at) FROM stdin;
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friends (id, user_id, friend_id, created_at) FROM stdin;
\.


--
-- Data for Name: friendships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friendships (id, user_id, friend_id, created_at) FROM stdin;
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_members (id, group_id, user_id) FROM stdin;
\.


--
-- Data for Name: message_threads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_threads (id, created_at, updated_at, last_message_preview) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, thread_id, user_id, content, media_url, created_at, edited_at, is_deleted) FROM stdin;
\.


--
-- Data for Name: news_feed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.news_feed (id, message, created_at) FROM stdin;
451917a0-4676-43f3-a069-c13feccb9d24	Challenge "Run Fest" has a winner!	2025-02-27 19:15:19.904476
a3831b08-aea7-4bd7-8481-0d5624e6a994	New challenge "Push-Up Pro" created!	2025-02-27 19:15:19.904476
\.


--
-- Data for Name: post_reactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_reactions (id, post_id, user_id, reaction_type, created_at) FROM stdin;
990d5c8e-7d65-45a0-a4b0-dfe09146eb4c	4019b449-0473-40a5-85b2-ddbb77afcc06	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-02-28 00:58:41.604477+00
47fd89a3-1e51-46d2-80b4-50b82eacc1ef	a0a59b4a-086d-40bb-b2a3-f97c07fe31a7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-02-28 00:58:48.529056+00
f452ccea-2450-4398-b7c0-36b348803d30	4019b449-0473-40a5-85b2-ddbb77afcc06	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-02-28 01:07:25.240976+00
72982d1b-1ef6-42fe-9e1a-de85e74615b0	a0a59b4a-086d-40bb-b2a3-f97c07fe31a7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	laugh	2025-02-28 01:18:53.456028+00
fc01e485-1cac-4e7e-8921-4eb468f03b62	e6ceba81-24f5-40a8-872d-a537955f7b21	4174dc1e-6d0b-4e69-a716-1654abf40f1e	comfort	2025-02-28 02:17:03.749061+00
2d3e39a3-6c08-4482-88cf-4ea70aa23231	e6ceba81-24f5-40a8-872d-a537955f7b21	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-02-28 02:17:15.142426+00
f28389d7-7145-468a-9667-8f1cabe3cdd3	d53ffa0f-de38-4e57-a7b9-09588d85850a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-02-28 05:43:40.509229+00
bf517ab9-b7c3-4e98-be0c-457f90bb9c62	b6052d87-3d4b-4e49-b44e-34b3391dfb82	4174dc1e-6d0b-4e69-a716-1654abf40f1e	laugh	2025-03-03 18:13:05.601597+00
e2bb6c00-51d3-4503-9fb6-4301940f0ee2	e4f3badc-ee8a-43da-817e-a136748d0cab	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-03-03 18:13:09.670989+00
ccc79db4-dbf0-4089-9a9d-bdcd7800e0ff	9d4a84e5-8e59-4291-9af0-7ef0145d6451	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-03-03 18:13:11.398502+00
3da4bf42-ecfb-402d-8092-a341bcbc978b	ecf07b31-16f6-4819-a76d-f0ef735106fa	4174dc1e-6d0b-4e69-a716-1654abf40f1e	comfort	2025-03-03 19:16:39.143221+00
a2a74f5c-45ca-4a37-98ea-d4aab82bfe03	30634e98-6072-42c6-aa98-510053fc1a3a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	laugh	2025-03-04 01:06:52.173808+00
d19c738f-d6fa-4561-86ef-75d2b45c5b19	acd85b53-3520-47c8-a363-e4bd3e3f062d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-03-04 06:40:26.322121+00
fe79ebe5-b2e8-4202-b81f-c80dd5fcbd0c	acd85b53-3520-47c8-a363-e4bd3e3f062d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-03-04 12:38:49.524492+00
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, user_id, content, color_code, created_at, challenge_id, media_url, parent_id, media_urls) FROM stdin;
2a9326fd-bd0e-4077-8622-1bddbdb0c758	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Say something!\n	\N	2025-02-28 00:25:10.882	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
8322b947-167b-42b3-89b8-84b1deb3e745	\N	Completed task: Run a Marathon!	\N	2025-02-28 00:27:10.590551	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
fef7328a-8f04-4d27-828b-0c343ed70cb1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 00:27:10.709	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
96d98179-07e3-4819-be8e-1db663f9259f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I don't want to.	\N	2025-02-28 00:27:37.918	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	2a9326fd-bd0e-4077-8622-1bddbdb0c758	{}
a0a59b4a-086d-40bb-b2a3-f97c07fe31a7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 00:42:29.139	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
665eeb4a-3adf-4c48-8048-9271565ff614	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Great Job!	\N	2025-02-28 00:46:34.206	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	fef7328a-8f04-4d27-828b-0c343ed70cb1	{}
4019b449-0473-40a5-85b2-ddbb77afcc06	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 00:46:52.995	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
0d4dd596-4ed6-4a9e-bee3-f661d413711e	4174dc1e-6d0b-4e69-a716-1654abf40f1e		\N	2025-02-28 02:02:25.119	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://media0.giphy.com/media/ftqLysT45BJMagKFuk/200.gif?cid=82dc00adynoyaivtvaur3fpsykvqxftxx6b83vpjmy5je02d&ep=v1_gifs_search&rid=200.gif&ct=g}	\N	{}
a2edbc63-e372-4719-a288-3eb0a3a67e7c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Neither do I!	\N	2025-02-28 02:10:21.473	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
e6ceba81-24f5-40a8-872d-a537955f7b21	4174dc1e-6d0b-4e69-a716-1654abf40f1e	What's up, ya'll?!\n	\N	2025-02-28 02:16:58.766	d636f426-a9ad-44ec-a91a-337fc0b422bd	{}	\N	{}
4efba640-568d-49e7-a327-8a5a02b881d7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45	\N	2025-02-28 02:59:06.58	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
d53ffa0f-de38-4e57-a7b9-09588d85850a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45	\N	2025-02-28 03:13:32.212	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
ad160bbd-4523-437a-81be-39075b92406f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45 and attached files.	\N	2025-02-28 03:36:15.492	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713774997-80.png}	\N	{}
25fb2e48-73c2-42d7-bc75-5649ab83c001	4174dc1e-6d0b-4e69-a716-1654abf40f1e		\N	2025-02-28 03:36:34.879	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713794428-80.png}	\N	{}
6076047c-4bcd-4cba-8700-f54f194bd9d5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 03:38:12.887	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
9046d4d7-78cf-4d92-9820-26e0793175ee	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45 and attached files.	\N	2025-02-28 03:39:18.674	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713958093-80.png}	\N	{}
bdbe8bcb-3cb4-460f-810e-d2b54f774092	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw completed task: Run a Marathon! with Time Entry: 13:45:21 and attached files.	\N	2025-02-28 03:44:24.88	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740714264434-50.png}	\N	{}
d56bd5ae-a830-45d4-b978-c5563ee5f3bd	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 03:54:47.938	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
0ddcab38-7a93-4c0c-8774-cfdb377c11fc	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Don't tell me what to do!	\N	2025-02-28 04:30:42.106	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
14c933d9-0d4c-45df-9d20-ddfbc4b0a4d2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Good job!	\N	2025-02-28 04:31:05.241	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	8322b947-167b-42b3-89b8-84b1deb3e745	{}
f7e70d1a-1f1e-41c4-884c-e6a66f2d2605	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Good work!	\N	2025-02-28 04:31:12.012	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
6ec76e55-1e61-49fd-bf0e-8c6556dd35ab	4174dc1e-6d0b-4e69-a716-1654abf40f1e	whatever!	\N	2025-02-28 04:31:27.098	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	14c933d9-0d4c-45df-9d20-ddfbc4b0a4d2	{}
eb0fe57e-7a0f-4f0c-949a-aacffbe4bbe2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Boop	\N	2025-02-28 04:34:20.804	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	665eeb4a-3adf-4c48-8048-9271565ff614	{}
2714ff8b-99af-4499-a334-de00c1f45b44	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I did it!	\N	2025-02-28 04:35:35.927	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
e8a17294-8ded-4915-882a-8a6581e748df	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I drank a gallon!	\N	2025-02-28 04:36:39.712	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
76fe3aca-9095-46a8-8313-4912379ac9d3	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw I know, right?!	\N	2025-02-28 04:47:05.849	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	665eeb4a-3adf-4c48-8048-9271565ff614	{}
e9e7dc18-3538-491d-883f-ab7bc0d32e77	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown Right?!\n	\N	2025-02-28 04:47:21.678	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
7a9ef8a9-ee0c-42af-9c38-5795d0cd1238	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw completed Drink a Gallon of Water\nYeah, bro! I totes did it!	\N	2025-02-28 04:47:52.446	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
f7d92936-08ad-4b30-9465-9d61576d349d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown boop!	\N	2025-02-28 04:52:01.089	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	665eeb4a-3adf-4c48-8048-9271565ff614	{}
25619012-5e61-4cf9-ba5b-370cbb4637ad	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown hi	\N	2025-02-28 04:52:09.627	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	14c933d9-0d4c-45df-9d20-ddfbc4b0a4d2	{}
5c4cc6e1-1255-48d1-a57e-a16be857fef1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hey there!	\N	2025-02-28 05:02:25.44	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
2f48bb50-36ea-4d46-bfe2-072083484798	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Yeah, boy!	\N	2025-02-28 05:02:30.934	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	5c4cc6e1-1255-48d1-a57e-a16be857fef1	{}
ec7e4963-850e-401c-96e2-c43bb2bbd037	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw bonjour\n	\N	2025-02-28 05:07:54.326	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
4f48340f-3731-4bfe-bc58-6b66ba410ff1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Let's see if it works!	\N	2025-02-28 05:13:44.97	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
e66fc783-0e7f-467b-a277-1aaa8db40554	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Dang	\N	2025-02-28 05:13:53.858	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	9046d4d7-78cf-4d92-9820-26e0793175ee	{}
438f0f2c-0993-4cd0-8a46-96ad20cc4e1e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's up?\n	\N	2025-02-28 05:14:04.169	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	9046d4d7-78cf-4d92-9820-26e0793175ee	{}
3984fffa-4da6-411c-9224-efb6b3b84bd0	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi\n	\N	2025-02-28 05:41:54.862	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	d53ffa0f-de38-4e57-a7b9-09588d85850a	{}
e254faca-02c5-4e63-a2de-c0f513f218c5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Good job	\N	2025-02-28 05:41:59.315	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	3984fffa-4da6-411c-9224-efb6b3b84bd0	{}
ca2ef15c-57d5-4eae-a9eb-c9a72b14e69a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw giuguik	\N	2025-02-28 05:57:44.123	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
9d4a84e5-8e59-4291-9af0-7ef0145d6451	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw jhvi	\N	2025-02-28 05:57:48.965	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	ca2ef15c-57d5-4eae-a9eb-c9a72b14e69a	{}
e4f3badc-ee8a-43da-817e-a136748d0cab	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Good job.	\N	2025-03-03 17:44:02.568	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	7a9ef8a9-ee0c-42af-9c38-5795d0cd1238	{}
b6052d87-3d4b-4e49-b44e-34b3391dfb82	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw whatcho mean?	\N	2025-03-03 17:44:11.929	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
6733a7e7-17eb-4e85-a82c-70ab5eca594c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hello?	#ffffff	2025-03-03 18:44:15.081	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
c656c6d6-70dd-4fbe-911c-be4bfcc38cec	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hi!	#ffffff	2025-03-03 18:56:12.113	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
ecf07b31-16f6-4819-a76d-f0ef735106fa	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hello!	#ffffff	2025-03-03 18:59:56.819	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
1c5588c2-9c82-4224-9eaa-746917fc6aee	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's up, Bob?	#ffffff	2025-03-03 19:36:02.07	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e254faca-02c5-4e63-a2de-c0f513f218c5	{}
a2bdd4cf-4a54-49be-9c6d-dbaf2f12ffea	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Nothing Much	#ffffff	2025-03-03 19:36:22.238	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	1c5588c2-9c82-4224-9eaa-746917fc6aee	{}
a2f983e9-0e5a-4469-af03-c6541967b143	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Why is it posting like this?	#ffffff	2025-03-03 19:36:37.803	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	a2bdd4cf-4a54-49be-9c6d-dbaf2f12ffea	{}
96dc6cca-5de1-4859-b097-bf81d3daf126	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's happening?	#ffffff	2025-03-03 19:36:29.007	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	1c5588c2-9c82-4224-9eaa-746917fc6aee	{}
9bd41a67-1f04-4b38-a5cc-49438197addf	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey, what's up!?	#ffffff	2025-03-03 19:38:51.204	\N	\N	\N	{}
ce4ab032-7f67-4d26-87d8-593d75a95fef	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw righteous	#ffffff	2025-03-03 19:39:06.942	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	1c5588c2-9c82-4224-9eaa-746917fc6aee	{}
02283e31-3517-4fa7-94c2-62894885bf69	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Great job!	#ffffff	2025-03-03 19:56:40.766	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	9046d4d7-78cf-4d92-9820-26e0793175ee	{}
8cf7dcd8-ca0c-423d-bb0e-30d8e0680f02	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw I know, right?!	#ffffff	2025-03-03 19:56:46.049	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	02283e31-3517-4fa7-94c2-62894885bf69	{}
2c2f406a-d09c-43a7-8b3e-d1f3d8ab5125	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Thanks	#ffffff	2025-03-03 20:03:38.839	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
4551bfbb-f2e9-4e2c-b8d4-d489e4544232	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Sounds good	#ffffff	2025-03-03 20:13:34.447	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
7e890877-ff1d-487c-8c5c-d211a3896bef	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Thanks!	#ffffff	2025-03-03 20:13:39.402	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
c7879f5e-16f0-46d2-996b-e6dd7cc66b9f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hey!	#ffffff	2025-03-03 20:16:58.573	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	5c4cc6e1-1255-48d1-a57e-a16be857fef1	{}
4cc3ee6e-2f9e-41ff-b7ba-5b860d1e634d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi!	#ffffff	2025-03-03 20:17:25.462	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ec7e4963-850e-401c-96e2-c43bb2bbd037	{}
a1028653-0414-4fc3-918f-0fa345ec9774	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw This is another test comment.	#ffffff	2025-03-03 20:17:33.772	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	5c4cc6e1-1255-48d1-a57e-a16be857fef1	{}
bb320647-9508-430a-abed-e6ed4c37f2eb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Booyah!	#ffffff	2025-03-03 20:19:46.064	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	b6052d87-3d4b-4e49-b44e-34b3391dfb82	{}
719fb300-bdc1-4510-aa3d-0daec3d96339	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi!	#ffffff	2025-03-03 20:20:46.853	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
546aaf46-689d-4b2e-b17a-1f5d92942df5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw How are you?	#ffffff	2025-03-03 20:20:51.496	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	719fb300-bdc1-4510-aa3d-0daec3d96339	{}
6e9d4e22-73ac-4701-b965-ac8b7abc46aa	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Not bad, and you?	#ffffff	2025-03-03 20:22:53.689	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
62add388-9c0a-46b6-a1c2-8e9e4ad98bd4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hello?	#ffffff	2025-03-03 20:22:58.876	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
db202839-dcd3-47b9-bd15-63e78675a17a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's going on?	#ffffff	2025-03-03 20:23:04.04	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	c656c6d6-70dd-4fbe-911c-be4bfcc38cec	{}
02f55d65-0c5e-41fb-85e9-0a3817cbb9c9	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw I'm great, thank you!	#ffffff	2025-03-03 20:24:39.346	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	6e9d4e22-73ac-4701-b965-ac8b7abc46aa	{}
82b7de8c-a9a0-4a3e-a874-6d771e48bc17	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw haha.. that's funny	#ffffff	2025-03-03 21:10:58.121	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
cefd4142-aff0-4974-8492-35c8afa611bb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Good job!	#ffffff	2025-03-03 21:14:43.858	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
36564e76-46be-44f5-81b2-e87a0e0091a6	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw That's awesome!	#ffffff	2025-03-03 21:14:49.3	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
5370ff88-65b7-4cd8-a4b7-bc241bd91015	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Wow!	#ffffff	2025-03-03 21:14:52.443	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
94a581ad-ae77-48e3-bf5d-401feba0c1f2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Way to go!	#ffffff	2025-03-03 21:14:56.833	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
765377c3-ad9e-404f-bb0b-e717dce86f19	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Are you kidding me!?	#ffffff	2025-03-03 21:15:04.433	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
c136c3d6-0b5a-4212-b272-86c3484731e9	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw You sure about that?	#ffffff	2025-03-03 21:19:00.334	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
777b8101-ca54-414b-9729-0a387d922b65	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi!	#ffffff	2025-03-03 21:19:06.382	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
ada57b5d-0316-40fa-976f-b14b080dd3a1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Great job!	#ffffff	2025-03-03 21:19:10.033	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
f3d692de-5e14-4622-a378-bace2c894dba	4174dc1e-6d0b-4e69-a716-1654abf40f1e	This is a general post\n	#ffffff	2025-03-03 22:37:24.031	\N	\N	\N	{}
9afae28a-066d-4e9d-b8b7-38c1dce25cb7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey there!	#ffffff	2025-03-03 22:55:04.082	\N	\N	\N	{}
01583222-993b-4443-a878-f6093956acd8	4174dc1e-6d0b-4e69-a716-1654abf40f1e	What's Up!?\n	#ffffff	2025-03-03 22:55:09.168	\N	\N	\N	{}
a3deb286-58fd-4105-92bc-5a80a4bf9b7d	\N	This is a general post	\N	2025-03-03 23:01:30.745304	\N	{}	\N	{}
d69f240c-d121-4398-9e0b-1ceb5cfd931f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	How's it going?	#ffffff	2025-03-03 23:41:43.506	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	\N	{}
0cdab924-91a0-4299-9798-c614caed1f8f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw @bobleblaw Hey there.	#ffffff	2025-03-03 23:50:12.533	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	d69f240c-d121-4398-9e0b-1ceb5cfd931f	{}
26e1cbe4-28f0-4752-8b5e-6eb5bf05c2ae	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown Hoo-doggy!	#ffffff	2025-03-04 00:11:14.644	\N	\N	a3deb286-58fd-4105-92bc-5a80a4bf9b7d	{}
6908efaa-d79c-4532-b592-983db1a5190b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's happening now?	#ffffff	2025-03-04 00:11:22.242	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	0cdab924-91a0-4299-9798-c614caed1f8f	{}
76e77899-c122-4824-9579-6955b1c88b64	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What?!	#ffffff	2025-03-04 00:11:29.135	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	0cdab924-91a0-4299-9798-c614caed1f8f	{}
4f4b368f-ce63-4ef8-b1bb-7a72d9d96f26	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw It doesn't appear to be working...	#ffffff	2025-03-04 00:11:36.287	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	0cdab924-91a0-4299-9798-c614caed1f8f	{}
f2c5b027-37ab-448c-9076-58142dcb1280	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Oh yeah?	#ffffff	2025-03-04 00:12:43.209	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	719fb300-bdc1-4510-aa3d-0daec3d96339	{}
681772c2-672a-4c51-a78f-7e925450e391	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Where is this going?	#ffffff	2025-03-04 00:12:55.991	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
a53f70d2-6411-4904-bc85-d706558745ce	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown Hi 1	#ffffff	2025-03-04 00:30:19.148	\N	\N	26e1cbe4-28f0-4752-8b5e-6eb5bf05c2ae	{}
638d196b-2233-4c7e-8d1d-e624118e8fc5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown Hola! 2	#ffffff	2025-03-04 00:30:25.767	\N	\N	26e1cbe4-28f0-4752-8b5e-6eb5bf05c2ae	{}
e8d64191-bd52-4839-90e8-4fe6b5bbf703	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey there	#ffffff	2025-03-04 00:49:33.048	\N	\N	\N	{}
a76292cf-703c-4795-8026-f8c6dc753e2c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Booyah!	#ffffff	2025-03-04 00:55:11.314	2d7e28dc-f82f-4b74-a30e-6a1ad5d3f210	\N	\N	{}
95d69669-3f89-4f26-a943-09c9049d46b0	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey, ya'll!	#ffffff	2025-03-04 00:56:23.28	\N	\N	\N	{}
a1e01736-3879-448b-b588-2296e6f68ae1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's up!?	#ffffff	2025-03-04 00:56:45.943	\N	\N	e8d64191-bd52-4839-90e8-4fe6b5bbf703	{}
30634e98-6072-42c6-aa98-510053fc1a3a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Are you working now?!	#ffffff	2025-03-04 01:02:40.214	\N	\N	\N	{}
d9872985-95b0-440b-a6b4-8906624696cb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Is this working?	#ffffff	2025-03-04 01:07:11.568	\N	\N	e8d64191-bd52-4839-90e8-4fe6b5bbf703	{}
156aae4c-1de2-42e6-9e2d-00c697c49327	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw It appears so!	#ffffff	2025-03-04 01:07:23.361	\N	\N	d9872985-95b0-440b-a6b4-8906624696cb	{}
1f0846a5-266d-4781-b6eb-e275d34cb548	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Why do I have to refresh the page everytime I post a new comment?	#ffffff	2025-03-04 01:07:40.27	\N	\N	156aae4c-1de2-42e6-9e2d-00c697c49327	{}
931d59b8-d764-4558-a0fb-65c59f40d7cd	4174dc1e-6d0b-4e69-a716-1654abf40f1e	But there ARE posts!	#ffffff	2025-03-04 01:15:28.786	\N	\N	\N	{}
03fff4c8-1edd-4c5b-8cc9-2573092edb8b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Let's do this thing!	#ffffff	2025-03-04 01:24:11.566	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
f1a247cb-92d5-4399-9da4-0fe66babe6d5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Let's run! Invite your friends!	#ffffff	2025-03-04 01:44:21.171	fd339687-04aa-46ca-8b51-7b1f9dd83203	\N	\N	{}
6fe19ed4-93da-4df1-9240-275b0ed59a3c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Let's read!	#ffffff	2025-03-04 03:38:24.911	f063d1f4-0b98-436b-a401-75cd670e5127	\N	\N	{}
3eeae95a-0c92-434e-8507-cad0e9800b5e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw what up!	#ffffff	2025-03-04 05:13:47.697	\N	\N	156aae4c-1de2-42e6-9e2d-00c697c49327	{}
d1fa77c1-ecc0-45e0-a383-5c181210a127	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw ?	#ffffff	2025-03-04 05:13:56.017	\N	\N	156aae4c-1de2-42e6-9e2d-00c697c49327	{}
1c7c424f-edc7-4778-9877-52aa8f03ed16	4174dc1e-6d0b-4e69-a716-1654abf40f1e		#ffffff	2025-03-04 05:14:28.351	\N	{https://media3.giphy.com/media/tfUW8mhiFk8NlJhgEh/200.gif?cid=82dc00ad8kkert19hs79utthv23ogy6sl6m3abhgula9at2j&ep=v1_gifs_search&rid=200.gif&ct=g}	\N	{}
0b1d4267-3713-4c2e-85ed-d42c92e67798	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Oh yeah?	#ffffff	2025-03-04 05:32:29.246	\N	\N	1c7c424f-edc7-4778-9877-52aa8f03ed16	{}
8f21d82e-767b-42e8-b466-507e89cc44a2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Nice	#ffffff	2025-03-04 05:32:34.267	\N	\N	0b1d4267-3713-4c2e-85ed-d42c92e67798	{}
cc8f3e9f-0291-4d9e-a6ca-b0c4eb0a06bb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Excellent.	#ffffff	2025-03-04 05:32:40.681	\N	\N	0b1d4267-3713-4c2e-85ed-d42c92e67798	{}
3bfae5ea-16fc-435c-905e-5914d0623dd5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Wow.	#ffffff	2025-03-04 05:39:07.903	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	\N	{}
2b7dc382-ddc2-4a2c-87c7-4f362f319b93	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown wowowow	#ffffff	2025-03-04 05:39:14.945	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	3bfae5ea-16fc-435c-905e-5914d0623dd5	{}
fd92a2f5-8822-421a-b146-24208dc730c4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown Why does it think I'm anonumous?	#ffffff	2025-03-04 05:39:28.439	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
ca344934-e0e4-40b7-a800-fc75308b74b2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown It didn't that time	#ffffff	2025-03-04 05:39:36.383	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
b608b4fc-eaf5-4632-9153-a6162d2f4dde	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown What does "Challenge Post" mean?	#ffffff	2025-03-04 05:39:53.064	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
68c51512-9ce9-4aef-9321-f1966bb8070b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw whatchoo talkin' about?	#ffffff	2025-03-04 05:43:48.842	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
29834055-e3a1-498d-ad85-a405aed077c7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Oh yeah?	#ffffff	2025-03-04 05:43:55.657	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
0f5d22f0-64f4-4c20-89be-d1e82a44dc97	4174dc1e-6d0b-4e69-a716-1654abf40f1e	All done for the day!!	\N	2025-03-04 05:47:49.771	5e1adc0e-7401-4995-a2f8-d9340123a07a	{}	\N	{}
acd85b53-3520-47c8-a363-e4bd3e3f062d	\N	Buzz McCallister completed a task in #bl0b-a-thon!	\N	2025-03-04 06:37:04.571453	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
7c990718-c580-4f72-bc46-f489a36dc58b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I did it!	\N	2025-03-04 06:37:04.51	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1741070223958-bl0b%20coin%202.jpg}
e63ceed6-284b-44a4-a262-5828f00053b4	8935db97-9a3d-4058-9589-6e0f9b01ee84	Hello!	#ffffff	2025-03-04 15:59:35.062	\N	\N	\N	{}
4a9999a2-503f-4726-9297-ae7d2ca53dd8	8935db97-9a3d-4058-9589-6e0f9b01ee84	Testing Anon post.	#ffffff	2025-03-04 16:01:18.654	\N	\N	\N	{}
\.


--
-- Data for Name: private_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.private_groups (id, name, created_at) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, first_name, last_name, username, profile_photo_url, phone_number, phone_number_raw, address, participates_in_challenges, gender, dob, height, weight, body_fat_percentage, bmi, bmr, first_name_public, last_name_public, username_public, phone_number_public, address_public, participates_in_challenges_public, gender_public, dob_public, height_public, weight_public, body_fat_percentage_public, profile_photo_url_public, bmi_public, bmr_public) FROM stdin;
4174dc1e-6d0b-4e69-a716-1654abf40f1e	Buzz	McCallister	buzzmccallister	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/profile_photos/4174dc1e-6d0b-4e69-a716-1654abf40f1e.webp	5555555555	5555555555	123 Main St. Miami, FL 	t	Male	1975-01-01	75	239	21	29.9	2030	t	t	t	f	f	t	t	f	f	f	f	t	f	f
8935db97-9a3d-4058-9589-6e0f9b01ee84	\N	\N	gravic	\N	\N	\N	\N	f	\N	\N	0	0	0	\N	\N	f	f	t	f	f	f	f	f	f	f	f	t	f	f
fd667865-de1e-4f75-9701-db02d60d2b6e	Bob	Leblaw	bobleblaw	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/profile_photos/fd667865-de1e-4f75-9701-db02d60d2b6e.jpeg	2085555555		123 Anywhere St. Boise, ID 83702	t	Male	1975-01-01	75	235	20	29.4	2012	t	t	t	f	f	f	t	f	f	f	f	t	f	f
\.


--
-- Data for Name: social_channels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.social_channels (id, name, is_public, created_at) FROM stdin;
\.


--
-- Data for Name: stories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stories (id, user_id, media_url, text_overlay, interactive_element, created_at, expires_at, views, text_position, font_color, font_size) FROM stdin;
611bc87e-e6a9-42f2-b1c6-b52b960048c9	8935db97-9a3d-4058-9589-6e0f9b01ee84	https://images.unsplash.com/photo-1531804055935-76f44d7c3621?q=80&w=1288&auto=format&fit=crop	Test story using found user ID	{"type": "poll", "options": [{"text": "Option 1", "votes": []}, {"text": "Option 2", "votes": []}]}	2025-04-18 18:39:33.631064+00	2025-04-19 18:39:33.631064+00	0	center	#ffffff	medium
\.


--
-- Data for Name: story_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.story_views (id, user_id, story_id, viewed_at) FROM stdin;
\.


--
-- Data for Name: task_completions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_completions (id, task_id, user_id, challenge_id, submitted_data, created_at, status) FROM stdin;
8cb9552d-de69-44db-83a0-6a894612c31f	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 02:59:06.68317	pending
0c9c57f6-bd32-4677-9b7e-666200eb44c4	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 03:13:32.309974	pending
ef7ada72-f9ed-41bc-b54b-b7db1736c6de	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713774997-80.png"], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 03:36:15.585813	pending
4902e568-d67d-4456-8c14-e99bc2a03bfc	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713958093-80.png"], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 03:39:18.769338	pending
5b28fe6f-521c-4ee3-afdd-eb5eaf2bc4e7	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740714264434-50.png"], "verification": {"type": "Time Entry", "value": "13:45:21"}}	2025-02-28 03:44:24.977033	pending
c5ec22e3-ca8c-4068-91ee-c1522ceacbd0	0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "No Verification", "value": null}}	2025-02-28 04:35:35.986138	pending
afe691ac-206c-4b0e-b80f-6e6c59d2d247	0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "No Verification", "value": null}}	2025-02-28 04:36:39.764312	pending
0c80c9c7-b643-419a-b820-a56b8c6a9d62	0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "No Verification", "value": null}}	2025-02-28 04:47:52.465843	pending
0e4384ef-2a43-44bb-bba3-a14e8876e7f7	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "It was a video of a bunch of houses."}, "video_watched": true}	2025-03-04 04:25:57.550551	pending
95acd4c7-a2f6-40d6-adc8-029f4afacc72	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "blah"}, "video_watched": true}	2025-03-04 05:15:54.911836	pending
eac7634b-3423-46b9-a329-574aaddda4ab	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "It's a video."}, "video_watched": true}	2025-03-04 05:36:28.333232	pending
e0645b39-5664-4c43-b20c-1b6e65071480	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "It's a video."}, "video_watched": true}	2025-03-04 05:37:20.362154	pending
10292dfa-a745-4e64-a7e5-5c26e9237f57	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "Cool Video!"}, "video_watched": true}	2025-03-04 05:47:49.836758	pending
4da68bec-e153-46a4-8159-21e706ac8ca9	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1741070223958-bl0b%20coin%202.jpg"], "verification": {"type": "Time Entry", "value": "01:23:45"}, "video_watched": null}	2025-03-04 06:37:04.571453	pending
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, challenge_id, action, frequency, verification_type, notes, created_at, updated_at, require_attachment, completed, user_id, requires_attachment, media_url, require_video_completion) FROM stdin;
a8f35559-ec40-4a4b-8f9b-4f62ec56fda1	287e5a38-68db-4587-a7f3-cc16f1530206	Run a Mile	per day	Attachment Upload	You must run one mile every day of the challenge.	2025-02-27 21:31:35.935073+00	2025-02-27 21:31:35.935073+00	f	f	\N	f	\N	f
aaecda17-696a-4cd0-8e04-b84c5ed94b53	e793e456-36fa-47d2-a143-c1bb42742ed5	Run a Marathon!	per challenge	Time Entry	Run the bl0b-a-thon and then enter your race time and upload photos as proof.	2025-02-27 23:13:27.332937+00	2025-02-27 23:13:27.332937+00	t	t	\N	f	\N	f
0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	e793e456-36fa-47d2-a143-c1bb42742ed5	Drink a Gallon of Water	per day	No Verification		2025-02-28 04:27:47.627291+00	2025-02-28 04:27:47.627291+00	f	f	\N	f	\N	f
d22a113f-2204-4a26-9cf2-9a5edfda2171	5e1adc0e-7401-4995-a2f8-d9340123a07a	Sunday's Chores	per challenge	Text Form	What all did you do? Upload a picture at the end of the day.	2025-03-04 01:52:17.090464+00	2025-03-04 01:52:17.090464+00	t	f	\N	f	\N	f
a6586327-c636-4e38-8cfe-6c7414707ad5	5e1adc0e-7401-4995-a2f8-d9340123a07a	Watch this School Video	per challenge	Text Form	Watch this video and then tell me what you learned before you can move on from this task.	2025-03-04 04:06:15.168009+00	2025-03-04 04:06:15.168009+00	f	f	\N	f	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1741061171598-Home%20Page%20Background%20vid.mp4	t
\.


--
-- Data for Name: thread_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thread_participants (thread_id, user_id, joined_at, last_read_at) FROM stdin;
\.


--
-- Data for Name: user_challenge_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_challenge_logs (id, user_id, challenge_id, metric_value, logged_at, proof_url) FROM stdin;
\.


--
-- Data for Name: user_challenges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_challenges (id, user_id, challenge_id, joined_at) FROM stdin;
\.


--
-- Data for Name: user_relationships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_relationships (follower_id, following_id, relationship_type, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, username, bio, avatar_url, favorite_color, first_name, last_name, phone_number, address, participates_in_challenges, gender, height_inches, weight_lbs, body_fat_percentage, dob) FROM stdin;
4174dc1e-6d0b-4e69-a716-1654abf40f1e	none@none.com	bobleblaw	\N	\N	\N	Bob	Leblaw	5555555555	123 Main St. Miami, FL	f	\N	\N	\N	\N	\N
8935db97-9a3d-4058-9589-6e0f9b01ee84	grant@gravicdesign.com	gravic	\N	\N	\N	Grant	V	7025555555	123 Some St	t	male	71	325	3	1987-01-01
\.


--
-- Data for Name: whispers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.whispers (id, sender_id, recipient_id, content, created_at, read) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_13; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_13 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_14; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_14 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_15; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_15 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_16; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_16 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_17; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_17 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_18; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_18 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_19; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_19 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_20; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_20 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_04_21; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_04_21 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-02-25 20:12:18
20211116045059	2025-02-25 20:12:18
20211116050929	2025-02-25 20:12:18
20211116051442	2025-02-25 20:12:18
20211116212300	2025-02-25 20:12:18
20211116213355	2025-02-25 20:12:18
20211116213934	2025-02-25 20:12:18
20211116214523	2025-02-25 20:12:18
20211122062447	2025-02-25 20:12:18
20211124070109	2025-02-25 20:12:18
20211202204204	2025-02-25 20:12:18
20211202204605	2025-02-25 20:12:18
20211210212804	2025-02-25 20:12:19
20211228014915	2025-02-25 20:12:19
20220107221237	2025-02-25 20:12:19
20220228202821	2025-02-25 20:12:19
20220312004840	2025-02-25 20:12:19
20220603231003	2025-02-25 20:12:19
20220603232444	2025-02-25 20:12:19
20220615214548	2025-02-25 20:12:19
20220712093339	2025-02-25 20:12:19
20220908172859	2025-02-25 20:12:19
20220916233421	2025-02-25 20:12:19
20230119133233	2025-02-25 20:12:19
20230128025114	2025-02-25 20:12:19
20230128025212	2025-02-25 20:12:19
20230227211149	2025-02-25 20:12:19
20230228184745	2025-02-25 20:12:19
20230308225145	2025-02-25 20:12:19
20230328144023	2025-02-25 20:12:19
20231018144023	2025-02-25 20:12:19
20231204144023	2025-02-25 20:12:19
20231204144024	2025-02-25 20:12:19
20231204144025	2025-02-25 20:12:19
20240108234812	2025-02-25 20:12:19
20240109165339	2025-02-25 20:12:19
20240227174441	2025-02-25 20:12:19
20240311171622	2025-02-25 20:12:19
20240321100241	2025-02-25 20:12:19
20240401105812	2025-02-25 20:12:19
20240418121054	2025-02-25 20:12:19
20240523004032	2025-02-25 20:12:19
20240618124746	2025-02-25 20:12:19
20240801235015	2025-02-25 20:12:19
20240805133720	2025-02-25 20:12:19
20240827160934	2025-02-25 20:12:19
20240919163303	2025-02-25 20:12:19
20240919163305	2025-02-25 20:12:19
20241019105805	2025-02-25 20:12:19
20241030150047	2025-02-25 20:12:19
20241108114728	2025-02-25 20:12:19
20241121104152	2025-02-25 20:12:19
20241130184212	2025-02-25 20:12:19
20241220035512	2025-02-25 20:12:19
20241220123912	2025-02-25 20:12:19
20241224161212	2025-02-25 20:12:19
20250107150512	2025-02-25 20:12:19
20250110162412	2025-02-25 20:12:19
20250123174212	2025-02-25 20:12:19
20250128220012	2025-02-25 20:12:19
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
avatars	avatars	\N	2025-02-25 21:43:03.294511+00	2025-02-25 21:43:03.294511+00	f	f	\N	\N	\N
challenge-covers	challenge-covers	\N	2025-02-27 22:09:03.654267+00	2025-02-27 22:09:03.654267+00	t	f	\N	\N	\N
media	media	\N	2025-02-28 01:57:00.963846+00	2025-02-28 01:57:00.963846+00	t	f	\N	\N	\N
task-media	task-media	\N	2025-03-04 03:54:18.783347+00	2025-03-04 03:54:18.783347+00	f	f	\N	\N	\N
profile_photos	Profile Photos	\N	2025-02-27 02:50:57.930731+00	2025-02-27 02:50:57.930731+00	t	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-02-25 20:10:38.054229
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-02-25 20:10:38.082941
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-02-25 20:10:38.096984
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-02-25 20:10:38.141898
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-02-25 20:10:38.195386
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-02-25 20:10:38.213945
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-02-25 20:10:38.234392
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-02-25 20:10:38.252229
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-02-25 20:10:38.26625
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-02-25 20:10:38.293047
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-02-25 20:10:38.30739
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-02-25 20:10:38.321552
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-02-25 20:10:38.340232
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-02-25 20:10:38.357068
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-02-25 20:10:38.375327
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-02-25 20:10:38.427176
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-02-25 20:10:38.446699
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-02-25 20:10:38.478833
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-02-25 20:10:38.516355
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-02-25 20:10:38.563991
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-02-25 20:10:38.577097
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-02-25 20:10:38.639083
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-02-25 20:10:38.689873
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-02-25 20:10:38.742585
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-02-25 20:10:38.774928
25	custom-metadata	67eb93b7e8d401cafcdc97f9ac779e71a79bfe03	2025-02-25 20:10:38.795766
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
393d8573-c8a4-4c11-8517-fbecd7389f67	challenge-covers	1740694218395-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:10:18.96376+00	2025-02-27 22:10:18.96376+00	2025-02-27 22:10:18.96376+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:10:19.000Z", "contentLength": 89291, "httpStatusCode": 200}	d75d5d7e-ed50-4d16-b425-3f6fdb0ab4ee	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
2f0f777c-1cc4-44b1-b944-4ce3c771eeae	challenge-covers	1740694235272-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:10:35.793112+00	2025-02-27 22:10:35.793112+00	2025-02-27 22:10:35.793112+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:10:36.000Z", "contentLength": 89291, "httpStatusCode": 200}	9fe677ac-bba8-40f2-bcdb-0e3c9622a587	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
e132678a-0022-48d5-b1b0-07ce2f7a0ca9	challenge-covers	1740694313077-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:11:53.618753+00	2025-02-27 22:11:53.618753+00	2025-02-27 22:11:53.618753+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:11:54.000Z", "contentLength": 89291, "httpStatusCode": 200}	a6fd403d-8b22-444d-b99a-7fd94fe61483	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
a65f10c7-355c-4629-97ca-4a9a7d7bd9f4	challenge-covers	1740694465281-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:14:25.774867+00	2025-02-27 22:14:25.774867+00	2025-02-27 22:14:25.774867+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:14:26.000Z", "contentLength": 89291, "httpStatusCode": 200}	244c29c3-781a-4158-8c9d-112a75cd9cc8	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
a8aba1eb-9ede-4d86-8ab7-f5784440479d	challenge-covers	1740694523059-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:15:23.507386+00	2025-02-27 22:15:23.507386+00	2025-02-27 22:15:23.507386+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:15:24.000Z", "contentLength": 89291, "httpStatusCode": 200}	ca41ac5a-0f8c-497b-8311-0a612b54795b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
db6ee64f-da2d-480e-99ba-456b662ae9db	media	1740713774997-80.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:36:15.371714+00	2025-02-28 03:36:15.371714+00	2025-02-28 03:36:15.371714+00	{"eTag": "\\"a6530c8556f34cc1bf5379f0162cbbe3\\"", "size": 4631, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:36:16.000Z", "contentLength": 4631, "httpStatusCode": 200}	4d7e2d10-0e1b-43da-ab9e-fc4646e8a81b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
fe9a86a7-5250-4688-9401-7ae3c68d7232	media	1740713794428-80.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:36:34.851872+00	2025-02-28 03:36:34.851872+00	2025-02-28 03:36:34.851872+00	{"eTag": "\\"a6530c8556f34cc1bf5379f0162cbbe3\\"", "size": 4631, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:36:35.000Z", "contentLength": 4631, "httpStatusCode": 200}	bb50cd1c-b6b7-43e1-b1db-53255609023d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
77ab75b6-f240-44e7-ae71-d4c352af6fe8	media	1740713958093-80.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:39:18.543491+00	2025-02-28 03:39:18.543491+00	2025-02-28 03:39:18.543491+00	{"eTag": "\\"a6530c8556f34cc1bf5379f0162cbbe3\\"", "size": 4631, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:39:19.000Z", "contentLength": 4631, "httpStatusCode": 200}	f37a6b2a-f504-4322-b066-bd6bdcac7c10	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
f0d91019-50db-4cf0-b9b9-ccfdefcfdb5a	media	1740714264434-50.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:44:24.79903+00	2025-02-28 03:44:24.79903+00	2025-02-28 03:44:24.79903+00	{"eTag": "\\"184560facbe584e4203f2b16bb886fc5\\"", "size": 2802, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:44:25.000Z", "contentLength": 2802, "httpStatusCode": 200}	29d80b06-0302-4dd4-8bde-0a26c1b7fc72	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
c4467593-c9c1-4cc0-b94e-a04729843155	challenge-covers	1741052639691-Asset 1@4x.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:44:00.711768+00	2025-03-04 01:44:00.711768+00	2025-03-04 01:44:00.711768+00	{"eTag": "\\"e57f0da11b43e55357379699325331d5\\"", "size": 23735, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T01:44:01.000Z", "contentLength": 23735, "httpStatusCode": 200}	82ea793d-59bd-439f-95d1-d6c3932f54c4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
c160881e-d1cd-4eb8-939e-b126ec988c0d	profile_photos	4174dc1e-6d0b-4e69-a716-1654abf40f1e.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:36:09.799105+00	2025-03-04 04:58:16.770208+00	2025-03-04 01:36:09.799105+00	{"eTag": "\\"1e23725c7fb8af3763ceac847ebd894b\\"", "size": 475130, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T04:58:17.000Z", "contentLength": 475130, "httpStatusCode": 200}	60856002-c46f-45bf-9806-191db4756d7e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
e34741b2-5256-404c-90c1-38584de4bbb8	challenge-covers	1741052977711-bible.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:49:38.289394+00	2025-03-04 01:49:38.289394+00	2025-03-04 01:49:38.289394+00	{"eTag": "\\"ee07dca91a60d2880923444f4a8b2578\\"", "size": 33672, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T01:49:39.000Z", "contentLength": 33672, "httpStatusCode": 200}	fe283010-2896-46b3-92e4-0d92f3368a23	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
3191fb77-f225-4202-bf55-3f18e4a609c4	media	1741061171598-Home Page Background vid.mp4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 04:06:14.643858+00	2025-03-04 04:06:14.643858+00	2025-03-04 04:06:14.643858+00	{"eTag": "\\"7dd9151e676d3f374cddd0c9aedc790a-2\\"", "size": 8004285, "mimetype": "video/mp4", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T04:06:14.000Z", "contentLength": 8004285, "httpStatusCode": 200}	e88b8bb1-d597-4ec0-80ff-ec420c557b84	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
2aa981fa-e1cf-4f20-8a58-a32a81e1ec31	profile_photos	4174dc1e-6d0b-4e69-a716-1654abf40f1e.webp	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 06:25:49.19016+00	2025-03-04 06:25:49.19016+00	2025-03-04 06:25:49.19016+00	{"eTag": "\\"23e8478b1bbc8f441b80821fccb7b977\\"", "size": 79076, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T06:25:50.000Z", "contentLength": 79076, "httpStatusCode": 200}	0e031ec7-e2df-4592-934d-8cd39b8dc555	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
39dd6aaa-c80a-4b0d-9295-88fb7da71334	media	1741070223958-bl0b coin 2.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 06:37:04.37285+00	2025-03-04 06:37:04.37285+00	2025-03-04 06:37:04.37285+00	{"eTag": "\\"a966f7a5dd7759286f7948937875a47c\\"", "size": 61749, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T06:37:05.000Z", "contentLength": 61749, "httpStatusCode": 200}	d71f752e-deb6-4815-abc2-a8a63dbe8e89	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
1061cbfa-d6f9-4d2e-bcf0-c38a86a0036c	profile_photos	8935db97-9a3d-4058-9589-6e0f9b01ee84.png	8935db97-9a3d-4058-9589-6e0f9b01ee84	2025-03-04 15:55:55.157114+00	2025-03-04 15:55:55.157114+00	2025-03-04 15:55:55.157114+00	{"eTag": "\\"437449304cae8f97bda2924737258220\\"", "size": 108416, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T15:55:56.000Z", "contentLength": 108416, "httpStatusCode": 200}	1dc8a4e6-e8f3-479c-a098-218fab3ebd56	8935db97-9a3d-4058-9589-6e0f9b01ee84	{}
04d97e48-97e9-4a1b-9e14-bca1312e3918	challenge-covers	1741105272110-bible.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 16:21:12.557357+00	2025-03-04 16:21:12.557357+00	2025-03-04 16:21:12.557357+00	{"eTag": "\\"ee07dca91a60d2880923444f4a8b2578\\"", "size": 33672, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T16:21:13.000Z", "contentLength": 33672, "httpStatusCode": 200}	bc753c08-7220-49fd-9f31-75be534393e2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
c94cc5ba-e5c4-4a9b-a47d-3221a76bf300	profile_photos	fd667865-de1e-4f75-9701-db02d60d2b6e.jpg	fd667865-de1e-4f75-9701-db02d60d2b6e	2025-04-11 01:32:57.967468+00	2025-04-11 01:32:57.967468+00	2025-04-11 01:32:57.967468+00	{"eTag": "\\"1e23725c7fb8af3763ceac847ebd894b\\"", "size": 475130, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-04-11T01:32:58.000Z", "contentLength": 475130, "httpStatusCode": 200}	a7f1c9ae-da08-4e25-b156-e6f2e56f4d67	fd667865-de1e-4f75-9701-db02d60d2b6e	{}
802e37f8-6e70-4d15-a2e3-5a3700f2150a	profile_photos	fd667865-de1e-4f75-9701-db02d60d2b6e.jpeg	fd667865-de1e-4f75-9701-db02d60d2b6e	2025-04-11 02:44:32.887415+00	2025-04-11 02:44:32.887415+00	2025-04-11 02:44:32.887415+00	{"eTag": "\\"77b8435396fef402f56927af99096304\\"", "size": 11349, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-04-11T02:44:33.000Z", "contentLength": 11349, "httpStatusCode": 200}	54c7075b-7f8a-400c-baab-715c9d2b448e	fd667865-de1e-4f75-9701-db02d60d2b6e	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 129, true);


--
-- Name: jobid_seq; Type: SEQUENCE SET; Schema: cron; Owner: supabase_admin
--

SELECT pg_catalog.setval('cron.jobid_seq', 2, true);


--
-- Name: runid_seq; Type: SEQUENCE SET; Schema: cron; Owner: supabase_admin
--

SELECT pg_catalog.setval('cron.runid_seq', 1, false);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: challenge_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.challenge_types_id_seq', 2, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: blocks blocks_blocker_id_blocked_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_blocker_id_blocked_id_key UNIQUE (blocker_id, blocked_id);


--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: bookmarks bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY (user_id, content_type, content_id);


--
-- Name: challenge_lobbies challenge_lobbies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_lobbies
    ADD CONSTRAINT challenge_lobbies_pkey PRIMARY KEY (id);


--
-- Name: challenge_participants challenge_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_participants
    ADD CONSTRAINT challenge_participants_pkey PRIMARY KEY (id);


--
-- Name: challenge_types challenge_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_types
    ADD CONSTRAINT challenge_types_name_key UNIQUE (name);


--
-- Name: challenge_types challenge_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_types
    ADD CONSTRAINT challenge_types_pkey PRIMARY KEY (id);


--
-- Name: challenges challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: users email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT email_unique UNIQUE (email);


--
-- Name: follows follows_follower_id_following_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_follower_id_following_id_key UNIQUE (follower_id, following_id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: friends friends_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_pkey PRIMARY KEY (id);


--
-- Name: friends friends_user_id_friend_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_user_id_friend_id_key UNIQUE (user_id, friend_id);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_user_id_friend_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_user_id_friend_id_key UNIQUE (user_id, friend_id);


--
-- Name: group_members group_members_group_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_user_id_key UNIQUE (group_id, user_id);


--
-- Name: group_members group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (id);


--
-- Name: message_threads message_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_threads
    ADD CONSTRAINT message_threads_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: news_feed news_feed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news_feed
    ADD CONSTRAINT news_feed_pkey PRIMARY KEY (id);


--
-- Name: post_reactions post_reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reactions
    ADD CONSTRAINT post_reactions_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: private_groups private_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_groups
    ADD CONSTRAINT private_groups_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);


--
-- Name: social_channels social_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_channels
    ADD CONSTRAINT social_channels_pkey PRIMARY KEY (id);


--
-- Name: stories stories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: story_views story_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.story_views
    ADD CONSTRAINT story_views_pkey PRIMARY KEY (id);


--
-- Name: story_views story_views_user_id_story_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.story_views
    ADD CONSTRAINT story_views_user_id_story_id_key UNIQUE (user_id, story_id);


--
-- Name: task_completions task_completions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: thread_participants thread_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thread_participants
    ADD CONSTRAINT thread_participants_pkey PRIMARY KEY (thread_id, user_id);


--
-- Name: posts unique_post; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT unique_post UNIQUE (user_id, challenge_id, content, parent_id, created_at);


--
-- Name: post_reactions unique_user_post_reaction; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reactions
    ADD CONSTRAINT unique_user_post_reaction UNIQUE (user_id, post_id, reaction_type);


--
-- Name: user_challenge_logs user_challenge_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_challenge_logs
    ADD CONSTRAINT user_challenge_logs_pkey PRIMARY KEY (id);


--
-- Name: user_challenges user_challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_challenges
    ADD CONSTRAINT user_challenges_pkey PRIMARY KEY (id);


--
-- Name: user_challenges user_challenges_user_id_challenge_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_challenges
    ADD CONSTRAINT user_challenges_user_id_challenge_id_key UNIQUE (user_id, challenge_id);


--
-- Name: user_relationships user_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_relationships
    ADD CONSTRAINT user_relationships_pkey PRIMARY KEY (follower_id, following_id);


--
-- Name: users username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT username_unique UNIQUE (username);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: whispers whispers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whispers
    ADD CONSTRAINT whispers_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_13 messages_2025_04_13_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_13
    ADD CONSTRAINT messages_2025_04_13_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_14 messages_2025_04_14_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_14
    ADD CONSTRAINT messages_2025_04_14_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_15 messages_2025_04_15_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_15
    ADD CONSTRAINT messages_2025_04_15_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_16 messages_2025_04_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_16
    ADD CONSTRAINT messages_2025_04_16_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_17 messages_2025_04_17_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_17
    ADD CONSTRAINT messages_2025_04_17_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_18 messages_2025_04_18_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_18
    ADD CONSTRAINT messages_2025_04_18_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_19 messages_2025_04_19_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_19
    ADD CONSTRAINT messages_2025_04_19_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_20 messages_2025_04_20_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_20
    ADD CONSTRAINT messages_2025_04_20_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_04_21 messages_2025_04_21_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_04_21
    ADD CONSTRAINT messages_2025_04_21_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_challenge_participants_challenge_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_challenge_participants_challenge_id ON public.challenge_participants USING btree (challenge_id);


--
-- Name: posts_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_parent_id_idx ON public.posts USING btree (parent_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: messages_2025_04_13_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_13_pkey;


--
-- Name: messages_2025_04_14_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_14_pkey;


--
-- Name: messages_2025_04_15_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_15_pkey;


--
-- Name: messages_2025_04_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_16_pkey;


--
-- Name: messages_2025_04_17_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_17_pkey;


--
-- Name: messages_2025_04_18_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_18_pkey;


--
-- Name: messages_2025_04_19_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_19_pkey;


--
-- Name: messages_2025_04_20_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_20_pkey;


--
-- Name: messages_2025_04_21_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_04_21_pkey;


--
-- Name: challenges challenge_edited_notify; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER challenge_edited_notify AFTER UPDATE ON public.challenges FOR EACH ROW WHEN (((old.title IS DISTINCT FROM new.title) OR (old.end_datetime IS DISTINCT FROM new.end_datetime))) EXECUTE FUNCTION public.notify_challenge_edit();


--
-- Name: challenge_participants ranking_update_notify; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ranking_update_notify AFTER UPDATE OF score ON public.challenge_participants FOR EACH ROW WHEN ((old.score IS DISTINCT FROM new.score)) EXECUTE FUNCTION public.notify_ranking_update();


--
-- Name: tasks task_added_notify; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER task_added_notify AFTER INSERT ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.notify_task_update();


--
-- Name: task_completions task_completion_notify; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER task_completion_notify AFTER INSERT ON public.task_completions FOR EACH ROW EXECUTE FUNCTION public.notify_task_completion();


--
-- Name: tasks task_edited_notify; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER task_edited_notify AFTER UPDATE ON public.tasks FOR EACH ROW WHEN (((old.action IS DISTINCT FROM new.action) OR (old.verification_type IS DISTINCT FROM new.verification_type))) EXECUTE FUNCTION public.notify_task_edit();


--
-- Name: tasks trigger_auto_post_task; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_auto_post_task AFTER UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.auto_post_task_completion();


--
-- Name: challenge_participants user_joined_notify; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER user_joined_notify AFTER INSERT ON public.challenge_participants FOR EACH ROW EXECUTE FUNCTION public.notify_user_joined();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: blocks blocks_blocked_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_blocked_id_fkey FOREIGN KEY (blocked_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: blocks blocks_blocker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_blocker_id_fkey FOREIGN KEY (blocker_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: bookmarks bookmarks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: challenge_lobbies challenge_lobbies_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_lobbies
    ADD CONSTRAINT challenge_lobbies_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.challenges(id) ON DELETE CASCADE;


--
-- Name: challenge_participants challenge_participants_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_participants
    ADD CONSTRAINT challenge_participants_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: challenge_participants challenge_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_participants
    ADD CONSTRAINT challenge_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: challenges challenges_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT challenges_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: challenges challenges_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT challenges_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.profiles(id);


--
-- Name: comments comments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.comments(id) ON DELETE SET NULL;


--
-- Name: comments comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: comments fk_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_post_id FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: posts fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- Name: posts fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: comments fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: challenge_participants fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_participants
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: follows follows_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: follows follows_following_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_following_id_fkey FOREIGN KEY (following_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: friends friends_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: friends friends_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: friendships friendships_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: friendships friendships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: group_members group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.private_groups(id) ON DELETE CASCADE;


--
-- Name: group_members group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_thread_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.message_threads(id);


--
-- Name: messages messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: post_reactions post_reactions_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reactions
    ADD CONSTRAINT post_reactions_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: post_reactions post_reactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reactions
    ADD CONSTRAINT post_reactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- Name: posts posts_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: posts posts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.posts(id);


--
-- Name: posts posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id);


--
-- Name: stories stories_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stories
    ADD CONSTRAINT stories_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: story_views story_views_story_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.story_views
    ADD CONSTRAINT story_views_story_id_fkey FOREIGN KEY (story_id) REFERENCES public.stories(id);


--
-- Name: story_views story_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.story_views
    ADD CONSTRAINT story_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: task_completions task_completions_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: task_completions task_completions_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: task_completions task_completions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- Name: tasks tasks_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.challenges(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- Name: thread_participants thread_participants_thread_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thread_participants
    ADD CONSTRAINT thread_participants_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.message_threads(id);


--
-- Name: thread_participants thread_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thread_participants
    ADD CONSTRAINT thread_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: user_challenge_logs user_challenge_logs_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_challenge_logs
    ADD CONSTRAINT user_challenge_logs_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: user_challenge_logs user_challenge_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_challenge_logs
    ADD CONSTRAINT user_challenge_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: user_challenges user_challenges_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_challenges
    ADD CONSTRAINT user_challenges_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.challenges(id) ON DELETE CASCADE;


--
-- Name: user_challenges user_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_challenges
    ADD CONSTRAINT user_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_relationships user_relationships_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_relationships
    ADD CONSTRAINT user_relationships_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES auth.users(id);


--
-- Name: user_relationships user_relationships_following_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_relationships
    ADD CONSTRAINT user_relationships_following_id_fkey FOREIGN KEY (following_id) REFERENCES auth.users(id);


--
-- Name: whispers whispers_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whispers
    ADD CONSTRAINT whispers_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: whispers whispers_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whispers
    ADD CONSTRAINT whispers_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: comments Allow all authenticated users to read comments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow all authenticated users to read comments" ON public.comments FOR SELECT TO authenticated USING (true);


--
-- Name: posts Allow all authenticated users to read posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow all authenticated users to read posts" ON public.posts FOR SELECT TO authenticated USING (true);


--
-- Name: comments Allow authenticated users to comment; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to comment" ON public.comments FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: posts Allow authenticated users to create posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to create posts" ON public.posts FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: comments Allow authenticated users to insert comments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to insert comments" ON public.comments FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: posts Allow authenticated users to insert posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to insert posts" ON public.posts FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: profiles Allow authenticated users to insert their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to insert their own profile" ON public.profiles FOR INSERT TO authenticated WITH CHECK ((auth.uid() = id));


--
-- Name: users Allow authenticated users to insert their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to insert their own profile" ON public.users FOR INSERT TO authenticated WITH CHECK ((auth.uid() = id));


--
-- Name: friendships Allow authenticated users to manage their friendships; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to manage their friendships" ON public.friendships TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: comments Allow authenticated users to read comments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read comments" ON public.comments FOR SELECT TO authenticated USING (true);


--
-- Name: tasks Allow authenticated users to read tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read tasks" ON public.tasks FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: friendships Allow authenticated users to read their friendships; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read their friendships" ON public.friendships FOR SELECT TO authenticated USING (((auth.uid() = user_id) OR (auth.uid() = friend_id)));


--
-- Name: profiles Allow authenticated users to read their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read their own profile" ON public.profiles FOR SELECT TO authenticated USING ((auth.uid() = id));


--
-- Name: profiles Allow authenticated users to update their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to update their own profile" ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- Name: tasks Allow challenge creators to manage tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow challenge creators to manage tasks" ON public.tasks USING ((EXISTS ( SELECT 1
   FROM public.challenges
  WHERE ((challenges.id = tasks.challenge_id) AND (challenges.creator_id = auth.uid())))));


--
-- Name: private_groups Allow group member reads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow group member reads" ON public.private_groups FOR SELECT TO authenticated USING ((auth.uid() IN ( SELECT group_members.user_id
   FROM public.group_members
  WHERE (group_members.group_id = private_groups.id))));


--
-- Name: challenge_lobbies Allow lobby member reads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow lobby member reads" ON public.challenge_lobbies FOR SELECT TO authenticated USING ((challenge_id IN ( SELECT user_challenges.challenge_id
   FROM public.user_challenges
  WHERE (user_challenges.user_id = auth.uid()))));


--
-- Name: challenges Allow public challenge reads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public challenge reads" ON public.challenges FOR SELECT TO authenticated USING ((is_public = true));


--
-- Name: social_channels Allow public channel reads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public channel reads" ON public.social_channels FOR SELECT TO authenticated USING ((is_public = true));


--
-- Name: profiles Allow public read of public fields; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public read of public fields" ON public.profiles FOR SELECT TO authenticated, anon USING ((first_name_public OR last_name_public OR username_public OR phone_number_public OR address_public OR participates_in_challenges_public OR gender_public OR dob_public OR height_public OR weight_public OR body_fat_percentage_public OR profile_photo_url_public OR bmi_public OR bmr_public OR (id = auth.uid())));


--
-- Name: posts Allow unauthenticated users to read all posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow unauthenticated users to read all posts" ON public.posts FOR SELECT TO anon USING (true);


--
-- Name: users Allow user insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow user insert" ON public.users FOR INSERT TO authenticated WITH CHECK ((auth.uid() = id));


--
-- Name: users Allow username lookup for login; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow username lookup for login" ON public.users FOR SELECT TO anon USING ((username IS NOT NULL));


--
-- Name: blocks Allow users to manage own blocks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to manage own blocks" ON public.blocks TO authenticated USING ((blocker_id = auth.uid()));


--
-- Name: follows Allow users to manage own follows; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to manage own follows" ON public.follows TO authenticated USING ((follower_id = auth.uid()));


--
-- Name: friends Allow users to manage own friends; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to manage own friends" ON public.friends TO authenticated USING ((user_id = auth.uid()));


--
-- Name: users Allow users to read their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to read their own profile" ON public.users FOR SELECT TO authenticated USING ((auth.uid() = id));


--
-- Name: profiles Allow users to update own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to update own profile" ON public.profiles FOR UPDATE TO authenticated USING ((id = auth.uid()));


--
-- Name: users Allow users to update their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to update their own profile" ON public.users FOR UPDATE TO authenticated USING ((auth.uid() = id)) WITH CHECK ((auth.uid() = id));


--
-- Name: challenges Authenticated users can create challenges; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can create challenges" ON public.challenges FOR INSERT TO authenticated WITH CHECK ((auth.uid() = created_by));


--
-- Name: user_challenge_logs Authenticated users can delete their logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete their logs" ON public.user_challenge_logs FOR DELETE USING (((auth.role() = 'authenticated'::text) AND (user_id = auth.uid())));


--
-- Name: user_challenge_logs Authenticated users can log progress; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can log progress" ON public.user_challenge_logs FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: challenges Authenticated users can manage challenges; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can manage challenges" ON public.challenges USING ((auth.role() = 'authenticated'::text));


--
-- Name: user_challenge_logs Authenticated users can update their logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update their logs" ON public.user_challenge_logs FOR UPDATE USING (((auth.role() = 'authenticated'::text) AND (user_id = auth.uid())));


--
-- Name: posts Challenge posts for participants; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Challenge posts for participants" ON public.posts FOR SELECT TO authenticated USING ((challenge_id IN ( SELECT challenge_participants.challenge_id
   FROM public.challenge_participants
  WHERE (challenge_participants.user_id = auth.uid()))));


--
-- Name: posts General posts are public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "General posts are public" ON public.posts FOR SELECT TO authenticated, anon USING ((challenge_id IS NULL));


--
-- Name: challenges Public challenges are readable by everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public challenges are readable by everyone" ON public.challenges FOR SELECT USING ((is_private = false));


--
-- Name: stories Stories are viewable by everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Stories are viewable by everyone" ON public.stories FOR SELECT USING (true);


--
-- Name: story_views Story views are viewable by everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Story views are viewable by everyone" ON public.story_views FOR SELECT USING (true);


--
-- Name: profiles Users can delete their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own profile" ON public.profiles FOR DELETE USING ((auth.uid() = id));


--
-- Name: stories Users can delete their own stories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own stories" ON public.stories FOR DELETE TO authenticated USING ((auth.uid() = user_id));


--
-- Name: profiles Users can insert their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile" ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = id));


--
-- Name: stories Users can insert their own stories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own stories" ON public.stories FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: story_views Users can insert their own story views; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own story views" ON public.story_views FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: profiles Users can insert their profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their profile" ON public.profiles FOR INSERT TO authenticated WITH CHECK ((id = auth.uid()));


--
-- Name: profiles Users can insert their profile with unique username; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their profile with unique username" ON public.profiles FOR INSERT TO authenticated WITH CHECK (((id = auth.uid()) AND (NOT (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.username = profiles.username) AND (p.id <> auth.uid())))))));


--
-- Name: whispers Users can read their own whispers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read their own whispers" ON public.whispers FOR SELECT TO authenticated USING ((recipient_id = auth.uid()));


--
-- Name: whispers Users can send whispers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can send whispers" ON public.whispers FOR INSERT TO authenticated WITH CHECK ((sender_id = auth.uid()));


--
-- Name: profiles Users can update their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- Name: stories Users can update their own stories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own stories" ON public.stories FOR UPDATE TO authenticated USING ((auth.uid() = user_id));


--
-- Name: whispers Users can update their own whispers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own whispers" ON public.whispers FOR UPDATE TO authenticated USING ((recipient_id = auth.uid()));


--
-- Name: profiles Users can update their profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their profile" ON public.profiles FOR UPDATE TO authenticated USING ((id = auth.uid())) WITH CHECK ((id = auth.uid()));


--
-- Name: profiles Users can update their profile with unique username; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their profile with unique username" ON public.profiles FOR UPDATE TO authenticated USING ((id = auth.uid())) WITH CHECK (((id = auth.uid()) AND (NOT (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.username = profiles.username) AND (p.id <> auth.uid())))))));


--
-- Name: profiles Users can view profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view profiles" ON public.profiles FOR SELECT TO authenticated USING (true);


--
-- Name: profiles Users can view their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own profile" ON public.profiles FOR SELECT USING ((auth.uid() = id));


--
-- Name: challenges View public challenges or private if participant; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "View public challenges or private if participant" ON public.challenges FOR SELECT TO authenticated USING ((is_public OR (EXISTS ( SELECT 1
   FROM public.user_challenges
  WHERE ((user_challenges.challenge_id = challenges.id) AND (user_challenges.user_id = auth.uid()))))));


--
-- Name: blocks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.blocks ENABLE ROW LEVEL SECURITY;

--
-- Name: challenge_lobbies; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.challenge_lobbies ENABLE ROW LEVEL SECURITY;

--
-- Name: challenges; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: comments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

--
-- Name: follows; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;

--
-- Name: friends; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.friends ENABLE ROW LEVEL SECURITY;

--
-- Name: friendships; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.friendships ENABLE ROW LEVEL SECURITY;

--
-- Name: group_members; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;

--
-- Name: posts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

--
-- Name: private_groups; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.private_groups ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: social_channels; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.social_channels ENABLE ROW LEVEL SECURITY;

--
-- Name: stories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.stories ENABLE ROW LEVEL SECURITY;

--
-- Name: story_views; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.story_views ENABLE ROW LEVEL SECURITY;

--
-- Name: tasks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: user_challenge_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_challenge_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: user_challenges; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: whispers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.whispers ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Allow authenticated uploads to profile_photos; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated uploads to profile_photos" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'profile_photos'::text) AND (auth.uid() = owner)));


--
-- Name: objects Allow authenticated users to upload 1ps738_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated users to upload 1ps738_0" ON storage.objects FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: objects Allow authenticated users to upload to challenge-covers; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated users to upload to challenge-covers" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'challenge-covers'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: objects Allow public read access to challenge-covers; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow public read access to challenge-covers" ON storage.objects FOR SELECT USING ((bucket_id = 'challenge-covers'::text));


--
-- Name: objects Allow public read access to media 1ps738_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow public read access to media 1ps738_0" ON storage.objects FOR SELECT USING (true);


--
-- Name: objects Allow public reads from profile_photos; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow public reads from profile_photos" ON storage.objects FOR SELECT USING ((bucket_id = 'profile_photos'::text));


--
-- Name: objects Authenticated users can read media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated users can read media" ON storage.objects FOR SELECT TO authenticated USING (((bucket_id = 'media'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: objects Authenticated users can read task-media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated users can read task-media" ON storage.objects FOR SELECT TO authenticated USING (((bucket_id = 'task-media'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: objects Authenticated users can upload to media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated users can upload to media" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'media'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: objects Authenticated users can upload to task-media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated users can upload to task-media" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'task-media'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: objects Users can upload their own profile photo; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Users can upload their own profile photo" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'profile_photos'::text) AND (owner = auth.uid())));


--
-- Name: objects Users can view their own profile photo; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Users can view their own profile photo" ON storage.objects FOR SELECT USING (((bucket_id = 'profile_photos'::text) AND (owner = auth.uid())));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: objects simple_test; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY simple_test ON storage.objects FOR SELECT USING (true);


--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA cron; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA cron TO postgres WITH GRANT OPTION;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;
GRANT ALL ON FUNCTION auth.email() TO postgres;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;
GRANT ALL ON FUNCTION auth.role() TO postgres;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;
GRANT ALL ON FUNCTION auth.uid() TO postgres;


--
-- Name: FUNCTION alter_job(job_id bigint, schedule text, command text, database text, username text, active boolean); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.alter_job(job_id bigint, schedule text, command text, database text, username text, active boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION job_cache_invalidate(); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.job_cache_invalidate() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule(schedule text, command text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule(schedule text, command text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule(job_name text, schedule text, command text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule(job_name text, schedule text, command text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule_in_database(job_name text, schedule text, command text, database text, username text, active boolean); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule_in_database(job_name text, schedule text, command text, database text, username text, active boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION unschedule(job_id bigint); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.unschedule(job_id bigint) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION unschedule(job_name text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.unschedule(job_name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION auto_post_task_completion(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.auto_post_task_completion() TO anon;
GRANT ALL ON FUNCTION public.auto_post_task_completion() TO authenticated;
GRANT ALL ON FUNCTION public.auto_post_task_completion() TO service_role;


--
-- Name: FUNCTION cleanup_expired_stories(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cleanup_expired_stories() TO anon;
GRANT ALL ON FUNCTION public.cleanup_expired_stories() TO authenticated;
GRANT ALL ON FUNCTION public.cleanup_expired_stories() TO service_role;


--
-- Name: FUNCTION increment_usage_count(type_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.increment_usage_count(type_id integer) TO anon;
GRANT ALL ON FUNCTION public.increment_usage_count(type_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.increment_usage_count(type_id integer) TO service_role;


--
-- Name: FUNCTION insert_automated_post(p_challenge_id uuid, p_content text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.insert_automated_post(p_challenge_id uuid, p_content text) TO anon;
GRANT ALL ON FUNCTION public.insert_automated_post(p_challenge_id uuid, p_content text) TO authenticated;
GRANT ALL ON FUNCTION public.insert_automated_post(p_challenge_id uuid, p_content text) TO service_role;


--
-- Name: FUNCTION notify_challenge_edit(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_challenge_edit() TO anon;
GRANT ALL ON FUNCTION public.notify_challenge_edit() TO authenticated;
GRANT ALL ON FUNCTION public.notify_challenge_edit() TO service_role;


--
-- Name: FUNCTION notify_challenge_time_remaining(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_challenge_time_remaining() TO anon;
GRANT ALL ON FUNCTION public.notify_challenge_time_remaining() TO authenticated;
GRANT ALL ON FUNCTION public.notify_challenge_time_remaining() TO service_role;


--
-- Name: FUNCTION notify_ranking_update(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_ranking_update() TO anon;
GRANT ALL ON FUNCTION public.notify_ranking_update() TO authenticated;
GRANT ALL ON FUNCTION public.notify_ranking_update() TO service_role;


--
-- Name: FUNCTION notify_task_completion(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_task_completion() TO anon;
GRANT ALL ON FUNCTION public.notify_task_completion() TO authenticated;
GRANT ALL ON FUNCTION public.notify_task_completion() TO service_role;


--
-- Name: FUNCTION notify_task_edit(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_task_edit() TO anon;
GRANT ALL ON FUNCTION public.notify_task_edit() TO authenticated;
GRANT ALL ON FUNCTION public.notify_task_edit() TO service_role;


--
-- Name: FUNCTION notify_task_update(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_task_update() TO anon;
GRANT ALL ON FUNCTION public.notify_task_update() TO authenticated;
GRANT ALL ON FUNCTION public.notify_task_update() TO service_role;


--
-- Name: FUNCTION notify_user_joined(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_user_joined() TO anon;
GRANT ALL ON FUNCTION public.notify_user_joined() TO authenticated;
GRANT ALL ON FUNCTION public.notify_user_joined() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION can_insert_object(bucketid text, name text, owner uuid, metadata jsonb); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) TO postgres;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: FUNCTION get_size_by_bucket(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.get_size_by_bucket() TO postgres;


--
-- Name: FUNCTION list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) TO postgres;


--
-- Name: FUNCTION list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) TO postgres;


--
-- Name: FUNCTION operation(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.operation() TO postgres;


--
-- Name: FUNCTION search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) TO postgres;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.update_updated_at_column() TO postgres;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.schema_migrations TO postgres;
GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE job; Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT SELECT ON TABLE cron.job TO postgres WITH GRANT OPTION;


--
-- Name: TABLE job_run_details; Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON TABLE cron.job_run_details TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE blocks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.blocks TO anon;
GRANT ALL ON TABLE public.blocks TO authenticated;
GRANT ALL ON TABLE public.blocks TO service_role;


--
-- Name: TABLE bookmarks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bookmarks TO anon;
GRANT ALL ON TABLE public.bookmarks TO authenticated;
GRANT ALL ON TABLE public.bookmarks TO service_role;


--
-- Name: TABLE challenge_lobbies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.challenge_lobbies TO anon;
GRANT ALL ON TABLE public.challenge_lobbies TO authenticated;
GRANT ALL ON TABLE public.challenge_lobbies TO service_role;


--
-- Name: TABLE challenge_participants; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.challenge_participants TO anon;
GRANT ALL ON TABLE public.challenge_participants TO authenticated;
GRANT ALL ON TABLE public.challenge_participants TO service_role;


--
-- Name: TABLE challenge_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.challenge_types TO anon;
GRANT ALL ON TABLE public.challenge_types TO authenticated;
GRANT ALL ON TABLE public.challenge_types TO service_role;


--
-- Name: SEQUENCE challenge_types_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.challenge_types_id_seq TO anon;
GRANT ALL ON SEQUENCE public.challenge_types_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.challenge_types_id_seq TO service_role;


--
-- Name: TABLE challenges; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.challenges TO anon;
GRANT ALL ON TABLE public.challenges TO authenticated;
GRANT ALL ON TABLE public.challenges TO service_role;


--
-- Name: TABLE comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comments TO anon;
GRANT ALL ON TABLE public.comments TO authenticated;
GRANT ALL ON TABLE public.comments TO service_role;


--
-- Name: TABLE follows; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.follows TO anon;
GRANT ALL ON TABLE public.follows TO authenticated;
GRANT ALL ON TABLE public.follows TO service_role;


--
-- Name: TABLE friends; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.friends TO anon;
GRANT ALL ON TABLE public.friends TO authenticated;
GRANT ALL ON TABLE public.friends TO service_role;


--
-- Name: TABLE friendships; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.friendships TO anon;
GRANT ALL ON TABLE public.friendships TO authenticated;
GRANT ALL ON TABLE public.friendships TO service_role;


--
-- Name: TABLE group_members; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.group_members TO anon;
GRANT ALL ON TABLE public.group_members TO authenticated;
GRANT ALL ON TABLE public.group_members TO service_role;


--
-- Name: TABLE message_threads; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.message_threads TO anon;
GRANT ALL ON TABLE public.message_threads TO authenticated;
GRANT ALL ON TABLE public.message_threads TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE news_feed; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.news_feed TO anon;
GRANT ALL ON TABLE public.news_feed TO authenticated;
GRANT ALL ON TABLE public.news_feed TO service_role;


--
-- Name: TABLE post_reactions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.post_reactions TO anon;
GRANT ALL ON TABLE public.post_reactions TO authenticated;
GRANT ALL ON TABLE public.post_reactions TO service_role;


--
-- Name: TABLE posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.posts TO anon;
GRANT ALL ON TABLE public.posts TO authenticated;
GRANT ALL ON TABLE public.posts TO service_role;


--
-- Name: TABLE private_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.private_groups TO anon;
GRANT ALL ON TABLE public.private_groups TO authenticated;
GRANT ALL ON TABLE public.private_groups TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE social_channels; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.social_channels TO anon;
GRANT ALL ON TABLE public.social_channels TO authenticated;
GRANT ALL ON TABLE public.social_channels TO service_role;


--
-- Name: TABLE stories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.stories TO anon;
GRANT ALL ON TABLE public.stories TO authenticated;
GRANT ALL ON TABLE public.stories TO service_role;


--
-- Name: TABLE story_views; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.story_views TO anon;
GRANT ALL ON TABLE public.story_views TO authenticated;
GRANT ALL ON TABLE public.story_views TO service_role;


--
-- Name: TABLE task_completions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.task_completions TO anon;
GRANT ALL ON TABLE public.task_completions TO authenticated;
GRANT ALL ON TABLE public.task_completions TO service_role;


--
-- Name: TABLE tasks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tasks TO anon;
GRANT ALL ON TABLE public.tasks TO authenticated;
GRANT ALL ON TABLE public.tasks TO service_role;


--
-- Name: TABLE thread_participants; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.thread_participants TO anon;
GRANT ALL ON TABLE public.thread_participants TO authenticated;
GRANT ALL ON TABLE public.thread_participants TO service_role;


--
-- Name: TABLE user_challenge_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_challenge_logs TO anon;
GRANT ALL ON TABLE public.user_challenge_logs TO authenticated;
GRANT ALL ON TABLE public.user_challenge_logs TO service_role;


--
-- Name: TABLE user_challenges; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_challenges TO anon;
GRANT ALL ON TABLE public.user_challenges TO authenticated;
GRANT ALL ON TABLE public.user_challenges TO service_role;


--
-- Name: TABLE user_relationships; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_relationships TO anon;
GRANT ALL ON TABLE public.user_relationships TO authenticated;
GRANT ALL ON TABLE public.user_relationships TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE whispers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.whispers TO anon;
GRANT ALL ON TABLE public.whispers TO authenticated;
GRANT ALL ON TABLE public.whispers TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2025_04_13; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_13 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_13 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_14; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_14 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_14 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_15; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_15 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_15 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_16; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_16 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_16 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_17; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_17 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_17 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_18; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_18 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_18 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_19; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_19 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_19 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_20; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_20 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_20 TO dashboard_user;


--
-- Name: TABLE messages_2025_04_21; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_04_21 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_04_21 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;
GRANT ALL ON TABLE storage.s3_multipart_uploads TO postgres;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;
GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO postgres;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,DELETE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON SEQUENCES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON FUNCTIONS  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON TABLES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

