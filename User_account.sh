#!/bin/bash

# Check if user is logged in as sudo/root user.

if [[ "${UID}" -ne 0 ]]; then
  echo "Please enter with sudo or root user."
  exit 1
fi

# Check if user provided any argument as username.

if [[ "${#}" -lt 1 ]]; then
  echo -e "You haven't created a username.\nTo create a username..."
  echo "Example: ${0} user_name [Comment]..."
  exit 1
fi

# Store 1st argument as username and rest as comments

user_name="${1}"
# echo $user_name
shift
comments="${@}"
# echo $comments

# Create random password for user
echo "Please enter the length of your password: "
read pass_length
echo "Choose one password from below: "

for i in $(seq 1 5); do
  openssl rand -base64 48 | cut -c1-$pass_length
done

read p_word

# Create the user
useradd -c "${comments}" -m ${user_name}

# Check if user creation is succesful or not.

if [[ "${?}" -ne 0 ]]; then
  echo "Sorry..this account could not be created."
  exit 1
fi

# Set the password for the user
echo "$user_name:$p_word" | chpasswd

# Check if password is succesfully set or not

if [[ "${?}" -ne 0 ]]; then
  echo "Password could not be set."
  exit 1
fi

# Force password change on the first login
passwd -e ${user_name}

# Display the changes
echo
echo "username: "
echo "${user_name}"
echo
echo "password: "
echo "${p_word}"
echo
echo "hostname: "
echo "$(hostname)"
echo
exit 0
