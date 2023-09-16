DO $$ 
DECLARE
    schema_name_var text;
    table_name_var text;
BEGIN
    -- Get a list of all schemas in the database
    FOR schema_name_var IN (SELECT schema_name FROM information_schema.schemata)
    LOOP
        -- Get a list of all user-created tables in the current schema
        FOR table_name_var IN (SELECT table_name
                              FROM information_schema.tables
                              WHERE table_schema = schema_name_var AND table_type = 'BASE TABLE'
                                AND table_name NOT LIKE 'pg_%' AND table_name NOT LIKE 'information_schema.%') 
        LOOP
            -- Check if the "IsDeleted" column exists in the current table
            IF NOT EXISTS (
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = schema_name_var
                AND table_name = table_name_var
                AND column_name = 'IsDeleted'
            ) THEN
                -- Add the "IsDeleted" column with a default value of false if it doesn't exist
                EXECUTE 'ALTER TABLE ' || schema_name_var || '."' || table_name_var || '" ADD COLUMN "IsDeleted" boolean NOT NULL DEFAULT false';
            END IF;
            
            -- Check if the "DeletedDateTime" column exists in the current table
            IF NOT EXISTS (
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = schema_name_var
                AND table_name = table_name_var
                AND column_name = 'DeletedDateTime'
            ) THEN
                -- Add the "DeletedDateTime" column if it doesn't exist
                EXECUTE 'ALTER TABLE ' || schema_name_var || '."' || table_name_var || '" ADD COLUMN "DeletedDateTime" timestamp with time zone';
            END IF;
        END LOOP;
    END LOOP;
END $$;
