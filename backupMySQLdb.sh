#!/bin/bash

#################### SCRIPT PARA BACKUP MYSQL / SCRIPT FOR MYSQL BACKUP ####################

# Definindo parametros do MySQL
#echo "  -- Definindo parametros do MySQL ..."
DB_NAME=''
DB_USER=''
DB_PASS=''

# Definindo parametros do sistema
#echo "  -- Definindo parametros do sistema ..."
DATE=`date +%Y-%m-%d`
MYSQLDUMP=/usr/bin/mysqldump
BACKUP_DIR=/root/bkp
BACKUP_NAME=$DB_NAME-$DATE.sql
BACKUP_TAR=$DB_NAME-$DATE.tar

#Gerando arquivo sql
echo "  -- Gerando Backup da base de dados $DB_NAME em $BACKUP_DIR/$BACKUP_NAME ..."
$MYSQLDUMP $DB_NAME -u $DB_USER -p$DB_PASS > $BACKUP_DIR/$BACKUP_NAME

# Compactando arquivo em tar
#echo "  -- Compactando arquivo em tar ..."
tar -cf $BACKUP_DIR/$BACKUP_TAR -C $BACKUP_DIR $BACKUP_NAME

# Compactando arquivo em bzip2
#echo "  -- Compactando arquivo em bzip2 ..."
bzip2 $BACKUP_DIR/$BACKUP_TAR

# Excluindo arquivos desnecessarios
echo "  -- Excluindo arquivos desnecessarios ..."
#rm -rf $BACKUP_DIR/$BACKUP_NAME

# Enviando pro google Drive
#/usr/local/bin/gdrive upload -p <-- GOOGLE DRIVE API KEY --> $BACKUP_DIR/$BACKUP_TAR.bz2
/usr/bin/rclone copy --update --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s $BACKUP_DIR/$BACKUP_TAR.bz2 "gdrive:bkps mysql"

# Excluindo o backup local
rm -rf $BACKUP_DIR/$BACKUP_TAR
rm -rf $BACKUP_DIR/$BACKUP_NAME
rm -rf $BACKUP_DIR/$BACKUP_TAR.bz2
