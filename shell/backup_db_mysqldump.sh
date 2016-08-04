#! /bin/bash
# 使用mysqldump备份线上数据库(包括admin和game数据库)
# 可以备份多个数据库
# eg：
# 0 4 * * * /bin/bash /xxx/backup_db_mysqldump.sh 

# 如果crontab执行，需要设置path
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

ROOT=`cd $(dirname $0)/..; pwd`
BACKUP_DIR=/data/backup/db
SERVER_BASE_DIR=/data/server
DB_USER=root
DB_PASS=`cat /data/save/mysql_root 2> /dev/null`
[ -z "$DB_PASS" ] && DB_PASS=root
DB_NAME=
# 匹配admin库和game库
MATCH_PREFIX=dzmo_.*_.*
# 当前时间
NOW=`date +'%Y%m%d-%H%M'`
# 合服备份admin库
MERGE_ADMIN=false

# 用法
usage () {
    echo "备份线上数据库"
    echo "用法:"
    echo ""
    echo " -u User          - 数据库用户"
    echo " -p Pass          - 数据库密码"
    echo " -d Database      - 数据库名(默认匹配${MATCH_PREFIX}的所有数据库)"
    echo " -t               - 备份到指定目录"
    echo " --merge_admin    - 指定是合服备份admin库"
    echo ""
}

error() {
    echo $1
    exit 1
}

# 备份表结构
backup_db_struc() {
    ONE_DB_NAME=$1
    #echo "mysqldump -u${DB_USER} -p${DB_PASS} -d ${ONE_DB_NAME} > ${WORK_DIR}/${ONE_DB_NAME}_db_struc.sql"
    if !(mysqldump -u${DB_USER} -p${DB_PASS} -d ${ONE_DB_NAME} > ${WORK_DIR}/${ONE_DB_NAME}_db_struc.sql); then
        error "备份${DB_NAME}表结构 到目录${WORK_DIR}失败"
    fi    
}

# 备份表
backup_db_data() {
    ONE_DB_NAME=$1
    #echo "mysqldump -u${DB_USER} -p${DB_PASS} -T ${WORK_DIR}/ ${ONE_DB_NAME}"
    if !(mysqldump --default-character-set=binary -F -u${DB_USER} -p${DB_PASS} -T ${WORK_DIR}/ ${ONE_DB_NAME}); then
        error "备份${DB_NAME}表内容 到目录${WORK_DIR}失败"
    fi
}

# 打包数据
tar_backup() {
    # 合服的话，额外在打包多一个tar包，只有2个文件
    if [ $MERGE_ADMIN == "true" ]; then
        #echo "cd ${WORK_DIR}/../ && tar czf ${TAR_FILE}_merge.tar.gz ${TAR_FILE}/t_log_pay* ${TAR_FILE}/t_log_register*"
        if !(cd ${WORK_DIR}/../ && tar czf ${TAR_FILE}_merge.tar.gz ${TAR_FILE}/t_log_pay* ${TAR_FILE}/t_log_register*); then
            error "打包合服备份数据失败!"
        fi
    fi

    #echo "cd ${WORK_DIR}/../ && tar czf ${TAR_FILE}.tar.gz ${TAR_FILE} && rm -rf ${TAR_FILE}"
    if !(cd ${WORK_DIR}/../ && tar czf ${TAR_FILE}.tar.gz ${TAR_FILE} && rm -rf ${TAR_FILE}); then
        error "打包备份数据失败!"
    fi
}

# 匹配同一机器下数据库列表
get_db_list() {
    mysql -u${DB_USER} -p${DB_PASS} -e "show databases;" | grep ${MATCH_PREFIX}
}


# 处理参数
while [ $# -ne 0 ] ; do
    PARAM=$1
    shift
    case $PARAM in
        --)break ;;
        -u) DB_USER=$1; shift ;;
        -p) DB_PASS=$1; shift ;;
        -d) DB_NAME=$1; shift ;;
        -t) BACKUP_DIR=$1; shift ;;
        --merge_admin) MERGE_ADMIN=true; shift ;;
        --help|-h) usage; exit 0;;
        *) usage; exit 0;;
    esac
done

if [ -z ${DB_NAME} ]; then
    DB_LIST=$(get_db_list)
else
    DB_LIST=${DB_NAME}
fi

# 备份所有的数据库
for ONE_DB in ${DB_LIST}; do
    if [ "${ONE_DB:0:10}" = "dzmo_admin" ]; then
        TMP_STR=${ONE_DB:11}
    else
        TMP_STR=${ONE_DB:5}
    fi
    PLATFORM=${TMP_STR%_*}
    SERVER_ID=${TMP_STR##*_}
    #echo ">>>>>>> ${TMP_STR} >>>>  ${PLATFORM} >> ${SERVER_ID}"

    # 生成work_dir
    TAR_FILE=${ONE_DB}_bak_${NOW}
    # /data/backup/db/haoyue_1/dzmo_haoyue_1_back_201411181105
    WORK_DIR=${BACKUP_DIR}/${PLATFORM}_${SERVER_ID}/${TAR_FILE}
    #echo ${WORK_DIR}

    if [[ ( -z ${DB_NAME} && -d "${SERVER_BASE_DIR}/${PLATFORM}_s${SERVER_ID}" ) || ( -n ${DB_NAME} ) ]]; then
    	if ! (mkdir -p ${WORK_DIR} 2> /dev/null); then
	        error "创建数据库备份目录:${WORK_DIR}失败，检查权限"
	    fi
	
	    # 设置权限
	    if !(chmod 777 ${WORK_DIR}); then
	        error "修改目录${WORK_DIR}权限失败"
	    fi
    
        backup_db_struc ${ONE_DB}
        backup_db_data ${ONE_DB}
        tar_backup
        echo "ok:${TAR_FILE}.tar.gz"

        # sleep 10秒钟
        sleep 10
    fi

    # 删除过旧的备份文件（30天前）
    cd ${BACKUP_DIR}/${PLATFORM}_${SERVER_ID}/
    find ./ -name "dzmo_*.tar.gz" -ctime +30 -type f -exec rm -rf {} \;
done
