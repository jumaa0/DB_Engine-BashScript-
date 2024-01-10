#! /usr/bin/bash
if [ -d MySQL ]; then
    echo "welcome to MySQL"
else
    mkdir ./MySQL
fi
echo "Choose option Number: "

select to in CreateUser CreateDB ConnectDB ListDB DeleteDB Exit
do
case $to in 
"CreateUser")
	read -p "Enter username: " user
	read -p "Enter password: " pass
	if [ -f "users" ]; then

		if grep -q "^$user:" users; then
			echo "Username already exists. Choose a different username."
		else
			echo "$user:$pass" >> users
			echo "User appended to 'users' file."
	    	fi
	else

		echo "$user:$pass" > users

	fi
;;
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
		
		select option in CreateTable DropTable ListTables DisconnectDB
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
            read -p "Do you want to specify a condition for column $col_name? (y/n): " specify_condition
		
            # Check if the user wants to specify a condition
            if [[ "$specify_condition" == "y" ]]; then
                # Loop until a valid condition is entered
                while true; do
                    read -p "Enter Condition [pk, unique, notnull]: " condition

                    # Check if the entered condition is one of the specified options
                    if [[ "$condition" == "pk" ]]; then
			if $pk_flage; then
				echo "Error, there are a Primary key already!"
			else
			pk_flage=true
			break
			fi
			elif [[ "$condition" == "unique" || "$condition" == "notnull" ]]; then
                        break
                    else
                        echo "Error: Invalid condition. Please enter 'pk', 'unique', or 'notnull'."
                    fi
                done
            else
                # If the user doesn't want to specify a condition, set it to an empty string
                condition="null"
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


		"DisconnectDB")
		echo "Disconnection Successfully"
		exit
		;;
		esac
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
