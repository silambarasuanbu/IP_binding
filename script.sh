#!/bin/bash
cd /etc/sysconfig/network-scripts/
#
#######Check interface######
#
read -p "Enter the network interface name:" interface
ethport=$interface
#
interfacestatus=$(ethtool $interface |awk '/Link/ {print $3}')
instatus=$interfacestatus
echo "Interface status is $instatus"
if [[ yes = $instatus ]]
then
echo "Interface $ethport is correct"
#
######### Prerequest services installation###########

#screen
yum install screen -y

#wget
yum install wget -y
#screen -S wget -dm yum install wget -y

##################epel-release package########################
#screen -S epelpack -dm yum install epel-release -y
yum install epel-release -y
#################ipcalculator#############
#screen -S sipcalc -dm yum install sipcalc -y
yum install sipcalc -y
##Adding NM_controller in main interface
echo "NM_CONTROLLED=no" >> ifcfg-$ethport
echo "NOZEROCONF=yes" >> ifcfg-$ethport
echo "### NM_CONTROLLED=no, NOZEROCONF=yes added into ifcfg-$ethport file ###"

###############
# RANGE0
###############
read -p "Enter the range value:" ipr0
#
#
touch ifcfg-$ethport-range$ipr0
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr0
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr0
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr0
#
firstuseableipr0=$(sipcalc $cidr0 | awk '/Usable range/{print $4}')
mainip0=$(echo $firstuseableipr0 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr0:" mainip0
echo IPADDR_START=$mainip0 >> ifcfg-$ethport-range$ipr0
#
#Last useable IP
lastip0=$(sipcalc $cidr0 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip0" >> ifcfg-$ethport-range$ipr0
#
#NETMASK finder
netmask0=$(sipcalc $cidr0 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask0" >> ifcfg-$ethport-range$ipr0
#
#PREFIX finder
prefix0=$(sipcalc $cidr0 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix0" >> ifcfg-$ethport-range$ipr0
#
#Clonenum finder
echo "CLONENUM_START=1" >> ifcfg-$ethport-range$ipr0
echo "$(cat ifcfg-$ethport-range$ipr0)"

echo "#### Range$ipr0 > $cidr0 completed ####"
###############
# RANGE1
###############
read -p "Enter the range value:" ipr1
#
#
touch ifcfg-$ethport-range$ipr1
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr1
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr1
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr1
#
firstuseableipr1=$(sipcalc $cidr1 | awk '/Usable range/{print $4}')
mainip1=$(echo $firstuseableipr1 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr1:" mainip1
echo IPADDR_START=$mainip1 >> ifcfg-$ethport-range$ipr1
#
#Last useable IP
lastip1=$(sipcalc $cidr1 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip1" >> ifcfg-$ethport-range$ipr1
#
#NETMASK finder
netmask1=$(sipcalc $cidr1 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask1" >> ifcfg-$ethport-range$ipr1
#
#PREFIX finder
prefix1=$(sipcalc $cidr1 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix1" >> ifcfg-$ethport-range$ipr1
##Clonenum calculator
ipcr0=$(sipcalc $cidr0 |awk '/Addresses/ {print $5}')
uptor0cl=$(cat ifcfg-$ethport-range$ipr0 |awk -F "=" '/CLONENUM_START/{print $2}')
cl1=$(($ipcr0 + $uptor0cl))
echo "CLONENUM_START=$cl1" >> ifcfg-$ethport-range$ipr1
echo "$(cat ifcfg-$ethport-range$ipr1)"

echo "#### Range$ipr1 completed ###"

###############
# RANGE2
###############
read -p "Enter the range value:" ipr2
#
#
touch ifcfg-$ethport-range$ipr2
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr2
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr2
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr2
#
#
firstuseableipr2=$(sipcalc $cidr2 | awk '/Usable range/{print $4}')
mainip2=$(echo $firstuseableipr2 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr2:" mainip2
echo IPADDR_START=$mainip2 >> ifcfg-$ethport-range$ipr2
#
#Last useable IP
lastip2=$(sipcalc $cidr2 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip2" >> ifcfg-$ethport-range$ipr2
#
#NETMASK finder
netmask2=$(sipcalc $cidr2 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask2" >> ifcfg-$ethport-range$ipr2
#
#PREFIX finder
prefix2=$(sipcalc $cidr2 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix2" >> ifcfg-$ethport-range$ipr2
##Clonenum calculator
ipcr1=$(sipcalc $cidr1 |awk '/Addresses/ {print $5}')
uptor1cl=$(cat ifcfg-$ethport-range$ipr1 |awk -F "=" '/CLONENUM_START/{print $2}')
cl2=$(($ipcr1 + $uptor1cl))
echo "CLONENUM_START=$cl2" >> ifcfg-$ethport-range$ipr2
echo "$(cat ifcfg-$ethport-range$ipr2)"

echo "#### Range$ipr2 > $cidr2 completed ###"

###############
# RANGE3
###############
read -p "Enter the range value:" ipr3
#
#
touch ifcfg-$ethport-range$ipr3
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr3
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr3
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr3
#
#
firstuseableipr3=$(sipcalc $cidr3 | awk '/Usable range/{print $4}')
mainip3=$(echo $firstuseableipr3 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr3:" mainip3
echo IPADDR_START=$mainip3 >> ifcfg-$ethport-range$ipr3
#
#Last useable IP
lastip3=$(sipcalc $cidr3 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip3" >> ifcfg-$ethport-range$ipr3
#
#NETMASK finder
netmask3=$(sipcalc $cidr3 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask3" >> ifcfg-$ethport-range$ipr3
#
#PREFIX finder
prefix3=$(sipcalc $cidr3 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix3" >> ifcfg-$ethport-range$ipr3
#
#read -p "Clonenum start value for range 3 :" clonenum3
#echo CLONENUM_START=$clonenum3 >> ifcfg-$ethport-range$ipr3
#echo "$cat ifcfg-$ethport-range$ipr3"
ipcr2=$(sipcalc $cidr2 |awk '/Addresses/ {print $5}')
uptor2cl=$(cat ifcfg-$ethport-range$ipr2 |awk -F "=" '/CLONENUM_START/{print $2}')
cl3=$(($ipcr2 + $uptor2cl))
echo "CLONENUM_START=$cl3" >> ifcfg-$ethport-range$ipr3
echo "$(cat ifcfg-$ethport-range$ipr3)"
echo "#### Range$ipr3 > $cidr3 completed ###"

########################################
# RANGE4
###############
read -p "Enter the range value:" ipr4
#
#
touch ifcfg-$ethport-range$ipr4
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr4
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr4
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr4
#
#
firstuseableipr4=$(sipcalc $cidr4 | awk '/Usable range/{print $4}')
mainip4=$(echo $firstuseableipr4 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr4:" mainip4
echo IPADDR_START=$mainip4 >> ifcfg-$ethport-range$ipr4
#
#Last useable IP
lastip4=$(sipcalc $cidr4 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip4" >> ifcfg-$ethport-range$ipr4
#
#NETMASK finder
netmask4=$(sipcalc $cidr4 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask4" >> ifcfg-$ethport-range$ipr4
#
#PREFIX finder
prefix4=$(sipcalc $cidr4 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix4" >> ifcfg-$ethport-range$ipr4
#
ipcr3=$(sipcalc $cidr3 |awk '/Addresses/ {print $5}')
uptor3cl=$(cat ifcfg-$ethport-range$ipr3 |awk -F "=" '/CLONENUM_START/{print $2}')
cl4=$(($ipcr3 + $uptor3cl))
echo "CLONENUM_START=$cl4" >> ifcfg-$ethport-range$ipr4
echo "$(cat ifcfg-$ethport-range$ipr4)"

echo "#### Range$ipr4 > $cidr4 completed ###"


###############
# RANGE5
###############
read -p "Enter the range value:" ipr5
#
#
touch ifcfg-$ethport-range$ipr5
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr5
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr5
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr5
#
#
firstuseableipr5=$(sipcalc $cidr5 | awk '/Usable range/{print $4}')
mainip5=$(echo $firstuseableipr5 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr5:" mainip5
echo IPADDR_START=$mainip5 >> ifcfg-$ethport-range$ipr5
#
#Last useable IP
lastip5=$(sipcalc $cidr5 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip5" >> ifcfg-$ethport-range$ipr5
#
#NETMASK finder
netmask5=$(sipcalc $cidr5 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask5" >> ifcfg-$ethport-range$ipr5
#
#PREFIX finder
prefix5=$(sipcalc $cidr5 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix5" >> ifcfg-$ethport-range$ipr5
#
#Clonenum calculator
#ipcr4=$(sipcalc $cidr4 |awk '/Addresses/ {print $5}')
#uptor4cl=$(cat ifcfg-$ethport-range$ipr4 |awk -F "=" '/CLONENUM_START/{print $5}')
#cl5=$(($ipcr4 + $uptor4cl))
#echo "CLONENUM_START=$cl5" >> ifcfg-$ethport-range$ipr5
ipcr4=$(sipcalc $cidr4 |awk '/Addresses/ {print $5}')
uptor4cl=$(cat ifcfg-$ethport-range$ipr4 |awk -F "=" '/CLONENUM_START/{print $2}')
cl5=$(($ipcr4 + $uptor4cl))
echo "CLONENUM_START=$cl5" >> ifcfg-$ethport-range$ipr5

echo "$(cat ifcfg-$ethport-range$ipr5)"

echo "#### Range$ipr5 > $cidr5 completed ###"


###############
# RANGE6
###############
read -p "Enter the range value:" ipr6
#
#
touch ifcfg-$ethport-range$ipr6
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr6
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr6
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr6
#
#
firstuseableipr6=$(sipcalc $cidr6 | awk '/Usable range/{print $4}')
mainip6=$(echo $firstuseableipr6 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr6:" mainip6
echo IPADDR_START=$mainip6 >> ifcfg-$ethport-range$ipr6
#
#Last useable IP
lastip6=$(sipcalc $cidr6 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip6" >> ifcfg-$ethport-range$ipr6
#
#NETMASK finder
netmask6=$(sipcalc $cidr6 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask6" >> ifcfg-$ethport-range$ipr6
#
#PREFIX finder
prefix6=$(sipcalc $cidr6 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix6" >> ifcfg-$ethport-range$ipr6
#
#Clonenum calculator
ipcr5=$(sipcalc $cidr5 |awk '/Addresses/ {print $5}')
uptor5cl=$(cat ifcfg-$ethport-range$ipr5 |awk -F "=" '/CLONENUM_START/{print $2}')
cl6=$(($ipcr5 + $uptor5cl))
echo "CLONENUM_START=$cl6" >> ifcfg-$ethport-range$ipr6

echo "$(cat ifcfg-$ethport-range$ipr6)"
echo "#### Range$ipr6 > $cidr6 completed ###"



###############
# RANGE7
###############
read -p "Enter the range value:" ipr7
#
#
touch ifcfg-$ethport-range$ipr7
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr7
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr7
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr7
#
firstuseableipr7=$(sipcalc $cidr7 | awk '/Usable range/{print $4}')
mainip7=$(echo $firstuseableipr7 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr7:" mainip7
echo IPADDR_START=$mainip7 >> ifcfg-$ethport-range$ipr7
#
#Last useable IP
lastip7=$(sipcalc $cidr7 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip7" >> ifcfg-$ethport-range$ipr7
#
#NETMASK finder
netmask7=$(sipcalc $cidr7 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask7" >> ifcfg-$ethport-range$ipr7
#
#PREFIX finder
prefix7=$(sipcalc $cidr7 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix7" >> ifcfg-$ethport-range$ipr7
#
#Clonenum calculator
ipcr6=$(sipcalc $cidr6 |awk '/Addresses/ {print $5}')
uptor6cl=$(cat ifcfg-$ethport-range$ipr6 |awk -F "=" '/CLONENUM_START/{print $2}')
cl7=$(($ipcr6 + $uptor6cl))
echo "CLONENUM_START=$cl7" >> ifcfg-$ethport-range$ipr7
echo "$(cat ifcfg-$ethport-range$ipr7)"
echo "#### Range$ipr7 > $cidr7 completed ###"
###############
# RANGE8
###############
read -p "Enter the range value:" ipr8
#
#
touch ifcfg-$ethport-range$ipr8
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr8
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr8
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr8
#
#
firstuseableipr8=$(sipcalc $cidr8 | awk '/Usable range/{print $4}')
mainip8=$(echo $firstuseableipr8 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr8:" mainip8
echo IPADDR_START=$mainip8 >> ifcfg-$ethport-range$ipr8
#
#Last useable IP
lastip8=$(sipcalc $cidr8 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip8" >> ifcfg-$ethport-range$ipr8
#
#NETMASK finder
netmask8=$(sipcalc $cidr8 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask8" >> ifcfg-$ethport-range$ipr8
#
#PREFIX finder
prefix8=$(sipcalc $cidr8 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix8" >> ifcfg-$ethport-range$ipr8
#
#Clonenum calculator
ipcr7=$(sipcalc $cidr7 |awk '/Addresses/ {print $5}')
uptor7cl=$(cat ifcfg-$ethport-range$ipr7 |awk -F "=" '/CLONENUM_START/{print $2}')
cl8=$(($ipcr7 + $uptor7cl))
echo "CLONENUM_START=$cl8" >> ifcfg-$ethport-range$ipr8
echo "$(cat ifcfg-$ethport-range$ipr8)"



echo "#### Range$ipr8 > $cidr8 completed ###"

###############
# RANGE9
###############
read -p "Enter the range value:" ipr9
#
#
touch ifcfg-$ethport-range$ipr9
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr9
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr9
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr9
#
firstuseableipr9=$(sipcalc $cidr9 | awk '/Usable range/{print $4}')
mainip9=$(echo $firstuseableipr9 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr9:" mainip9
echo IPADDR_START=$mainip9 >> ifcfg-$ethport-range$ipr9
#
#Last useable IP
lastip9=$(sipcalc $cidr9 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip9" >> ifcfg-$ethport-range$ipr9
#
#NETMASK finder
netmask9=$(sipcalc $cidr9 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask9" >> ifcfg-$ethport-range$ipr9
#
#PREFIX finder
prefix9=$(sipcalc $cidr9 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix9" >> ifcfg-$ethport-range$ipr9
#
#Clonenum calculator
ipcr8=$(sipcalc $cidr8 |awk '/Addresses/ {print $5}')
uptor8cl=$(cat ifcfg-$ethport-range$ipr8 |awk -F "=" '/CLONENUM_START/{print $2}')
cl9=$(($ipcr8 + $uptor8cl))
echo "CLONENUM_START=$cl9" >> ifcfg-$ethport-range$ipr9
echo "$(cat ifcfg-$ethport-range$ipr9)"

echo "#### Range$ipr9 > $cidr9 completed ###"

###############
# RANGE10
###############
read -p "Enter the range value:" ipr10
#
#
touch ifcfg-$ethport-range$ipr10
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr10
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr10
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr10
#
#
firstuseableipr10=$(sipcalc $cidr10 | awk '/Usable range/{print $4}')
mainip10=$(echo $firstuseableipr10 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr10:" mainip10
echo IPADDR_START=$mainip10 >> ifcfg-$ethport-range$ipr10
#
#Last useable IP
lastip10=$(sipcalc $cidr10 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip10" >> ifcfg-$ethport-range$ipr10
#
#NETMASK finder
netmask10=$(sipcalc $cidr10 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask10" >> ifcfg-$ethport-range$ipr10
#
#PREFIX finder
prefix10=$(sipcalc $cidr10 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix10" >> ifcfg-$ethport-range$ipr10
#

#Clonenum calculator
ipcr9=$(sipcalc $cidr9 |awk '/Addresses/ {print $5}')
uptor9cl=$(cat ifcfg-$ethport-range$ipr9 |awk -F "=" '/CLONENUM_START/{print $2}')
cl10=$(($ipcr9 + $uptor9cl))
echo "CLONENUM_START=$cl10" >> ifcfg-$ethport-range$ipr10
echo "$(cat ifcfg-$ethport-range$ipr10)"

echo "#### Range$ipr10 > $cidr10 completed ###"

###############
# RANGE11
###############
read -p "Enter the range value:" ipr11
#
#
touch ifcfg-$ethport-range$ipr11
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr11
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr11
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr11
#
firstuseableipr11=$(sipcalc $cidr11 | awk '/Usable range/{print $4}')
mainip11=$(echo $firstuseableipr11 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr11:" mainip11
echo IPADDR_START=$mainip11 >> ifcfg-$ethport-range$ipr11
#
#Last useable IP
lastip11=$(sipcalc $cidr11 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip11" >> ifcfg-$ethport-range$ipr11
#
#NETMASK finder
netmask11=$(sipcalc $cidr11 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask11" >> ifcfg-$ethport-range$ipr11
#
#PREFIX finder
prefix11=$(sipcalc $cidr11 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix11" >> ifcfg-$ethport-range$ipr11
#
#Clonenum calculator
ipcr10=$(sipcalc $cidr10 |awk '/Addresses/ {print $5}')
uptor10cl=$(cat ifcfg-$ethport-range$ipr10 |awk -F "=" '/CLONENUM_START/{print $2}')
cl11=$(($ipcr10 + $uptor10cl))
echo "CLONENUM_START=$cl11" >> ifcfg-$ethport-range$ipr11
echo "$(cat ifcfg-$ethport-range$ipr11)"
echo "#### Range$ipr11 > $cidr11 completed ###"


###############
# RANGE12
###############
read -p "Enter the range value:" ipr12
#
#
touch ifcfg-$ethport-range$ipr12
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr12
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr12
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr12
#
#
firstuseableipr12=$(sipcalc $cidr12 | awk '/Usable range/{print $4}')
mainip12=$(echo $firstuseableipr12 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr12:" mainip12
echo IPADDR_START=$mainip12 >> ifcfg-$ethport-range$ipr12
#
#Last useable IP
lastip12=$(sipcalc $cidr12 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip12" >> ifcfg-$ethport-range$ipr12
#
#NETMASK finder
netmask12=$(sipcalc $cidr12 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask12" >> ifcfg-$ethport-range$ipr12
#
#PREFIX finder
prefix12=$(sipcalc $cidr12 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix12" >> ifcfg-$ethport-range$ipr12
#
#Clonenum calculator
ipcr11=$(sipcalc $cidr11 |awk '/Addresses/ {print $5}')
uptor11cl=$(cat ifcfg-$ethport-range$ipr11 |awk -F "=" '/CLONENUM_START/{print $2}')
cl12=$(($ipcr11 + $uptor11cl))
echo "CLONENUM_START=$cl12" >> ifcfg-$ethport-range$ipr12
echo "$(cat ifcfg-$ethport-range$ipr12)"

echo "#### Range$ipr12 > $cidr12 completed ###"

###############
# RANGE13
###############
read -p "Enter the range value:" ipr13
#
#
touch ifcfg-$ethport-range$ipr13
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr13
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr13
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr13
#
#
firstuseableipr13=$(sipcalc $cidr13 | awk '/Usable range/{print $4}')
mainip13=$(echo $firstuseableipr13 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr13:" mainip13
echo IPADDR_START=$mainip13 >> ifcfg-$ethport-range$ipr13
#
#Last useable IP
lastip13=$(sipcalc $cidr13 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip13" >> ifcfg-$ethport-range$ipr13
#
#NETMASK finder
netmask13=$(sipcalc $cidr13 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask13" >> ifcfg-$ethport-range$ipr13
#
#PREFIX finder
prefix13=$(sipcalc $cidr13 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix13" >> ifcfg-$ethport-range$ipr13
#
#Clonenum calculator
ipcr12=$(sipcalc $cidr12 |awk '/Addresses/ {print $5}')
uptor12cl=$(cat ifcfg-$ethport-range$ipr12 |awk -F "=" '/CLONENUM_START/{print $2}')
cl13=$(($ipcr12 + $uptor12cl))
echo "CLONENUM_START=$cl13" >> ifcfg-$ethport-range$ipr13
echo "$(cat ifcfg-$ethport-range$ipr13)"


echo "#### Range$ipr13 > $cidr13 completed ###"

###############
# RANGE14
###############
read -p "Enter the range value:" ipr14
#
#
touch ifcfg-$ethport-range$ipr14
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr14
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr14
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr14
#
#
firstuseableipr14=$(sipcalc $cidr14 | awk '/Usable range/{print $4}')
mainip14=$(echo $firstuseableipr14 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr14:" mainip14
echo IPADDR_START=$mainip14 >> ifcfg-$ethport-range$ipr14
#
#Last useable IP
lastip14=$(sipcalc $cidr14 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip14" >> ifcfg-$ethport-range$ipr14
#
#NETMASK finder
netmask14=$(sipcalc $cidr14 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask14" >> ifcfg-$ethport-range$ipr14
#
#PREFIX finder
prefix14=$(sipcalc $cidr14 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix14" >> ifcfg-$ethport-range$ipr14
#
#Clonenum calculator
ipcr13=$(sipcalc $cidr13 |awk '/Addresses/ {print $5}')
uptor13cl=$(cat ifcfg-$ethport-range$ipr13 |awk -F "=" '/CLONENUM_START/{print $2}')
cl14=$(($ipcr13 + $uptor13cl))
echo "CLONENUM_START=$cl14" >> ifcfg-$ethport-range$ipr14
echo "$(cat ifcfg-$ethport-range$ipr14)"

echo "#### Range$ipr14 > $cidr14 completed ###"


###############
# RANGE15
###############
read -p "Enter the range value:" ipr15
#
#
touch ifcfg-$ethport-range$ipr15
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr15
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr15
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr15
#
firstuseableipr15=$(sipcalc $cidr15 | awk '/Usable range/{print $4}')
mainip15=$(echo $firstuseableipr15 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr15:" mainip15
echo IPADDR_START=$mainip15 >> ifcfg-$ethport-range$ipr15
#
#Last useable IP
lastip15=$(sipcalc $cidr15 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip15" >> ifcfg-$ethport-range$ipr15
#
#NETMASK finder
netmask15=$(sipcalc $cidr15 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask15" >> ifcfg-$ethport-range$ipr15
#
#PREFIX finder
prefix15=$(sipcalc $cidr15 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix15" >> ifcfg-$ethport-range$ipr15
#
#Clonenum calculator
ipcr14=$(sipcalc $cidr14 |awk '/Addresses/ {print $5}')
uptor14cl=$(cat ifcfg-$ethport-range$ipr14 |awk -F "=" '/CLONENUM_START/{print $2}')
cl15=$(($ipcr14 + $uptor14cl))
echo "CLONENUM_START=$cl15" >> ifcfg-$ethport-range$ipr15
echo "$(cat ifcfg-$ethport-range$ipr15)"


echo "#### Range$ipr15 > $cidr15 completed ###"


###############
# RANGE16
###############
read -p "Enter the range value:" ipr16
#
#
touch ifcfg-$ethport-range$ipr16
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr16
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr16
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr16
#
firstuseableipr16=$(sipcalc $cidr16 | awk '/Usable range/{print $4}')
mainip16=$(echo $firstuseableipr16 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr16:" mainip16
echo IPADDR_START=$mainip16 >> ifcfg-$ethport-range$ipr16
#
#Last useable IP
lastip16=$(sipcalc $cidr16 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip16" >> ifcfg-$ethport-range$ipr16
#
#NETMASK finder
netmask16=$(sipcalc $cidr16 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask16" >> ifcfg-$ethport-range$ipr16
#
#PREFIX finder
prefix16=$(sipcalc $cidr16 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix16" >> ifcfg-$ethport-range$ipr16
#
#Clonenum calculator
ipcr15=$(sipcalc $cidr15 |awk '/Addresses/ {print $5}')
uptor15cl=$(cat ifcfg-$ethport-range$ipr15 |awk -F "=" '/CLONENUM_START/{print $2}')
cl16=$(($ipcr15 + $uptor15cl))
echo "CLONENUM_START=$cl16" >> ifcfg-$ethport-range$ipr16
echo "$(cat ifcfg-$ethport-range$ipr16)"

echo "#### Range$ipr16 > $cidr16 completed ###"

###############
# RANGE17
###############
read -p "Enter the range value:" ipr17
#
#
touch ifcfg-$ethport-range$ipr17
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr17
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr17
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr17
#
#
firstuseableipr17=$(sipcalc $cidr17 | awk '/Usable range/{print $4}')
mainip17=$(echo $firstuseableipr17 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr17:" mainip17
echo IPADDR_START=$mainip17 >> ifcfg-$ethport-range$ipr17
#
#Last useable IP
lastip17=$(sipcalc $cidr17 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip17" >> ifcfg-$ethport-range$ipr17
#
#NETMASK finder
netmask17=$(sipcalc $cidr17 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask17" >> ifcfg-$ethport-range$ipr17
#
#PREFIX finder
prefix17=$(sipcalc $cidr17 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix17" >> ifcfg-$ethport-range$ipr17
#
#Clonenum calculator
ipcr16=$(sipcalc $cidr16 |awk '/Addresses/ {print $5}')
uptor16cl=$(cat ifcfg-$ethport-range$ipr16 |awk -F "=" '/CLONENUM_START/{print $2}')
cl17=$(($ipcr16 + $uptor16cl))
echo "CLONENUM_START=$cl17" >> ifcfg-$ethport-range$ipr17
echo "$(cat ifcfg-$ethport-range$ipr17)"


echo "#### Range$ipr17 > $cidr17 completed ###"


###############
# RANGE18
###############
read -p "Enter the range value:" ipr18
#
#
touch ifcfg-$ethport-range$ipr18
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr18
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr18
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr18
#
firstuseableipr18=$(sipcalc $cidr18 | awk '/Usable range/{print $4}')
mainip18=$(echo $firstuseableipr18 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr18:" mainip18
echo IPADDR_START=$mainip18 >> ifcfg-$ethport-range$ipr18
#
#Last useable IP
lastip18=$(sipcalc $cidr18 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip18" >> ifcfg-$ethport-range$ipr18
#
#NETMASK finder
netmask18=$(sipcalc $cidr18 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask18" >> ifcfg-$ethport-range$ipr18
#
#PREFIX finder
prefix18=$(sipcalc $cidr18 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix18" >> ifcfg-$ethport-range$ipr18
#
#Clonenum calculator
ipcr17=$(sipcalc $cidr17 |awk '/Addresses/ {print $5}')
uptor17cl=$(cat ifcfg-$ethport-range$ipr17 |awk -F "=" '/CLONENUM_START/{print $2}')
cl18=$(($ipcr17 + $uptor17cl))
echo "CLONENUM_START=$cl18" >> ifcfg-$ethport-range$ipr18
echo "$(cat ifcfg-$ethport-range$ipr18)"

echo "#### Range$ipr18 > $cidr18 completed ###"


###############
# RANGE19
###############
read -p "Enter the range value:" ipr19
#
#
touch ifcfg-$ethport-range$ipr19
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr19
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr19
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr19
#
#
firstuseableipr19=$(sipcalc $cidr19 | awk '/Usable range/{print $4}')
mainip19=$(echo $firstuseableipr19 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#read -p "enter First usable IP for cidr19:" mainip19
echo IPADDR_START=$mainip19 >> ifcfg-$ethport-range$ipr19
#
#Last useable IP
lastip19=$(sipcalc $cidr19 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip19" >> ifcfg-$ethport-range$ipr19
#
#NETMASK finder
netmask19=$(sipcalc $cidr19 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask19" >> ifcfg-$ethport-range$ipr19
#
#PREFIX finder
prefix19=$(sipcalc $cidr19 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix19" >> ifcfg-$ethport-range$ipr19
#
#Clonenum calculator
ipcr18=$(sipcalc $cidr18 |awk '/Addresses/ {print $5}')
uptor18cl=$(cat ifcfg-$ethport-range$ipr18 |awk -F "=" '/CLONENUM_START/{print $2}')
cl19=$(($ipcr18 + $uptor18cl))
echo "CLONENUM_START=$cl19" >> ifcfg-$ethport-range$ipr19
echo "$(cat ifcfg-$ethport-range$ipr19)"

echo "#### Range$ipr19 > $cidr19 completed ###"
###############
# RANGE20
###############
read -p "Enter the range value:" ipr20
#
#
touch ifcfg-$ethport-range$ipr20
echo "ONBOOT=yes" >> ifcfg-$ethport-range$ipr20
echo "ARPCHECK=no" >> ifcfg-$ethport-range$ipr20
#
#
read -p "Enter the IP block with CIDR (Eg: xx.xx.xx.xx/24):" cidr20
#
firstuseableipr20=$(sipcalc $cidr20 | awk '/Usable range/{print $4}')
mainip20=$(echo $firstuseableipr20 |awk -F "." '{print$1"."$2"."$3"."$4+1}')
#
#read -p "enter First usable IP for cidr20:" mainip20
echo IPADDR_START=$mainip20 >> ifcfg-$ethport-range$ipr20
#
#Last useable IP
lastip20=$(sipcalc $cidr20 |awk '/Usable/ {print $6}')
echo "IPADDR_END=$lastip20" >> ifcfg-$ethport-range$ipr20
#
#NETMASK finder
netmask20=$(sipcalc $cidr20 |awk 'NR==8 {print $4}')
echo "NETMASK=$netmask20" >> ifcfg-$ethport-range$ipr20
#
#PREFIX finder
prefix20=$(sipcalc $cidr20 | awk '/(bits)/ {print $5}')
echo "PREFIX=$prefix20" >> ifcfg-$ethport-range$ipr20
#
#Clonenum calculator
ipcr19=$(sipcalc $cidr19 |awk '/Addresses/ {print $5}')
uptor19cl=$(cat ifcfg-$ethport-range$ipr19 |awk -F "=" '/CLONENUM_START/{print $2}')
cl20=$(($ipcr19 + $uptor19cl))
echo "CLONENUM_START=$cl20" >> ifcfg-$ethport-range$ipr20
echo "$(cat ifcfg-$ethport-range$ipr20)"

echo "#### Range$ipr20 > $cidr20 completed ###"

###############

else
echo "IP binding script was closed due to entered ScriptInterface $ethport is not connected, so close this script and run this script again with correct interface,Please check with ethtool command to find correct port"
fi
