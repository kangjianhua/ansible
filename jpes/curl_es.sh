for i in `cat alllist`;do 
    echo ------$i------
    curl ${i}:9200
    if [ $? != 0 ];then
        sleep 1
        echo "=====================$i error===================="
    fi
done
