# While loop
#!/bin/bash
n=1

while [ $n -le 10 ]
do
	echo "$n"
	(( ++n ))
done
#----------------------------------------------------------------------------------------------------------------------------------------------

# For Loop
for server in ${server_list[*]};
do
echo "$server"
done
#----------------------------------------------------------------------------------------------------------------------------------------------

# Function
#!/bin/bash

test_shadow(){
	if [ -e /etc/shadow ];
	then
		echo "It exists"
	else
		echo "File does not exist"
}

test_passwd(){
	if [ -e /etc/passwd ];
	then
		echo "It exists"
	else
		echo "File does not exist"
}

test_shadow
test_passwd
#----------------------------------------------------------------------------------------------------------------------------------------------