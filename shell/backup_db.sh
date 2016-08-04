#! /bin/bash
# 游戏数据库备份和恢复
# 如果crontab执行，需要设置path
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
ROOT=`cd $(dirname $0)/..; pwd`
BACKUP_DIR=$ROOT/sql/backup
DB_BACKUP=

RECOVER_DIR=$ROOT/sql/recover
DB_NAME=
DB_USER=root
DB_PASS=`cat /data/save/mysql_root 2> /dev/null`
[ -z "$DB_PASS" ] && DB_PASS=root
SERVER="local"
SHOW_CONFIRM=true
SHOW_VERBOSE=false

# 数据库参数
DB_SRC_ARG=
# 数据库目录
DB_DIR=

# 用法
usage () {
    echo "备份数据库"
    echo "用法:"
    echo "$0 Action"
    echo ""
    echo " Action       - 操作:backup备份;import导入"
    echo " -u User      - 数据库用户"
    echo " -p Pass      - 数据库密码"
    echo " -d Database  - 数据库名(不指定则默认读取common.conf)"
    echo " -f File      - 导入的数据库文件或目录"
    echo " -r File      - 导入的数据库文件或目录(兼容老接口)"
    echo " -o OutFile   - 输出的文件名"
    echo " -q           - 不需要提示"
    echo " -v           - 显示更多信息"
    echo ""
}

# 错误
error() {
    echo "错误:$@"
    exit 1
}

# debug信息
echo2() {
    [ "$SHOW_VERBOSE" = "true" ] && echo $@
}

# 备份本地数据库
backup() {
    if ! (mkdir -p ${BACKUP_DIR} 2> /dev/null); then
        echo "创建备份目录失败，检查权限"
        exit 1
    fi
    if id admin 2> /dev/null ; then
        if !(chown -R admin:admin ${BACKUP_DIR}); then
            echo "修改备份目录权限失败!"
            exit 1
        fi
    fi

    echo2 "备份$DB_NAME 到 ${BACKUP_DIR}/${DB_BACKUP} ... "
    if ! mysqldump -C -q -u ${DB_USER} -p${DB_PASS} ${DB_NAME} > ${BACKUP_DIR}/${DB_BACKUP}; then
        error "备份失败"
    fi
    TAR_FILENAME=`basename ${DB_BACKUP} .dump`.tar.gz
    echo2 "压缩文件 ${BACKUP_DIR}/${TAR_FILENAME} ..."
    if !(cd ${BACKUP_DIR} && tar czf ${TAR_FILENAME} ${DB_BACKUP} && rm -rf ${DB_BACKUP}); then
        error "压缩失败"
    fi
}

# 导入数据库
# 可能是单个文件，可能是目录, 可能是目录对应的压缩文件
import() {
    [ -z "$DB_SRC_ARG" ]  && error "请通过-f指定要导入的数据库tar.gz"

    if [ -f "${DB_SRC_ARG}" ]; then
        if [ "${DB_SRC_ARG#*.}" = "tar.gz" ]; then
            if !( cd `dirname ${DB_SRC_ARG}` && tar xzf `basename ${DB_SRC_ARG}`); then
                error "解压文件${DB_SRC_ARG}失败"
            fi
            TMP_FILE=${DB_SRC_ARG%%.tar.gz}.dump
            TMP_DIR=${DB_SRC_ARG%%.tar.gz}
            if [ -f "${TMP_FILE}" ]; then
                import_file ${TMP_FILE}
            elif [ -d "${TMP_DIR}" ]; then
                import_dir ${TMP_DIR}
                rm -rf ${TMP_DIR}
            fi
        fi
    elif [ -d "${DB_SRC_ARG}" ]; then
        import_dir $DB_SRC_ARG
        rm -rf ${DB_SRC_ARG}
    else
        error "导入数据库使用了未知文件:${DB_SRC_ARG}"
    fi
}


import2() {
    [ -z "$DB_SRC_ARG" ]  && error "请通过-f指定要导入的数据库tar.gz"

    if [ -f "${DB_SRC_ARG}" ]; then
        if [ "${DB_SRC_ARG#*.}" = "tar.gz" ]; then
            if !( cd `dirname ${DB_SRC_ARG}` && tar xzf `basename ${DB_SRC_ARG}`); then
                error "解压文件${DB_SRC_ARG}失败"
            fi
            # TMP_FILE=${DB_SRC_ARG%%.tar.gz}.dump
            # TMP_DIR=${DB_SRC_ARG%%.tar.gz}
            #cd ${DB_SRC_ARG#*.} 
            echo "进入数据库进行导入数据结构与txt ${DB_SRC_ARG%%.*}"
            import_dir ${DB_SRC_ARG%%.*}
            # if [ -f "${TMP_FILE}" ]; then
            #     import_file ${TMP_FILE}
            # elif [ -d "${TMP_DIR}" ]; then
            #     import_dir ${TMP_DIR}
            #     rm -rf ${TMP_DIR}
            # fi
        fi
    elif [ -d "${DB_SRC_ARG}" ]; then
        import_dir $DB_SRC_ARG
        rm -rf ${DB_SRC_ARG}
    else
        error "导入数据库使用了未知文件:${DB_SRC_ARG}"
    fi
}



