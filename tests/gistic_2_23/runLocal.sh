#!/bin/sh
. ./runConfig.sh

mkdir -p $WORKING_DIR
mkdir -p $WORKING_DIR/.gp_metadata
EXEC_SHELL=$WORKING_DIR/.gp_metadata/local_exec.sh

echo "#!/bin/bash\n" > $EXEC_SHELL
echo $COMMAND_LINE >>$EXEC_SHELL
echo "\n " >>$EXEC_SHELL

chmod a+x $EXEC_SHELL

REMOTE_COMMAND="$EXEC_SHELL"

docker run -v $TASKLIB:$TASKLIB -v $INPUT_FILE_DIRECTORIES:$INPUT_FILE_DIRECTORIES -v $WORKING_DIR:$WORKING_DIR -w $WORKING_DIR genepattern/docker-gistic $REMOTE_COMMAND




