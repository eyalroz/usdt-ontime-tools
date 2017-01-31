select concat(tables.name, concat('.', columns.name)) from sys.columns, sys.tables where columns.table_id = tables.id and system = false;
