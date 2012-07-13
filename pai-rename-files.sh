#!/bin/sh

pre_rename() { 
    DATA_ORIG=$1

    (
        cd ${DATA_ORIG}/templates/2009/imagens/ajuda_arquivos
        mv Execu*1.jpg "Execucao_do_PAI_1.jpg"
    )

    (
        cd ${DATA_ORIG}/atividades
        rm -rf 0302HIS001
        mv 1004POR014/1004PORr01409.js 1004POR014/1004POR01409.js
    )
}

rename() {
    DATA_ORIG=$1
    DATA_DEST=${DATA_ORIG}.fixed
    oldnames_atividades=atividades-old-names.tmp.txt
    oldnames_templates=templates-old-names.tmp.txt
    oldnames_scripts=scripts-old-names.tmp.txt
    oldnames_xml=xml-old-names.tmp.txt
    count=2

    echo "Copying files from $DATA_ORIG to $DATA_DEST\nwhile fixing filename case/accents... "
    (cd $DATA_ORIG; find atividades -type f -print0 | xargs -n1 -0 echo | grep -iv "thumbs.db" | grep -v "\~") > $oldnames_atividades
    (cd $DATA_ORIG; find templates -type f -print0 | xargs -n1 -0 echo) > $oldnames_templates
    (cd $DATA_ORIG; find scripts -type f -print0 | xargs -n1 -0 echo) > $oldnames_scripts
    (cd $DATA_ORIG; find xml -type f -print0 | xargs -n1 -0 echo) > $oldnames_xml

    while read atividades_file
    do
        atividades_newfile=`echo $atividades_file | tr "A-Z " "a-z_" | sed -e 's@\([0-9]\{4\}\)cie\([0-9]\{3\}\)@\1CIE\2@g' \
                                                                           -e 's@\([0-9]\{4\}\)geo\([0-9]\{3\}\)@\1GEO\2@g' \
                                                                           -e 's@\([0-9]\{4\}\)his\([0-9]\{3\}\)@\1HIS\2@g' \
                                                                           -e 's@\([0-9]\{4\}\)mat\([0-9]\{3\}\)@\1MAT\2@g' \
                                                                           -e 's@\([0-9]\{4\}\)por\([0-9]\{3\}\)@\1POR\2@g'`
        install -D -m644 "${DATA_ORIG}/$atividades_file" "${DATA_DEST}/$atividades_newfile"
        [ "$atividades_newfile" != "$atividades_file" ] && count=$(( count + 1 ))
    done < $oldnames_atividades

    while read templates_file
    do
        templates_newfile=`echo $templates_file | tr "A-Z " "a-z_"`
        install -D -m644 "${DATA_ORIG}/$templates_file" "${DATA_DEST}/$templates_newfile"
        [ "$templates_newfile" != "$templates_file" ] && count=$(( count + 1 ))
    done < $oldnames_templates

    while read scripts_file
    do
        scripts_newfile=`echo $scripts_file | tr "A-Z " "a-z_"`
        install -D -m644 "${DATA_ORIG}/$scripts_file" "${DATA_DEST}/$scripts_newfile"
        [ "$scripts_newfile" != "$scripts_file" ] && count=$(( count + 1 ))
    done < $oldnames_scripts


    while read xml_file
    do
        xml_newfile=`echo $xml_file | tr "A-Z " "a-z_"`
        install -D -m644 "${DATA_ORIG}/$xml_file" "${DATA_DEST}/$xml_newfile"
        [ "$xml_newfile" != "$xml_file" ] && count=$(( count + 1 ))
    done < $oldnames_xml

    for file in ajuda.html index.html pai.html
    do
        install -D -m644 "${DATA_ORIG}/$file" "${DATA_DEST}/$file"
    done

    rm -f $oldnames_atividades $oldnames_templates $oldnames_scripts $oldnames_xml
    echo "$count files renamed (except directories)."
    sleep 1
    count=0
}

pre_rename $1
rename $1
