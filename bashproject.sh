#! /usr/bin/bash
if [ -d MySQL ]; then
    echo "welcome to MySQL"
else
    mkdir ./MySQL
fi
echo "Choose option Number: "

select to in CreateDB ConnectDB ListDB DeleteDB Exit
do
case $to in 

"CreateDB")

	while true
	do
	read -p "Enter Database Name: " database

	if [ -d "./MySQL/$database.db" ]; then
		echo "There is a Database with the same name, Enter another name."
		break
	elif [[ "$database" == *" "* || "$database" == "" ]]; then
		echo "Error: Database name cannot contain spaces. Enter another name."
	elif [[ "$database" =~ ^[0-9] ]]; then
		echo "Error: Database name cannot start with a number. Enter another name."
	elif [[ "$database" =~ ^[^a-zA-Z0-9] ]]; then
		echo "Error: Database name cannot start with symbols. Enter another name."
	else
		mkdir -p ./MySQL/$database.db
		echo "Database created successfully."
		break
	fi
	done
;;
"ConnectDB")
	while true
	do 
	read -p "Enter Database Name: " database

	if [ -d "./MySQL/$database.db" ]; then
		cd ./MySQL/"$database.db"
		echo "Connection Successfully"
		
		select option in CreateTable DropTable ListTables InsertData UpdateData SearchData DeleteData DisconnectDB
		do
		case $option in
		"CreateTable")
    read -p "Enter Table Name: " table
    if [[ "$table" == *" "* || "$table" == "" ]]; then
        echo "Error: Table name cannot contain spaces. Enter another name."
    elif [[ "$table" =~ ^[0-9] ]]; then
        echo "Error: Table name cannot start with a number. Enter another name."
    elif [[ "$table" =~ ^[^a-zA-Z0-9] ]]; then
        echo "Error: Table name cannot start with symbols. Enter another name."
    elif [ -f "$table.metadata" ] || [ -f "$table.data" ]; then
        echo "Table already exists."
    else
        touch "$table.metadata"
        touch "$table.data"
        
	while true; do
	read -p "Enter the number of columns: " num_columns
        if [[ "$num_columns" != [0-9] ]]; then
		echo "Enter Integer"
	else
          break
	fi
	done         

        # Loop to get column names, data types, and conditions
	pk_flage=false
	columns_names=""
	columns_types=""
	columns_conditions=""
        for ((i=1; i<=$num_columns; i++)); do
            while true; do
                read -p "Enter name of column $i: " col_name

                # Check if the column name starts with a space, symbol, or number
                if [[ "$col_name" == *" "* || "$col_name" == "" ]]; then
                    echo "Error: Column name cannot contain spaces. Enter another name."
                elif [[ "$col_name" =~ ^[0-9] ]]; then
                    echo "Error: Column name cannot start with a number. Enter another name."
                elif [[ "$col_name" =~ ^[^a-zA-Z0-9] ]]; then
                    echo "Error: Column name cannot start with symbols. Enter another name."
                else
                    break
                fi
            done
		columns_names+=":$col_name"
            while true; do
                read -p "Enter data type of column $i (int or string): " col_type

                # Check if the data type is either "int" or "string"
                if [[ "$col_type" == "int" || "$col_type" == "string" ]]; then
                    break
                else
                    echo "Error: Invalid data type. Please enter 'int' or 'string'."
                fi
            done
		columns_types+=":$col_type"
            # Prompt for condition only if the user wants to specify it
          if [ $i -eq 1 ]; then
    condition="pk"
else
    # Prompt for condition only if the user wants to specify it
    read -p "Do you want to specify a condition for column $col_name? (y/n): " specify_condition

    # Check if the user wants to specify a condition
    if [[ "$specify_condition" == "y" ]]; then
        # Loop until a valid condition is entered
        while true; do
            read -p "Enter Condition [unique, notnull]: " condition

            # Check if the entered condition is one of the specified options
            if [[ "$condition" == "unique" || "$condition" == "notnull" ]]; then
                break
            else
                echo "Error: Invalid condition. Please enter 'unique' or 'notnull'."
            fi
        done
    else
        # If the user doesn't want to specify a condition, set it to an empty string
        condition="null"
    fi
