
cd depends;
make download;make download-osx;make download-win;make download-linux;
make HOST=x86_64-pc-linux-gnu;
make HOST=i686-pc-linux-gnu;
make HOST=x86_64-w64-mingw32;
make HOST=i686-w64-mingw32;
make HOST=aarch64-linux-gnu;
make HOST=arm-linux-gnueabihf;
make HOST=x86_64-apple-darwin11;
make HOST=host-platform-triplet;

cd ..;
# x86_64-pc-linux-gnu
./autogen.sh;
./configure --prefix=`pwd`/depends/x86_64-pc-linux-gnu
make
mkdir -p build/v0.0.0.1/x86_64-pc-linux-gnu;
cp ./src/mnpcoind ./build/v0.0.0.1/x86_64-pc-linux-gnu/mnpcoind;
cp ./src/qt/mnpcoin-qt ./build/v0.0.0.1/x86_64-pc-linux-gnu/mnpcoin-qt;
strip ./build/v0.0.0.1/x86_64-pc-linux-gnu/mnpcoind
strip ./build/v0.0.0.1/x86_64-pc-linux-gnu/mnpcoin-qt
## created detached signatures
cd build/v0.0.0.1/x86_64-pc-linux-gnu;

gpg --detach-sign -o mnpcoin-qt.sig mnpcoin-qt
gpg --verify mnpcoin-qt.sig

gpg --armor --detach-sign -o mnpcoind.sig mnpcoind
gpg --verify mnpcoind.sig
cd ../../..;

make clean;cd src;make clean;cd ..;

# i686-pc-linux-gnu
./autogen.sh;
./configure --prefix=`pwd`/depends/i686-pc-linux-gnu
make
mkdir -p build/v0.0.0.1/i686-pc-linux-gnu;
cp ./src/mnpcoind ./build/v0.0.0.1/i686-pc-linux-gnu/mnpcoind;
cp ./src/qt/mnpcoin-qt ./build/v0.0.0.1/i686-pc-linux-gnu/mnpcoin-qt;
strip ./build/v0.0.0.1/i686-pc-linux-gnu/mnpcoind
strip ./build/v0.0.0.1/i686-pc-linux-gnu/mnpcoin-qt
# created detached signatures
cd build/v0.0.0.1/i686-pc-linux-gnu;

gpg --detach-sign -o mnpcoin-qt.sig mnpcoin-qt
gpg --verify mnpcoin-qt.sig

gpg --armor --detach-sign -o mnpcoind.sig mnpcoind
gpg --verify mnpcoind.sig
cd ../../..;

make clean;cd src;make clean;cd ..;

# x86_64-w64-mingw32
./autogen.sh;
./configure --prefix=`pwd`/depends/x86_64-w64-mingw32
make HOST=x86_64-w64-mingw32

mkdir -p build/v0.0.0.1/x86_64-w64-mingw32;
cp ./src/mnpcoind.exe ./build/v0.0.0.1/x86_64-w64-mingw32/mnpcoind.exe;
cp ./src/qt/mnpcoin-qt.exe ./build/v0.0.0.1/x86_64-w64-mingw32/mnpcoin-qt.exe;
strip ./build/v0.0.0.1/x86_64-w64-mingw32/mnpcoind.exe
strip ./build/v0.0.0.1/x86_64-w64-mingw32/mnpcoin-qt.exe
## created detached signatures
cd build/v0.0.0.1/x86_64-w64-mingw32;


##/C= 	Country 	GB
##/ST= 	State 	London
##/L= 	Location 	London
##/O= 	Organization 	Global Security
##/OU= 	Organizational Unit 	IT Department
##/CN= 	Common Name 	example.com

openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./mnpcoin-qt-selfsigned.key -out ./mnpcoin-qt-selfsigned.crt -subj "/C=AT/ST=Vienna/L=Vienna/O=Development/OU=Core Development/CN=emnpcoincore.com";
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./mnpcoind-selfsigned.key -out ./mnpcoind-selfsigned.crt -subj "/C=AT/ST=Vienna/L=Vienna/O=Development/OU=Core Development/CN=emnpcoincore.com";

