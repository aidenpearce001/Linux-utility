#!/usr/bin/bash
INSTALL_FOLDER="/usr/local"
TARGET_VERSION=${1}
#FILES=$(ls -l $INSTALL_FOLDER | grep cuda)
#echo $FILES
if [[ -z ${TARGET_VERSION} ]]; then
 ls -l "${INSTALL_FOLDER}" | egrep -o "cuda-[0-9]+\\.[0-9]+$" | while read -r line; do
  echo "* ${line}"
  done
elif [[ ! -d "${INSTALL_FOLDER}/cuda-${TARGET_VERSION}" ]]; then
 echo "No installation of CUDA ${TARGET_VERSION} has been found!"
fi

cuda_path="${INSTALL_FOLDER}/cuda-${TARGET_VERSION}"

path_elements=(${PATH//:/ })
new_path="${cuda_path}/bin"
for p in "${path_elements[@]}"; do
    if [[ ! ${p} =~ ^${INSTALL_FOLDER}/cuda ]]; then
        new_path="${new_path}:${p}"
    fi
done

ld_path_elements=(${LD_LIBRARY_PATH//:/ })
new_ld_path="${cuda_path}/lib64:${cuda_path}/extras/CUPTI/lib64"
for p in "${ld_path_elements[@]}"; do
    if [[ ! ${p} =~ ^${INSTALL_FOLDER}/cuda ]]; then
        new_ld_path="${new_ld_path}:${p}"
    fi
done
export CUDA_HOME="${cuda_path}"
export CUDA_ROOT="${cuda_path}"
export LD_LIBRARY_PATH="${new_ld_path}"
export PATH="${new_path}"

echo "Switched to CUDA ${TARGET_VERSION}."
echo $PATH
echo $LD_LIBRARY_PATH
