#!/bin/sh
#
# &copy; 2017-2018 Regents of the University of California and the Broad Institute. All rights reserved.
#
. ./runConfig.sh

# set gp_metadata if unset
: ${GP_METADATA_DIR=$WORKING_DIR/.gp_metadata}
: ${STDOUT_FILENAME=stdout.txt}
: ${STDERR_FILENAME=stderr.txt}
: ${EXITCODE_FILENAME=$GP_METADATA_DIR/exit_code.txt}
: ${CONTAINER_OVERRIDE_MEMORY=2400}
: ${S3_ROOT=s3://moduleiotest}
: ${JOB_QUEUE=TedTest}

cd $TEST_ROOT

# ##### NEW PART FOR SCRIPT INSTEAD OF COMMAND LINE ################################
# Make the input file directory since we need to put the script to execute in it
mkdir -p $GP_METADATA_DIR

EXEC_SHELL=$GP_METADATA_DIR/exec.sh
echo "#!/bin/bash\n" > $EXEC_SHELL
echo " cd $WORKING_DIR  " >> $EXEC_SHELL
echo "\n" >> $EXEC_SHELL

# for debugging you may add things at this point to have them run before the module inside the innermost container
echo "# add stuff here to run on innermost container  " >> $EXEC_SHELL
echo "\n" >> $EXEC_SHELL
# echo "Rscript /build/source/installPackages.R $TASKLIB/r.package.info" >> $EXEC_SHELL
# echo  "\n" >> $EXEC_SHELL
echo $COMMAND_LINE >>$EXEC_SHELL 
echo "\n " >>$EXEC_SHELL 
chmod a+rwx $EXEC_SHELL
chmod -R a+rwx $WORKING_DIR
REMOTE_COMMAND=$EXEC_SHELL

#echo "wrote $EXEC_SHELL"
SYNCH_SHELL=$GP_METADATA_DIR/aws-sync-from-s3.sh

# create the aws-synch-from S3.sh script
echo "# sync stuff into outer container \n" >> $SYNCH_SHELL
echo "aws s3 sync $S3_ROOT$WORKING_DIR /local$WORKING_DIR \n"   >>$SYNCH_SHELL
echo "aws s3 sync $S3_ROOT$INPUT_FILE_DIRECTORIES /local$INPUT_FILE_DIRECTORIES \n"   >>$SYNCH_SHELL
echo "aws s3 sync $S3_ROOT$TASKLIB  /local$TASKLIB  \n"   >>$SYNCH_SHELL
echo "aws s3 sync $S3_ROOT$GP_METADATA_DIR  /localGP_METADATA_DIR  \n"   >>$SYNCH_SHELL
echo "\n " >>$SYNCH_SHELL 

#
# Copy the input files to S3 using the same path
#
aws s3 sync $INPUT_FILE_DIRECTORIES $S3_ROOT$INPUT_FILE_DIRECTORIES --profile genepattern
aws s3 sync $TASKLIB $S3_ROOT$TASKLIB --profile genepattern
aws s3 sync $WORKING_DIR $S3_ROOT$WORKING_DIR --profile genepattern 
aws s3 sync $GP_METADATA_DIR $S3_ROOT$GP_METADATA_DIR --profile genepattern 

######### end new part for script #################################################
#  {name=MOD_LIBS, value=$MOD_LIBS},  need for R
aws batch submit-job \
      --job-name $JOB_ID \
      --job-queue $JOB_QUEUE \
      --container-overrides "memory=$CONTAINER_OVERRIDE_MEMORY,environment=[ {name=GP_DOCKER_CONTAINER, value=$DOCKER_CONTAINER}, {name=GP_METADATA_DIR,value=$GP_METADATA_DIR},{name=GP_S3_ROOT,value=$S3_ROOT},{name=GP_WORKING_DIR,value=$WORKING_DIR},{name=GP_MODULE_SPECIFIC_CONTAINER,value=liefeld/test_new_api}, {name=GP_DOCKER_MOUNT_POINTS, value=$INPUT_FILE_DIRECTORIES:$WORKING_DIR:$TASKLIB},{name=GP_TASKLIB, value=$TASKLIB}]"  \
      --job-definition $JOB_DEFINITION_NAME \
      --profile genepattern


