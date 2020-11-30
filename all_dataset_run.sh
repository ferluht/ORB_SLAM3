#!/bin/sh
DATA_ROOT=$1
OUTPUT_ROOT=$2
VOCAB_PATH="Vocabulary/ORBvoc.txt"
#cd [!!! path to orbslam lib directory in docker]

for SCAN_PATH in $DATA_ROOT/*; do
    echo $SCAN_PATH
    if [ -d "$SCAN_PATH" ]; then
        SCAN_NAME=$(basename -- "$SCAN_PATH")
        OUTPUT_PATH="$OUTPUT_ROOT/$SCAN_NAME"
        if [ -d "$OUTPUT_PATH" ]; then
            continue
        fi
        mkdir -p $OUTPUT_PATH
        echo "Processing scan '$SCAN_NAME' ('$SCAN_PATH') > '$OUTPUT_PATH'..."
        CONFIG_PATH="S20.yaml"
        #TIMESTAMPS_PATH="$SCAN_PATH/mav0/cam0/timestamps.txt"
        #CMD="./Examples/Monocular/mono_euroc $VOCAB_PATH $CONFIG_PATH $SCAN_PATH $TIMESTAMPS_PATH"
        ASSOCIATIONS_PATH="$SCAN_PATH/associations.txt"
        CMD="./Examples/RGB-D/rgbd_tum $VOCAB_PATH $CONFIG_PATH $SCAN_PATH $ASSOCIATIONS_PATH"
        echo "Running '$CMD' ..."
        $CMD
        if [ -f "CameraTrajectory.txt" ]; then
             mv "CameraTrajectory.txt" $OUTPUT_PATH
             mv "KeyFrameTrajectory.txt" $OUTPUT_PATH
        fi
    fi
done

