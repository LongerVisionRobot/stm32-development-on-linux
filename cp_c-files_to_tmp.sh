#!/bin/bash
# 拷贝当前目录下所有c文件到/tmp/ccc，然后根据需要拷贝到src文件夹下。方便添加工程。
# copy all the c source file in the current dir to /tmp/ccc
INDENT="        "

if [ "$#" != "1"  ]; then
	echo "${INDENT}copy all the c source file in the current dir to /tmp/ccc"
	echo "${INDENT}USAGE:"
	echo "${INDENT}${INDENT}$0 ."
	exit 1
fi

echo 'Would you like to use iconv to convert from GBK to UTF8?'
echo -n 'if no, just copy your files. (y/n):'
while [ True ];do
	read is_conv
	if [ ${is_conv} != "y" ] && [ ${is_conv} != "n" ];then
		echo "please answer y or n."
		continue
	else
		break
	fi
done	

# Make dir
if [ ! -d "/tmp/ccc" ];then
	mkdir /tmp/ccc
else
	rm -rf /tmp/ccc/*
fi

dir="$@"
find $@ |
	tail -n +2 |
	while read line
	do
		filename=${line##*/}
		# Ignore folders
		if [ -f ${line} ];then
			if [ ${is_conv} = "n" ];then
				echo "bash: cp ${line} /tmp/ccc/"
				cp ${line} /tmp/ccc/
			else
				echo "bash: iconv -f gbk -t utf-8 ${line} > /tmp/ccc/${filename}"
				iconv -f gbk -t utf-8 ${line} > /tmp/ccc/${filename}
			fi
			# check if executed successfully
			if [ $? != "0" ];then
				echo ERROR
				exit 1
			fi
			# Add OBJ to OBJS
			if [ ${filename##*.} = "c" ];then
				echo "OBJS+=${filename%%.c}.o" >> /tmp/ccc/000000000_MAKE_OBJS.txt
			fi
		fi
	done
