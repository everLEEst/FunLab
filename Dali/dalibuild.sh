#!/bin/sh
#authored by @everLEEst(dltkdgus1764@gmail.com)
 
DIR="dali-core dali-adaptor dali-toolkit dali-csharp-binder"
TBRANCH="devel/master"

for i in $DIR
do
  target=$i
  cd $target
  branch=$(git branch --show-current)
  echo "\033[47;30m{$target}:{$branch}\033[0m is pulling ......."

  if [ $branch != $TBRANCH ]; then
    if git checkout $TBRANCH; then
        echo "\033[44;37mcheckout {$TBRANCH}\033[0m"
    else
        echo "\033[41;37mcheckout {$TBRANCH}failed!\033[0m"
        exit 1
    fi    
  fi

  if git pull; then
    echo "\033[42;37m{$target} success to pull\033[0m"
    cd build/tizen
    if [ $target = "dali-csharp-binder" ]; then
        if [ ! -e Makefile ]; then
            if [ ! autoreconf --install ]; then
                exit 3
            fi
            if [ ! ./configure --prefix=$DESKTOP_PREFIX ]; then
                exit 3
            fi
        fi
        if make -j8 install; then
            echo "\033[42;31mbuild success!\033[0m"
        else
            echo "\033[41;35mbulid failed!\033[0m"
            exit 3
        fi
    else
        if [ ! -e build.ninja ]; then
            if [ ! cmake -DCMAKE_INSTALL_PREFIX=$DESKTOP_PREFIX . -GNinja ]; then
               exit 3
            fi
        fi
        if ninja install; then
            echo "\033[42;31mbuild success!\033[0m"
        else
            echo "\033[41;35mbulid failed!\033[0m"
            exit 3
        fi
    fi
    cd ../..
  else
    echo "\033[41;37m{$target} failed to pull\033[0m"
    exit 2
  fi
  cd ..
#  echo $target
done
echo "\033[42;34m=================================\033[0m"
echo "\033[42;34m=BUILD IS SUCCESSFULLY FINISHED!=\033[0m"
echo "\033[42;34m=================================\033[0m"