# 导入数据库(单文件)
# 如果是tar.gz则解压，如果是.dump则直接处理
import_file() {
    DB_FILE=$1

    echo2 "导入$DB_FILE到$DB_NAME ... "
    mysql -u ${DB_USER} -p"${DB_PASS}" << EOF
drop database if exists ${DB_NAME};
create database ${DB_NAME};
use ${DB_NAME};
source ${DB_FILE};
EOF
    if [ $? -ne 0 ]; then
        error "导入数据库失败"
    fi  
}


# 导入数据库(目录)
import_dir() {
    DB_DIR=$1
    if [ -z "$DB_NAME" ]; then
        error "请指定数据库名称! -d "
    fi
    echo2 "导入$DB_DIR到$DB_NAME ... "
    DB_STRUCT_SQL=`find ${DB_DIR} -name "*_db_struc.sql"`
    mysql -u ${DB_USER} -p"${DB_PASS}" << EOF
drop database if exists ${DB_NAME};
create database ${DB_NAME};
use ${DB_NAME};
source ${DB_STRUCT_SQL};
EOF
    if [ $? -ne 0 ]; then
        error "导入创建数据库失败"
    fi  
    # 临时删掉t_log_pay
    #rm -rf ${DB_DIR}/*t_log_pay*
    echo2 "导入数据库 ..."
    # 临时删掉t_log_pay
    #rm -rf ${DB_DIR}/*t_log_pay*
    [ "${SHOW_VERBOSE}" = "false" ] && SILENT=" -s "
    if ! mysqlimport ${SILENT} --local -u ${DB_USER} -p"${DB_PASS}" ${DB_NAME} `find ${DB_DIR} -name "*.txt"`; then
        error "导入数据失败!"
    fi
}

# 显示数据库中的行数
show_rows_num () {
    echo2 "当前数据库${DB_NAME}中表的行数: "
    SQL="USE INFORMATION_SCHEMA; SELECT TABLE_NAME, TABLE_ROWS from TABLES where TABLE_SCHEMA='${DB_NAME}';"
    echo $SQL | mysql -u ${DB_USER} -p${DB_PASS} |
    while read LINE; do
        echo2 $LINE | awk '{printf "%-25s%s\n", $1, $2}'
    done
}

# 解压DB_DIR到指定目录
uncompress_db_dir() {
    DB_TAR=$1
    if [ -f "${DB_TAR}" ]; then
        DB_TAR_DIR=`dirname ${DB_TAR}`
        if !(tar xzf ${DB_TAR} -C ${DB_TAR_DIR}); then
            error "解压db压缩文件包出错!"
        fi
        DB_DIR=${DB_TAR_DIR}/`basename ${DB_TAR} .tar.gz`
        echo ${DB_DIR}
    elif [ -d "${DB_TAR}" ]; then
        echo ${DB_TAR}
    fi
}

# 获取game.conf中某个配置
game_conf_value() {
    KEY=$1
    if [ -n "$KEY" ]; then
        echo `cat ${ROOT}/config/game.conf | grep "${KEY}" | tail -n 1 | sed -e "s/\s*{${KEY},\s*\(.*\)}.*/\1/"`
    fi  
}

# 处理参数
if [ $# -eq 0 ]; then
    usage;
    exit 1
fi 

ACTION=$1;
shift;

# 判断action
if [ ${ACTION} != "import" ] &&
    [ ${ACTION} != "backup" ]; then
    usage
    error "请输入正确的 Action"
fi

while [ $# -ne 0 ] ; do
    PARAM=$1
    shift
    case $PARAM in
        --)break ;;
        -u) DB_USER=$1; shift ;;
        -p) DB_PASS=$1; shift ;;
        -d) DB_NAME=$1; shift ;;
        -f) DB_SRC_ARG=$1; shift;;
        -r) DB_SRC_ARG=$1; shift;;
        -o) DB_BACKUP=$1; shift;;
        -q) SHOW_CONFIRM=false;;
        -v) SHOW_VERBOSE=true;;
        --help|-h) usage; exit 0;;
        *) usage; exit 0;;
    esac
done

# 处理参数
if [ "$ACTION" = "backup" ]; then
    if [ -z "$DB_NAME" ]; then
        PLATFORM=$(game_conf_value platform)
        PLATFORM=${PLATFORM#\"}
        PLATFORM=${PLATFORM%\"}
        SERVER_ID=$(game_conf_value server_id)
        DB_NAME=dzmo_${PLATFORM}_${SERVER_ID}
    fi

elif [ "$ACTION" = "import" ]; then
    if [ -z "$DB_NAME" ]; then
        DB_FILENAME=`basename ${DB_SRC_ARG}`
        DB_NAME=${DB_FILENAME%%_back*}
        DB_NAME=${DB_NAME%%_bak*}
    fi
fi

[ -z "${DB_NAME}" ] && error "请-d指定数据库名称"
[ -z "${DB_BACKUP}" ] && DB_BACKUP=${DB_NAME}_`date +'back_%Y%m%d%H%M'`.dump

if [ "${SHOW_CONFIRM}" = "true" ]; then
    echo -n "确定要对数据库${DB_NAME}执行${ACTION}操作么?(Yes/No): " 
    read SELECT
    if [ "$SELECT" != "Yes" ]; then
        exit 0
    fi
fi

# 执行逻辑
if [ "$ACTION" = "backup" ]; then
    show_rows_num
    backup
elif [ "$ACTION" = "import" ]; then
    import2 
fi
echo "ok"
