VERSION_NUM="$(cat ../version.txt)"
BUILD_DATE=$(date +'%Y%m%d%H%M%S')
if [[ "$(python -V)" =~ "Python 3" ]]; then
	PYTHON_EXECUTABLE="python"
else
	PYTHON_EXECUTABLE="python3"
fi

echo "Cleaning folders..."
bash modules/clean.sh
mkdir dist

echo "Building 1.45 dev006 (64-bit) (development version)..."

# Preparation
echo "Preparing..."

echo "Removing temporary files..."
rm -rf temp/
echo "Copying 1.43 translations and other required files..."
bash modules/copy-base.sh
echo "Copying 1.45-specific translations..."
bash modules/copy-1.45.sh
echo "Extracting 1.45 original files..."
7z x ../_deploy/Domino145_dev006_x86.7z -otemp/_compile
7z x ../_deploy/Domino145_dev006_x64.7z -otemp/_compile -y

echo "Creating compile config file..."
cat >temp/compile-config.json <<EOL
{
	"resourceVersion": "1,45,$VERSION_NUM,0",
	"fullVersion": "1.45 dev006-en.$VERSION_NUM-dev.$BUILD_DATE",
	"buildVersion": "$VERSION_NUM-dev.$BUILD_DATE",
	"executableName": "Domino_Translated_$BUILD_DATE.exe",
	"compilePath": "temp/_compile",
	"supplyTranslationReadme": "true",
	"pythonExecutable": "$PYTHON_EXECUTABLE"
}
EOL
cat temp/compile-config.json

echo "Preparation done!"
# End of preparation

# Compilation
echo "Compiling..."
bash compile-2.sh temp/compile-config.json
echo "Compilation done!"
# End of compilation

# Packing
echo "Copying compilation results..."
cp -r temp/_compile dist
# End of packing

echo "Building done!"