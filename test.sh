ENDTIME=$(date +%s)

echo "It takes $(($ENDTIME - $STARTTIME)) seconds before the test.sh run"

export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

pwd=$(pwd)
inputFilePath=$1
rounds=$2
proj_deps_container_name=$3
poolId=$4
args=$5

# echo 'apt-get install -y gcc' && apt-get install -y gcc
# echo 'apt install -y make' && apt install -y make
# echo 'apt install -y perl' && apt install -y perl
# echo 'apt-get install -y subversion' && apt-get install -y subversion; 
# echo 'apt-get install -y cpanminus' && apt-get install -y cpanminus;

start=$(date +%s)

echo 'git clone https://github.com/rjust/defects4j.git && cd defects4j' && git clone https://github.com/rjust/defects4j.git && cd defects4j ;
echo 'cpanm --installdeps . && ./init.sh' && cpanm --installdeps . ;
bash init.sh ;
echo 'PATH=$(pwd)/framework/bin/:$PATH' && PATH=$(pwd)/framework/bin/:$PATH ;

end=$(date +%s)
echo "It takes $(($end - $start)) seconds to install defects4j"
start=$(date +%s)

cd $pwd
mkdir d4jProj && cd d4jProj ;
defects4j checkout -p Csv -v 1f -w csv || (echo "[ERROR] Failed to checkout Csv-1f!" && exit 1 ) ;
defects4j checkout -p JacksonCore -v 1f -w jacksoncore || (echo "[ERROR] Failed to checkout JacksonCore-1f!" && exit 1 ) ;
defects4j checkout -p JacksonXml -v 1f -w jacksonxml || (echo "[ERROR] Failed to checkout JacksonXml-1f!" && exit 1 ) ;
defects4j checkout -p Lang -v 1f -w lang || (echo "[ERROR] Failed to checkout Lang-1f!" && exit 1 ) ;
defects4j checkout -p Cli -v 1f -w cli || (echo "[ERROR] Failed to checkout Cli-1f!" && exit 1 ) ;
defects4j checkout -p JacksonDatabind -v 1f -w jacksondatabind || (echo "[ERROR] Failed to checkout JacksonDatabind-1f!" && exit 1 ) ;
defects4j checkout -p Compress -v 1f -w compress || (echo "[ERROR] Failed to checkout Compress-1f!" && exit 1 ) ;
defects4j checkout -p Jsoup -v 1f -w jsoup || (echo "[ERROR] Failed to checkout Jsoup-1f!" && exit 1 ) ;
defects4j checkout -p Collections -v 25f -w collections || (echo "[ERROR] Failed to checkout Collections-25f!" && exit 1 ) ;
defects4j checkout -p Math -v 1f -w math || (echo "[ERROR] Failed to checkout Math-1f!" && exit 1 ) ;
defects4j checkout -p Chart -v 1f -w chart || (echo "[ERROR] Failed to checkout Chart-1f!" && exit 1 ) ;
defects4j checkout -p Time -v 1f -w time || (echo "[ERROR] Failed to checkout Time-1f!" && exit 1 ) ;
defects4j checkout -p Codec -v 1f -w codec || (echo "[ERROR] Failed to checkout Codec-1f!" && exit 1 ) ;
defects4j checkout -p Gson -v 1f -w gson || (echo "[ERROR] Failed to checkout Gson-1f!" && exit 1 ) ;
defects4j checkout -p JxPath -v 1f -w jxpath || (echo "[ERROR] Failed to checkout JxPath-1f!" && exit 1 ) ;
defects4j checkout -p Mockito -v 13f -w mockito || (echo "[ERROR] Failed to checkout Mockito-13f!" && exit 1 ) ;
defects4j checkout -p Closure -v 1f -w closure || (echo "[ERROR] Failed to checkout Closure-1f!" && exit 1 ) ;
echo 'Finished checking out defects4j projects'
end=$(date +%s)
echo "It takes $(($end - $start)) seconds to check out defects4j projects"
start=$(date +%s)


echo "========== Start testing csv ==========="
cd $pwd && cd d4jProj/csv && time defects4j test
echo "========== Start testing jacksoncore ==========="
cd $pwd && cd d4jProj/jacksoncore && time defects4j test
echo "========== Start testing jacksonxml ==========="
cd $pwd && cd d4jProj/jacksonxml && time defects4j test
echo "========== Start testing lang ==========="
cd $pwd && cd d4jProj/lang && time defects4j test
echo "========== Start testing cli ==========="
cd $pwd && cd d4jProj/cli && time defects4j test
echo "========== Start testing jacksondatabind ==========="
cd $pwd && cd d4jProj/jacksondatabind && time defects4j test
echo "========== Start testing compress ==========="
cd $pwd && cd d4jProj/compress && time defects4j test
echo "========== Start testing jsoup ==========="
cd $pwd && cd d4jProj/jsoup && time defects4j test
echo "========== Start testing collections ==========="
cd $pwd && cd d4jProj/collections && time defects4j test
echo "========== Start testing math ==========="
cd $pwd && cd d4jProj/math && time defects4j test
echo "========== Start testing chart ==========="
cd $pwd && cd d4jProj/chart && time defects4j test
echo "========== Start testing time ==========="
cd $pwd && cd d4jProj/time && time defects4j test
echo "========== Start testing codec ==========="
cd $pwd && cd d4jProj/codec && time defects4j test
echo "========== Start testing gson ==========="
cd $pwd && cd d4jProj/gson && time defects4j test
echo "========== Start testing jxpath ==========="
cd $pwd && cd d4jProj/jxpath && time defects4j test
echo "========== Start testing mockito ==========="
cd $pwd && cd d4jProj/mockito && time defects4j test
echo "========== Start testing closure ==========="
cd $pwd && cd d4jProj/closure && time defects4j test