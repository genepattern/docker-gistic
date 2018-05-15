#!/bin/sh

#
# parameters to this come from the JobRunner implementation
# for the AWS install
#
# current arg is just job #
#

TEST_ROOT=$PWD
TASKLIB=$TEST_ROOT/src
INPUT_FILE_DIRECTORIES=$TEST_ROOT/data
S3_ROOT=s3://moduleiotest
WORKING_DIR=$TEST_ROOT/job_21111


COMMAND_LINE="gp_gistic2_from_seg -b . -seg $INPUT_FILE_DIRECTORIES/segmentationfile.txt -mk $INPUT_FILE_DIRECTORIES/markersfile.txt -cnv $INPUT_FILE_DIRECTORIES/cnvfile.txt -refgene $INPUT_FILE_DIRECTORIES/Human_Hg19.mat -td 0.1 -js 4 -qvt 0.25 -rx 1 -cap 1.5 -conf 0.90 -genegistic 1 -broad 0 -brien 0.50 -maxseg 2500 -ampeel 0 -scent median -gcm extreme -arb 1 -peak_type robust -fname segmentationfile -genepattern 1 -twosides 0 -saveseg 0 -savedata 0 -smalldisk 0 -smallmem 1 -savegene 1 -v 0 "

mkdir -p $WORKING_DIR
mkdir -p $WORKING_DIR/.gp_metadata
EXEC_SHELL=$WORKING_DIR/.gp_metadata/local_exec.sh

echo "#!/bin/bash\n" > $EXEC_SHELL
echo $COMMAND_LINE >>$EXEC_SHELL
echo "\n " >>$EXEC_SHELL

chmod a+x $EXEC_SHELL


REMOTE_COMMAND="runLocal.sh $TASKLIB $INPUT_FILE_DIRECTORIES $S3_ROOT $WORKING_DIR $EXEC_SHELL"




docker run -v $TASKLIB:$TASKLIB -v $INPUT_FILE_DIRECTORIES:$INPUT_FILE_DIRECTORIES -v $WORKING_DIR:$WORKING_DIR -w $WORKING_DIR genepattern/docker-gistic $REMOTE_COMMAND




