# Scripts
Let's go through the script step by step to understand what it does:

1. **DO block**: The script begins with a `DO` block. This is a PostgreSQL feature that allows you to execute anonymous code blocks.

2. **DECLARE section**: Inside the `DO` block, there is a `DECLARE` section where we declare two variables:
   - `schema_name_var`: This variable will be used to store the names of schemas.
   - `table_name_var`: This variable will be used to store the names of tables within each schema.

3. **FOR loop (Outer)**: The script enters a `FOR` loop that iterates through all schemas in the database. It does this by selecting schema names from the `information_schema.schemata` view.

4. **FOR loop (Inner)**: Inside the outer loop, there is another `FOR` loop that iterates through all user-created tables within the current schema. It excludes system catalog tables and system-related schemas by checking if the table name doesn't start with "pg_" and is not within the "information_schema" schema.

5. **Check for "IsDeleted" column**: For each table in the inner loop, the script checks if the "IsDeleted" column exists by querying the `information_schema.columns` view. It looks for the presence of a column named "IsDeleted" within the current table.

6. **Add "IsDeleted" column**: If the "IsDeleted" column is not found in the current table, the script uses dynamic SQL (`EXECUTE`) to add the column. It alters the table by adding a "IsDeleted" column of type boolean that is not nullable (`NOT NULL`) and has a default value of `false`.

7. **Check for "DeletedDateTime" column**: Similar to the "IsDeleted" column, the script checks if the "DeletedDateTime" column exists within the current table.

8. **Add "DeletedDateTime" column**: If the "DeletedDateTime" column is not found in the current table, the script uses dynamic SQL (`EXECUTE`) to add the column. It alters the table by adding a "DeletedDateTime" column of type `timestamp with time zone`. This column allows storing date and time information and is nullable.

9. **Completion**: After iterating through all schemas and tables, the script execution is completed.

This script effectively adds the "IsDeleted" column with a default value of `false` and the "DeletedDateTime" column (which is nullable) to user-created tables in all schemas while avoiding system catalog tables and system-related schemas. It ensures that these columns are added only if they do not already exist in each table.