fi

		columns_conditions+=":$condition"
            # Append column information to the table's metadata file
	
            
        done
	columns_names=${columns_names#:}   
	columns_types=${columns_types#:}
	columns_conditions=${columns_conditions#:}
	echo "$columns_names" >> "$table.metadata"
	echo "$columns_types" >> "$table.metadata"
	echo "$columns_conditions" >> "$table.metadata"
        echo "Table '$table' created successfully with $num_columns columns."
    fi

    ;;
	"DropTable")
		
		read -p "Enter Table Name: " table
		if [ -f $table.metadata ]; then
			rm $table.metadata
			rm $table.data
			echo "Drop Table Successfully"
		else
			echo "No such table with this name!"
		fi
		;;




		"ListTables")
		for table in ./*
		do
		if [[ $table =~ \.metadata$ ]]; then
			tname="${table#./}"
			tname="${tname%.metadata}"
			echo "$tname"
		fi
		done
		;;


		
		"InsertData")
    read -p "Enter table name: " table
    if [ -f "$table.metadata" ]; then
        n_cols=$(awk -F: 'END{print NF}' "./$table.metadata")
        columns_names=($(awk -F: 'NR==1{for(i=1;i<=NF;i++)print $i}' "$table.metadata"))
        columns_types=($(awk -F: 'NR==2{for(i=1;i<=NF;i++)print $i}' "$table.metadata"))
        columns_conditions=($(awk -F: 'NR==3{for(i=1;i<=NF;i++)print $i}' "$table.metadata"))

        line=""
        for ((i=1; i<=n_cols; i++)); do
            while true; do
                read -p "Enter value for ${columns_names[i-1]} (${columns_types[i-1]}): " value

                # Check for ":" in the entered value
                if [[ "$value" == *":"* ]]; then
                    echo "Error: Values cannot contain ':'. Enter the values again."
                    continue
                fi

                # Check for data type (int, string)
                if [ "${columns_types[i-1]}" == "int" ]; then
                    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
                        echo "Error: Invalid data type. Please enter an integer for '${columns_names[i-1]}'."
                        continue
                    fi
                elif [ "${columns_types[i-1]}" == "string" ]; then
                    if [[ "$value" =~ ^[0-9]+$ ]]; then
                        echo "Error: Invalid data type. Please enter a string for '${columns_names[i-1]}'."
                        continue
                    fi
                else
                    echo "Error: Unknown data type for '${columns_names[i-1]}'."
                    continue 2
                fi

                break
            done

            line+=":$value"
        done

        line=${line#:}
        pk_col=""
        for ((i=0; i<n_cols; i++)); do
            if [ "${columns_conditions[i]}" == "pk" ]; then
                pk_col="$i"
                break
            fi
        done

        # Check for duplicate primary key
        if [ -n "$pk_col" ]; then
            pk_value=$(echo "$line" | cut -d':' -f$((pk_col+1)))
            if grep -q "^$pk_value:" "$table.data"; then
                echo "Error: Duplicate value for primary key."
                continue
            fi
        fi

        # Insert values into the table
        echo "$line" >> "$table.data"
        echo "Values inserted successfully."

    else
        echo "No table with this name! Enter a name from: "
        for t in ./*; do
            if [[ $t =~ \.metadata$ ]]; then
                tname="${t#./}"
                tname="${tname%.metadata}"
                echo "$tname"
            fi
        done
    fi
    ;;



"UpdateData")
    read -p "Enter table name: " table
    if [ -f "$table.metadata" ]; then
        n_cols=$(awk -F: 'END{print NF}' "./$table.metadata")
        columns_names=($(awk -F: 'NR==1{for(i=1;i<=NF;i++)print $i}' "$table.metadata"))
        columns_types=($(awk -F: 'NR==2{for(i=1;i<=NF;i++)print $i}' "$table.metadata"))
        columns_conditions=($(awk -F: 'NR==3{for(i=1;i<=NF;i++)print $i}' "$table.metadata"))

        # Display existing data
        echo "Existing data in $table:"
        cat "$table.data"

        # Prompt user for primary key value to update
        read -p "Enter the primary key value to update: " old_pk_value

        # Check if the entered primary key exists
        if ! grep -q "^$old_pk_value:" "$table.data"; then
            echo "Error: No record found with the given primary key value. Cannot update."
            continue
        fi

        # Check for duplicate primary key
        pk_col=""
        for ((i=0; i<n_cols; i++)); do
            if [ "${columns_conditions[i]}" == "pk" ]; then
                pk_col="$i"
                break
            fi
        done

        if [ -n "$pk_col" ]; then
            # Prompt user for new primary key value
            read -p "Enter the new primary key value (press Enter to keep it unchanged): " new_pk_value

            # Check for duplicate primary key
            if [ -n "$new_pk_value" ] && grep -q "^$new_pk_value:" "$table.data"; then
                echo "Error: Record with the new primary key value already exists. Cannot update."
                continue
            fi
        else
            echo "Error: The table does not have a primary key defined."
            continue
        fi

        # Prompt user for new values
        line=""
        for ((i=1; i<=n_cols; i++)); do
            # Skip prompting for the pk column, as it has already been handled
            if [ "$i" -eq "$((pk_col + 1))" ]; then
                continue
            fi

            while true; do
                read -p "Enter new value for ${columns_names[i-1]} (${columns_types[i-1]}): " value

                # Check for ":" in the entered value
                if [[ "$value" == *":"* ]]; then
                    echo "Error: Values cannot contain ':'. Enter the values again."
                    continue
                fi

                # Check for data type (int, string)
                if [ "${columns_types[i-1]}" == "int" ]; then
                    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
                        echo "Error: Invalid data type. Please enter an integer for '${columns_names[i-1]}'."
                        continue
                    fi
                elif [ "${columns_types[i-1]}" == "string" ]; then
                    # No further validation for string type
                    :
                else
                    echo "Error: Unknown data type for '${columns_names[i-1]}'."
                    continue 2
                fi

                break
            done

            line+=":$value"
        done

        # Update the matched line
        if [ -n "$new_pk_value" ]; then
            sed -i "s/^$old_pk_value:.*/$new_pk_value$line/" "$table.data"
        else
            sed -i "s/^$old_pk_value:.*/$old_pk_value$line/" "$table.data"
        fi
        echo "Record updated successfully."

    else
        echo "No table with this name! Enter a name from: "
        for t in ./*; do
            if [[ $t =~ \.metadata$ ]]; then
                tname="${t#./}"
                tname="${tname%.metadata}"
                echo "$tname"
            fi
        done
    fi
    ;;








"SearchData")
    read -p "Enter Table Name: " table
    if [ -f "$table.metadata" ]; then
        # Display available columns for search
        columns_names=($(awk -F: 'NR==1{for(i=1;i<=NF;i++)print $i}' "$table.metadata"))
        echo "Available columns for search: ${columns_names[@]}"

        # Prompt the user for the search column
        read -p "Enter the column to search: " search_column

        # Check if the entered column is valid
        if [[ " ${columns_names[@]} " =~ " $search_column " ]]; then
            # Prompt the user for the search value
            read -p "Enter the value to match (* for all): " search_value

            # Display the header (column names) from metadata
            awk -F: 'NR==1 {print $0}' "$table.metadata" | tr ' ' ':'

            # Get the index of the specified column
            col_index=$(awk -F: -v col="$search_column" '{ for (i=1; i<=NF; i++) if ($i == col) print i }' "$table.metadata")

            # Search by the specified column and value
            if [ "$search_value" = "*" ]; then
                cat "$table.data" | column -t -s ':'
            else
                awk -v col_index="$col_index" -v search_value="$search_value" -F: '$(col_index) == search_value' "$table.data" | column -t -s ':'
            fi
        else
            echo "Error: Invalid column name. Please choose from the available columns."
        fi
    else
        echo "No table with this name!"
    fi
    ;;




		  "DeleteData")
		    read -p "Enter Table Name: " table
		    if [ -f "$table.metadata" ]; then
			read -p "Do you want to delete all data or a specific row? (all/specific): " delete_option
			if [ "$delete_option" == "all" ]; then
			    # Delete all data
			    > "$table.data"
			    echo "All data deleted successfully from table '$table'."
			elif [ "$delete_option" == "specific" ]; then
			    read -p "Enter the primary key value of the row to delete: " primary_key_value
			    # Delete the specific row
			    if [ -f "$table.data" ]; then
				sed -i "/^$primary_key_value:/d" "$table.data" || echo "Error deleting row."
				echo "Row with primary key '$primary_key_value' deleted successfully from table '$table'."
			    else
				echo "Data file '$table.data' not found for table '$table'."
			    fi
			else
			    echo "Invalid option. Please enter 'all' or 'specific'."
			fi
		    else
			echo "No table with this name!"
		    fi
		    ;;


		"DisconnectDB")
				echo "Disconnection Successfully"
				exit
				;;

		esac
echo "Enter (Enter) to display the menu again"
		done
		
	else
		echo "No such database with this Name!"
		break
	fi

	done



;;



"ListDB")
	for db in ./MySQL/*
	do
	if [[ $db =~ \.db$ ]]; then
		dbname="${db#./MySQL/}"
		dbname="${dbname%.db}"
		echo "$dbname"
	fi
	done
;;
"DeleteDB")
while true
	do
	read -p "Enter Database Name: " database

	if [ -d "./MySQL/$database.db" ]; then
                rm -r ./MySQL/$database.db
		echo "Database deleted successfully."
		break
	elif [[ "$database" == *" "* || "$database" == "" ]]; then
		echo "Error: Database name cannot contain spaces. Enter another name."
	elif [[ "$database" =~ ^[0-9] ]]; then
		echo "Error: Database name cannot start with a number. Enter another name."
	elif [[ "$database" =~ ^[^a-zA-Z0-9] ]]; then
		echo "Error: Database name cannot start with symbols. Enter another name."
	else
		echo "No database with this name"
		break
	fi
	done
;;



"Exit")
	exit
;;
"")
    echo "Choose option Number."
;;
*)
	echo "Choose option Number."
;; 
esac
done

