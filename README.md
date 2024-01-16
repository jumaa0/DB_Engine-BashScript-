# MySQL Bash Script

## Overview

This Bash script provides a simple command-line interface for managing MySQL-like databases. It allows users to create databases, tables, insert, update, delete, and search data. The script operates with a series of interactive prompts, making it user-friendly for basic database management tasks.

## Features

- **CreateDB**: Create a new database.

- **ConnectDB**: Connect to an existing database and perform various operations.

  - **CreateTable**: Create a new table within the connected database.
  
  - **DropTable**: Drop (delete) an existing table from the connected database.
  
  - **ListTables**: List all tables in the connected database.
  
  - **InsertData**: Insert data into a table within the connected database.
  
  - **UpdateData**: Update data in a table within the connected database.
  
  - **SearchData**: Search and display data in a table within the connected database.
  
  - **DeleteData**: Delete data from a table within the connected database.
  
  - **DisconnectDB**: Disconnect from the connected database.

- **ListDB**: List all available databases.

- **DeleteDB**: Delete an existing database.

- **Exit**: Exit the script.

## Usage

1. Run the script by executing `./script.sh` in your terminal.

2. Follow the on-screen prompts to perform various database operations.

## Notes

- Database and table names cannot contain spaces, start with a number, or start with symbols.

- When creating a table, the script prompts you to specify the primary key. Only one primary key is allowed, and it must be specified for the first column.

- When updating data, the script checks for the uniqueness and nullability of the primary key.

- For searching data, you can search based on any column value.

- Deleting data allows you to delete either all data in a table or a specific row based on the primary key.

Feel free to explore and modify the script based on your needs.

