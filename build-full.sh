#!/bin/bash

clear

TOOLCHAIN="default"
RAMDISK="default"
CREATE_BOOTIMG="1"
MAKE_DEFCONFIG="1"
FOUR_THREADS="0"

if [ "$1" == "-s" ]; then
	echo "#"
	echo "# silent configuration...";
	echo "#"
	echo ""
	TOOLCHAIN="~/CodeSourcery/Sourcery_G++_Lite/bin/arm-none-eabi-"
	CREATE_BOOTIMG="1"
	MAKE_DEFCONFIG="1"
	if [ "$2" == "-j4" ]; then
		FOUR_THREADS="1"
	else
		FOUR_THREADS="0"
	fi
else
	echo "Which toolchain do you want to use?";
	echo "	[1] Code Soucery G++ ARM none EABI";
	echo "	[2] Code Soucery G++ AMR Linux none GNUEBAI";
	echo "	[3] specify own toolchain path";
	echo -e -n "your choice [1]: "; 
	read CHOICE

	if [ "$CHOICE" == "" ] ; then
	    CHOICE=1
	fi

	case $CHOICE in
		1)  echo "using: Code Soucery G++ ARM EABI";
			TOOLCHAIN="~/CodeSourcery/Sourcery_G++_Lite/bin/arm-none-eabi-";;
		2)  echo "using: Code Soucery G++ AMR Linux none GNUEBAI";
			TOOLCHAIN="~/CodeSourcery/Sourcery_G++_Lite/bin/arm-none-linux-gnueabi-";;
		3)  while [ "$CHOICE" != "y" ]; do
			echo -n "enter your toolchain path: ";
			read TOOLCHAIN;
			echo "your new toolchain is: " $TOOLCHAIN;
			echo -n "is this correct [N/Y]: ";
			read CHOICE
			if [ "$CHOICE" == "" ]; then
				CHOICE="y"
			fi
		    done;;
	esac

	echo ""

	echo -n "create boot image [N/Y]: ";
	read CHOICE
	if [ "$CHOICE" == "" ]; then
		CHOICE="y"
	fi
	if [ "$CHOICE" == "y" ]; then
		CREATE_BOOTIMG="1"
	else
		CREATE_BOOTIMG="0"
	fi

	echo ""

	echo -n "make tmobile_pulse_defconfig [N/Y]: ";
	read CHOICE
	if [ "$CHOICE" == "" ]; then
		CHOICE="y"
	fi
	if [ "$CHOICE" == "y" ]; then
		MAKE_DEFCONFIG="1"
	else
		MAKE_DEFCONFIG="0"
	fi

	echo ""

	echo -n "use 4 threads [N/Y]: ";
	read CHOICE
	if [ "$CHOICE" == "" ]; then
		CHOICE="y"
	fi
	if [ "$CHOICE" == "y" ]; then
		FOUR_THREADS="1"
	else
		FOUR_THREADS="0"
	fi
fi

echo ""
echo "configuration done..."
echo ""
echo "#"
echo "# summary"
echo "#"
echo ""
echo "toolchain: " $TOOLCHAIN
echo "create boot image = " $CREATE_BOOTIMG
echo "make tmobile_pulse_defconfig = " $MAKE_DEFCONFIG
echo "use 4 threads = " $FOUR_THREADS
echo ""
echo "compilation will start in 5 seconds."
echo "Press Ctrl - C to abort..."
echo ""
sleep 5



if [ "$MAKE_DEFCONFIG" == "1" ]; then
	make defconfig tmobile_pulse_defconfig
fi

if [ "$FOUR_THREADS" == "1" ]; then
	make CROSS_COMPILE=$TOOLCHAIN -j4
else
	make CROSS_COMPILE=$TOOLCHAIN
fi

if [ "$CREATE_BOOTIMG" == "1" ]; then
	make bootimg
fi
