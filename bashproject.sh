#! /usr/bin/bash
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
			# If the username doesn't exist, append the new user
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

		if [ -d "$database" ]; then
			echo "There is a Database with the same name, Enter another name."
		elif [[ "$database" == *" "* ]]; then
        		echo "Error: Database name cannot contain spaces. Enter another name."
        	elif [[ "$database" =~ ^[0-9] ]]; then
        		echo "Error: Database name cannot start with a number. Enter another name."
        	elif [[ "$database" =~ ^[0-9] ]]; then
        		echo "Error: Database name cannot start with a number. Enter another name."
        	elif [[ "$database" =~ ^[^a-zA-Z0-9] ]]; then
        		echo "Error: Database name cannot start with symbols. Enter another name."
		else
			mkdir ./$database
			echo "Database created successfully."
			break
		fi
	done
;;
"ConnectDB")
	echo "Not Coded yet. !"
;;
"ListDB")
	ls 
;;
"Exit")
	exit
;;
*)
	echo "Choose option Number."
;; 
esac
done