osslsigncode sign -certs mnpcoin-qt-selfsigned.crt -key mnpcoin-qt-selfsigned.key \
        -n "MNPCoin Core source code" -i http://www.mnpcoincore.com/ \
        -t http://timestamp.verisign.com/scripts/timstamp.dll \
        -in mnpcoin-qt.exe -out mnpcoin-qt-signed.exe

osslsigncode sign -certs mnpcoind-selfsigned.crt -key mnpcoind-selfsigned.key \
        -n "MNPCoin Core source code" -i http://www.mnpcoincore.com/ \
        -t http://timestamp.verisign.com/scripts/timstamp.dll \
        -in mnpcoind.exe -out mnpcoind-signed.exe

mv mnpcoin-qt-signed.exe mnpcoin-qt.exe;
mv mnpcoind-signed.exe mnpcoind.exe;

cd ../../..;
make clean;cd src;make clean;cd ..;

# i686-w64-mingw32
./autogen.sh;
./configure --prefix=`pwd`/depends/i686-w64-mingw32
make HOST=i686-w64-mingw32

mkdir -p build/v0.0.0.1/i686-w64-mingw32;
cp ./src/mnpcoind.exe ./build/v0.0.0.1/i686-w64-mingw32/mnpcoind.exe;
cp ./src/qt/mnpcoin-qt.exe ./build/v0.0.0.1/i686-w64-mingw32/mnpcoin-qt.exe;
strip ./build/v0.0.0.1/i686-w64-mingw32/mnpcoind.exe
strip ./build/v0.0.0.1/i686-w64-mingw32/mnpcoin-qt.exe
## created detached signatures
cd build/v0.0.0.1/i686-w64-mingw32;

##/C= 	Country 	GB
##/ST= 	State 	London
##/L= 	Location 	London
##/O= 	Organization 	Global Security
##/OU= 	Organizational Unit 	IT Department
##/CN= 	Common Name 	example.com

openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./mnpcoin-qt-selfsigned.key -out ./mnpcoin-qt-selfsigned.crt -subj "/C=AT/ST=Vienna/L=Vienna/O=Development/OU=Core Development/CN=emnpcoincore.com";
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./mnpcoind-selfsigned.key -out ./mnpcoind-selfsigned.crt -subj "/C=AT/ST=Vienna/L=Vienna/O=Development/OU=Core Development/CN=emnpcoincore.com";

osslsigncode sign -certs mnpcoin-qt-selfsigned.crt -key mnpcoin-qt-selfsigned.key \
        -n "MNPCoin Core source code" -i http://www.mnpcoincore.com/ \
        -t http://timestamp.verisign.com/scripts/timstamp.dll \
        -in mnpcoin-qt.exe -out mnpcoin-qt-signed.exe

osslsigncode sign -certs mnpcoind-selfsigned.crt -key mnpcoind-selfsigned.key \
        -n "MNPCoin Core source code" -i http://www.mnpcoincore.com/ \
        -t http://timestamp.verisign.com/scripts/timstamp.dll \
        -in mnpcoind.exe -out mnpcoind-signed.exe

mv mnpcoin-qt-signed.exe mnpcoin-qt.exe;
mv mnpcoind-signed.exe mnpcoind.exe;

cd ../../..;
make clean;cd src;make clean;cd ..;

./autogen.sh;
./configure --prefix=`pwd`/depends/arm-linux-gnueabihf
make HOST=arm-linux-gnueabihf;

mkdir -p build/v0.0.0.1/arm-linux-gnueabihf;
cp ./src/mnpcoind ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoind;
cp ./src/qt/mnpcoin-qt ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoin-qt;
strip ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoind
strip ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoin-qt
# created detached signatures
cd build/v0.0.0.1/arm-linux-gnueabihf;

gpg --detach-sign -o mnpcoin-qt.sig mnpcoin-qt
gpg --verify mnpcoin-qt.sig

gpg --armor --detach-sign -o mnpcoind.sig mnpcoind
gpg --verify mnpcoind.sig
cd ../../..;


