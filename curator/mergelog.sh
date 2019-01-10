#!/bin/bash
#IFS=$'\n'
#OLDIFS="$IFS"

label=ptlog

home=/workspace/ansible/curator

#总的index日志信息
tmp=/tmp/curator_cli_show_indices

#默认的config文件
defconfig="$home"/mergelog/default.yml
#合并上个月的日志
#month=`date -d last-month +%Y.%m`
#合并本月的日志
month=`date  +%Y.%m`
#不合并当天日志
today=`date +%e`
#获取index日志列表
curator_cli show_indices |grep "$label"|grep "$month" > "$tmp"

#indexs=`awk -F"-$(date +%Y)" '{print $1}' "$tmp" |sort|uniq`
indexs=warehouse-dd
for index in `echo $indexs`;do
	wc=`grep "$index"-"$month" $tmp|wc -l`
	if [ $wc -gt 1 ];then
		days=`grep ""$index"-"$month"" $tmp|awk -F""$month"." 'NF==2{print $NF}'|grep -v "$today"|sort`
		for day in `echo $days`;do
			configfile="$home"/mergelog/"$index".yml
			ps aux|grep -v grep |grep "curator" |grep "$index"
			if [ "$?" -eq 0 ];then
				exit 0
			else
				cp $defconfig $configfile
				sed -i "s#default#"$index"-"$month"#g" $configfile
				sed -i "s#day#"$day"#g" $configfile
				cd "$home"
				curator --config mergelog/curator.yml "$configfile"
			fi
		done
		#rm -f "$configfile"
	fi
done
