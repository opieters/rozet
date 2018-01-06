pushd ../src
python3 create_dtx_file.py

# build docs
pdflatex rozet.dtx && pdflatex rozet.dtx && pdflatex rozet.dtx

# build class
if [ -f rozet.cls ]; then
    rm rozet.cls
fi

pdflatex rozet.ins

popd
