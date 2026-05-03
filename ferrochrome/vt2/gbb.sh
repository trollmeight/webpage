#!/bin/bash
# Created by Nikki
# Owner of Ferrochrome
# https://discord.gg/624wVgpf9W

# clear the screen
printf "\ec"
# check for chronos and exit if on chronos
if [ $USER = "chronos" ]; then
echo "Please switch to the root user and run the script again."
exit
fi
# warning
echo -e "\e[31mWARNING:\e[0m"
echo "If you set invalid gbb flags, you could brick your device."
echo "Please make sure you know what you doing, and check for typos before submitting flags."
read -p "Continue? (y/n) " ynselection
# the rest
if [ $ynselection = y ]; then
read -p "Please enter your GBB flags: " gbbflags
echo "Writing GBB flags..."
futility gbb -s --flash --flags=$gbbflags
echo "Flags written! Exiting..."
exit
# exit if user cancels
elif [ $ynselection = n ]; then
exit
fi
