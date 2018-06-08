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

JOB_ID=GISTIC_dind_$1
JOB_QUEUE=TedTest
JOB_DEFINITION_NAME=S3ModuleWrapper
DOCKER_CONTAINER=genepattern/docker-gistic
RUNDOCKER_SCRIPT=runLocal.sh


COMMAND_LINE="gp_gistic2_from_seg -b . -seg $INPUT_FILE_DIRECTORIES/segmentationfile.txt -mk $INPUT_FILE_DIRECTORIES/markersfile.txt -cnv $INPUT_FILE_DIRECTORIES/cnvfile.txt -refgene $INPUT_FILE_DIRECTORIES/Human_Hg19.mat -td 0.1 -js 4 -qvt 0.25 -rx 1 -cap 1.5 -conf 0.90 -genegistic 1 -broad 0 -brien 0.50 -maxseg 2500 -ampeel 0 -scent median -gcm extreme -arb 1 -peak_type robust -fname segmentationfile -genepattern 1 -twosides 0 -saveseg 0 -savedata 0 -smalldisk 0 -smallmem 1 -savegene 1 -v 0 "


docker run -v $TASKLIB:$TASKLIB -v $INPUT_FILE_DIRECTORIES:$INPUT_FILE_DIRECTORIES -v $WORKING_DIR:$WORKING_DIR -w $WORKING_DIR genepattern/docker-gistic $REMOTE_COMMAND




