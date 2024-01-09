#! /usr/bin/bash
if [ -d MySQL ]; then
    echo "welcome to MySQL"
else
    mkdir ./MySQL
fi
echo "Choose option Number: "

select to in CreateUser CreateDB ConnectDB ListDB Exit
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
	elif [[ "$database" == *" "* ]]; then
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
		if [[ "$table" == *" "* ]]; then
        		echo "Error: Table name cannot contain spaces. Enter another name."
        	elif [[ "$table" =~ ^[0-9] ]]; then
        		echo "Error: Table name cannot start with a number. Enter another name."
        	elif [[ "$table" =~ ^[^a-zA-Z0-9] ]]; then
        		echo "Error: Table name cannot start with symbols. Enter another name."
        	elif [ -f $table.metadata ]; then
         		echo "Table is already exist"
         	else
			touch $table.metadata
			touch $table.data
			echo "Table Created Successfully"
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
"Exit")
	exit
;;
*)
	echo "Choose option Number."
;; 
esac
done
