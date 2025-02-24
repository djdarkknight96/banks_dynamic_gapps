#!/sbin/sh

# 
# /system/addon.d/70-gapps.sh
#

# Execute
. /tmp/backuptool.functions

# Functions & variables
file_getprop() {
    grep "^$2" "$1" | cut -d= -f2;
}

rom_build_prop=/system/build.prop
device_architecture="$(file_getprop $rom_build_prop "ro.product.cpu.abilist=")"
# If the recommended field is empty, fall back to the deprecated one
if [ -z "$device_architecture" ]; then
  device_architecture="$(file_getprop $rom_build_prop "ro.product.cpu.abi=")"
fi

list_files() {
cat <<EOF
  app/FaceLock/FaceLock.apk
  app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
  app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
  app/GoogleTTS/GoogleTTS.apk
  etc/permissions/com.google.android.camera.experimental2015.xml
  etc/permissions/com.google.android.dialer.support.xml
  etc/permissions/com.google.android.maps.xml
  etc/permissions/com.google.android.media.effects.xml
  etc/permissions/com.google.widevine.software.drm.xml
  etc/preferred-apps/google.xml
  etc/sysconfig/google.xml
  etc/sysconfig/google_build.xml
  framework/com.google.android.camera.experimental2015.jar
  framework/com.google.android.dialer.support.jar
  framework/com.google.android.maps.jar
  framework/com.google.android.media.effects.jar
  framework/com.google.widevine.software.drm.jar
  lib/libfacelock_jni.so
  lib/libfilterpack_facedetect.so
  lib/libjni_latinime.so
  lib/libjni_latinimegoogle.so
  lib64/libfacelock_jni.so
  lib64/libfilterpack_facedetect.so
  lib64/libjni_latinime.so
  lib64/libjni_latinimegoogle.so
  priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
  priv-app/GoogleFeedback/GoogleFeedback.apk
  priv-app/GoogleLoginService/GoogleLoginService.apk
  priv-app/GoogleOneTimeInitializer/GoogleOneTimeInitializer.apk
  priv-app/GooglePartnerSetup/GooglePartnerSetup.apk
  priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
  priv-app/HotwordEnrollment/HotwordEnrollment.apk
  priv-app/Phonesky/Phonesky.apk
  priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  priv-app/SetupWizard/SetupWizard.apk
  priv-app/Velvet/Velvet.apk
  usr/srec/en-US/action.pumpkin
  usr/srec/en-US/c_fst
  usr/srec/en-US/class_normalizer.mfar
  usr/srec/en-US/CLG.prewalk.fst
  usr/srec/en-US/commands.abnf
  usr/srec/en-US/compile_grammar.config
  usr/srec/en-US/config.pumpkin
  usr/srec/en-US/contacts.abnf
  usr/srec/en-US/CONTACTS.fst
  usr/srec/en-US/CONTACTS.syms
  usr/srec/en-US/dict
  usr/srec/en-US/dictation.config
  usr/srec/en-US/dist_belief
  usr/srec/en-US/dnn
  usr/srec/en-US/endpointer_dictation.config
  usr/srec/en-US/endpointer_model.mmap
  usr/srec/en-US/endpointer_voicesearch.config
  usr/srec/en-US/g2p.data
  usr/srec/en-US/g2p_fst
  usr/srec/en-US/grammar.config
  usr/srec/en-US/graphemes.syms
  usr/srec/en-US/hmmlist
  usr/srec/en-US/hmm_symbols
  usr/srec/en-US/input_mean_std_dev
  usr/srec/en-US/lexicon.U.fst
  usr/srec/en-US/lstm_model.uint8.data
  usr/srec/en-US/magic_mic.config
  usr/srec/en-US/metadata
  usr/srec/en-US/normalizer.mfar
  usr/srec/en-US/norm_fst
  usr/srec/en-US/offensive_word_normalizer.mfar
  usr/srec/en-US/phonelist
  usr/srec/en-US/phonelist.syms
  usr/srec/en-US/phonemes.syms
  usr/srec/en-US/rescoring.fst.louds
  usr/srec/en-US/semantics.pumpkin
  usr/srec/en-US/voice_actions.config
  usr/srec/en-US/voice_actions.compiler.config
  usr/srec/en-US/wordlist.syms
  vendor/lib/libfrsdk.so
  vendor/lib64/libfrsdk.so
  vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.8/landmark_group_meta_data.bin
  vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.8/left_eye-y0-yi45-p0-pi45-r0-ri20.lg_32-tree7-wmd.bin
  vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.8/nose_base-y0-yi45-p0-pi45-r0-ri20.lg_32-tree7-wmd.bin
  vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.8/right_eye-y0-yi45-p0-pi45-r0-ri20.lg_32-3-tree7-wmd.bin
  vendor/pittpatt/models/detection/yaw_roll_face_detectors.7.1/head-y0-yi45-p0-pi45-r0-ri30.4a-v24-tree7-2-wmd.bin
  vendor/pittpatt/models/detection/yaw_roll_face_detectors.7.1/head-y0-yi45-p0-pi45-rn30-ri30.5-v24-tree7-2-wmd.bin
  vendor/pittpatt/models/detection/yaw_roll_face_detectors.7.1/head-y0-yi45-p0-pi45-rp30-ri30.5-v24-tree7-2-wmd.bin
  vendor/pittpatt/models/detection/yaw_roll_face_detectors.7.1/pose-r.8.1.bin
  vendor/pittpatt/models/detection/yaw_roll_face_detectors.7.1/pose-y-r.8.1.bin
  vendor/pittpatt/models/recognition/face.face.y0-y0-71-N-tree_7-wmd.bin
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Re-remove conflicting apks
    rm -rf /system/app/BrowserProviderProxy
    rm -rf /system/app/PartnerBookmarksProvider
    rm -rf /system/app/Provision
    rm -rf /system/app/QuickSearchBox
    rm -rf /system/priv-app/BrowserProviderProxy
    rm -rf /system/priv-app/PartnerBookmarksProvider
    rm -rf /system/priv-app/Provision
    rm -rf /system/priv-app/QuickSearchBox
    
    # Make required symbolic links
    if (echo "$device_architecture" | grep -i "armeabi" | grep -qiv "arm64"); then
      mkdir -p /system/app/FaceLock/lib/arm
      mkdir -p /system/app/LatinIME/lib/arm
      ln -sfn /system/lib/libfacelock_jni.so /system/app/FaceLock/lib/arm/libfacelock_jni.so
      ln -sfn /system/lib/libjni_latinime.so /system/app/LatinIME/lib/arm/libjni_latinime.so
      ln -sfn /system/lib/libjni_latinimegoogle.so /system/app/LatinIME/lib/arm/libjni_latinimegoogle.so
    elif (echo "$device_architecture" | grep -qi "arm64"); then
      mkdir -p /system/app/FaceLock/lib/arm64
      mkdir -p /system/app/LatinIME/lib/arm64
      ln -sfn /system/lib64/libfacelock_jni.so /system/app/FaceLock/lib/arm64/libfacelock_jni.so
      ln -sfn /system/lib64/libjni_latinime.so /system/app/LatinIME/lib/arm64/libjni_latinime.so
      ln -sfn /system/lib64/libjni_latinimegoogle.so /system/app/LatinIME/lib/arm64/libjni_latinimegoogle.so
    fi
  ;;
esac
