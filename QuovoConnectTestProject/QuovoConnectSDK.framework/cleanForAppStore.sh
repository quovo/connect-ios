code_sign() {
  # Use the current code_sign_identitiy
  echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
  echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements $1"
  /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements "$1"
}

binary="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/QuovoConnectSDK.framework/QuovoConnectSDK"
# Get architectures for current target binary
binary_archs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | awk '{$1=$1;print}' | rev)"
# Intersect them with the architectures we are building for
intersected_archs="$(echo ${ARCHS[@]} ${binary_archs[@]} | tr ' ' '\n' | sort | uniq -d)"
# If there are no archs supported by this binary then warn the user
if [[ -z "$intersected_archs" ]]; then
echo "warning: [CP] Vendored binary '$binary' contains architectures ($binary_archs) none of which match the current build architectures ($ARCHS)."
exit 1
fi
stripped=""
for arch in $binary_archs; do
if ! [[ "${ARCHS}" == *"$arch"* ]]; then
# Strip non-valid architectures in-place
lipo -remove "$arch" -output "$binary" "$binary" || exit 1
stripped="$stripped $arch"
fi
done
if [[ "$stripped" ]]; then
echo "Stripped $binary of architectures:$stripped"
if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" -a "${CODE_SIGNING_REQUIRED:-}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
      code_sign "${binary}"
fi
fi
