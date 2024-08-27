#!/bin/sh
add_to_environment() {
    variable_name=$1
    variable_value=$2

    # Check if variable already exists in /etc/environment
    if grep -q "^$variable_name=" /etc/environment; then
        # Replace the existing variable value
        sudo sed -i "s|^$variable_name=.*$|$variable_name=$variable_value|" /etc/environment
        echo "Variable '$variable_name' updated in /etc/environment."
    else
        # Append the variable to /etc/environment
        echo "$variable_name=$variable_value" | sudo tee -a /etc/environment
        echo "Variable '$variable_name' added to /etc/environment."
    fi
}


add_to_path() {
    new_path=$1

    # Check if PATH already contains the new path
    if grep -q "^PATH=.*$new_path" /etc/environment; then
        echo "Path '$new_path' already exists in PATH."
    else
        # Append the new path to PATH
        if grep -q "^PATH=" /etc/environment; then
            sudo sed -i "s|^PATH=.*$|PATH=\"&:$new_path\"|" /etc/environment
        else
            echo "PATH=\"$new_path\"" | sudo tee -a /etc/environment
        fi
        echo "Path '$new_path' added to PATH in /etc/environment."
    fi
}


add_to_bashrc() {
    file_path=$1
    file_name=$(basename "$file_path")
    
    # Check if the line already exists in ~/.bashrc
    if ! grep -q "source $file_path" ~/.bashrc; then
        echo "source $file_path" | tee -a ~/.bashrc
        echo "Added 'source $file_path' to ~/.bashrc."
    else
        echo "'source $file_path' already exists in ~/.bashrc."
    fi
}