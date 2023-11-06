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
                              WHERE table_schema = schema_name_var
                                AND table_type = 'BASE TABLE'
                                AND table_name NOT LIKE 'pg_%'
                                AND table_name NOT LIKE 'information_schema.%') 
        LOOP
            -- Check if the "Guid" column exists in the current table
            IF NOT EXISTS (
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = schema_name_var
                AND table_name = table_name_var
                AND column_name = 'BusinessAccountId'
            ) THEN
                -- Add the "BusinessAccountId" column with a uuid data type
                EXECUTE 'ALTER TABLE ' || schema_name_var || '."' || table_name_var || '" ADD COLUMN "BusinessAccountId" uuid';
            END IF;

            -- Check if the "CreatedBy" column exists in the current table
            IF NOT EXISTS (
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = schema_name_var
                AND table_name = table_name_var
                AND column_name = 'CreatedBy'
            ) THEN
                -- Add the "CreatedBy" column with a text data type
                EXECUTE 'ALTER TABLE ' || schema_name_var || '."' || table_name_var || '" ADD COLUMN "CreatedBy" text';
            END IF;

            -- Check if the "CreatedDateTime" column exists in the current table
            IF NOT EXISTS (
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = schema_name_var
                AND table_name = table_name_var
                AND column_name = 'CreatedDateTime'
            ) THEN
                -- Add the "CreatedDateTime" column with a timestamp with time zone data type
                EXECUTE 'ALTER TABLE ' || schema_name_var || '."' || table_name_var || '" ADD COLUMN "CreatedDateTime" timestamp with time zone';
            END IF;

            -- Check if the "LastModifiedBy" column exists in the current table
            IF NOT EXISTS (
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = schema_name_var
                AND table_name = table_name_var
                AND column_name = 'LastModifiedBy'
            ) THEN
                -- Add the "LastModifiedBy" column with a text data type
                EXECUTE 'ALTER TABLE ' || schema_name_var || '."' || table_name_var || '" ADD COLUMN "LastModifiedBy" text';
            END IF;

            -- Check if the "LastModifiedDateTime" column exists in the current table
            IF NOT EXISTS (
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = schema_name_var
                AND table_name = table_name_var
                AND column_name = 'LastModifiedDateTime'
            ) THEN
                -- Add the "LastModifiedDateTime" column with a timestamp with time zone data type
                EXECUTE 'ALTER TABLE ' || schema_name_var || '."' || table_name_var || '" ADD COLUMN "LastModifiedDateTime" timestamp with time zone';
            END IF;
        END LOOP;
    END LOOP;
END $$;