make clean;cd src;make clean;cd ..;

# aarch64-linux-gnu
./autogen.sh;
./configure --prefix=`pwd`/depends/aarch64-linux-gnu
make HOST=aarch64-linux-gnu;

mkdir -p build/v0.0.0.1/aarch64-linux-gnu;
cp ./src/mnpcoind ./build/v0.0.0.1/aarch64-linux-gnu/mnpcoind;
cp ./src/qt/mnpcoin-qt ./build/v0.0.0.1/aarch64-linux-gnu/mnpcoin-qt;
strip ./build/v0.0.0.1/aarch64-linux-gnu/mnpcoind
strip ./build/v0.0.0.1/aarch64-linux-gnu/mnpcoin-qt
# created detached signatures
cd build/v0.0.0.1/aarch64-linux-gnu;

gpg --detach-sign -o mnpcoin-qt.sig mnpcoin-qt
gpg --verify mnpcoin-qt.sig

gpg --armor --detach-sign -o mnpcoind.sig mnpcoind
gpg --verify mnpcoind.sig
cd ../../..;

# arm-linux-gnueabihf
./autogen.sh;
./configure --prefix=`pwd`/depends/arm-linux-gnueabihf
make
mkdir -p build/v0.0.0.1/arm-linux-gnueabihf;
cp ./src/mnpcoind ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoind;
cp ./src/qt/mnpcoin-qt ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoin-qt;
strip ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoind
strip ./build/v0.0.0.1/arm-linux-gnueabihf/mnpcoin-qt
## created detached signatures
cd build/v0.0.0.1/arm-linux-gnueabihf;

gpg --detach-sign -o mnpcoin-qt.sig mnpcoin-qt
gpg --verify mnpcoin-qt.sig

gpg --armor --detach-sign -o mnpcoind.sig mnpcoind
gpg --verify mnpcoind.sig
cd ../../..;

make clean;cd src;make clean;cd ..;

# host-platform-triplet
./autogen.sh;
./configure --prefix=`pwd`/depends/host-platform-triplet
make
mkdir -p build/v0.0.0.1/host-platform-triplet;
cp ./src/mnpcoind ./build/v0.0.0.1/host-platform-triplet/mnpcoind;
cp ./src/qt/mnpcoin-qt ./build/v0.0.0.1/host-platform-triplet/mnpcoin-qt;
strip ./build/v0.0.0.1/host-platform-triplet/mnpcoind
strip ./build/v0.0.0.1/host-platform-triplet/mnpcoin-qt
## created detached signatures
cd build/v0.0.0.1/host-platform-triplet;

gpg --detach-sign -o mnpcoin-qt.sig mnpcoin-qt
gpg --verify mnpcoin-qt.sig

gpg --armor --detach-sign -o mnpcoind.sig mnpcoind
gpg --verify mnpcoind.sig
cd ../../..;

make clean;cd src;make clean;cd ..;

# x86_64-apple-darwin11
./autogen.sh;
./configure --prefix=`pwd`/depends/x86_64-apple-darwin11
make HOST=x86_64-apple-darwin11;

#mkdir -p build/v0.0.0.1/x86_64-apple-darwin11;
#cp ./src/mnpcoind ./build/v0.0.0.1/x86_64-apple-darwin11/mnpcoind;
#cp ./src/qt/mnpcoin-qt ./build/v0.0.0.1/x86_64-apple-darwin11/mnpcoin-qt;
#strip ./build/v0.0.0.1/x86_64-apple-darwin11/mnpcoind
#strip ./build/v0.0.0.1/x86_64-apple-darwin11/mnpcoin-qt
# created detached signatures
#cd build/v0.0.0.1/x86_64-apple-darwin11;

#gpg --detach-sign -o mnpcoin-qt.sig mnpcoin-qt
#gpg --verify mnpcoin-qt.sig

#gpg --armor --detach-sign -o mnpcoind.sig mnpcoind
#gpg --verify mnpcoind.sig
#cd ../../..;


#make clean;cd src;make clean;cd ..;