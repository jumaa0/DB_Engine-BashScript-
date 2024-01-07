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
			echo "There is a Database with the same name."
			echo "Enter another name."
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
