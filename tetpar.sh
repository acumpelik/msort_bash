#!/bin/bash


mul(){
if [ $smpl = 100 ]
then
mull=1
else
  if [ $smpl = 50 ] || [ $smpl = 42 ]
        then
        mull=2
        else
    if [ $smpl = 25 ]
    then
        mull=3
    fi
  fi
fi


let res=$1*$mull

echo $res
}

list(){ 
ref=8  #refractoriness after detection
rms=2  #rms integration wind fro detection
thres=4. # 6. detection thershold 
winl=16 #extraction window for spike
winm=8 #middle of the extraction window
pwinl=10 # window to search for spike peak
pwinm=5 # middle of the peak window
slenb=4 # samples before peak to be used at eigen
slena=4 # samples after peak to be used at eigen
einsm=16 # number of samples used at eigen
freqhi=`awgetxy $1.par 2 2`

echo $chno $chpr $smpl  >./tet$i/tet$i.par.$i
col=""
for ii in `count 2 $coln`
 do
 col=$col" "`awgetxy $1.par $rown $ii`
 done
echo $col  >>./tet$i/tet$i.par.$i
echo `mul $ref` `mul $rms`  >>./tet$i/tet$i.par.$i
echo $thres  >>./tet$i/tet$i.par.$i
echo `mul $winl` `mul $winm`  >>./tet$i/tet$i.par.$i
echo `mul $pwinl` `mul $pwinm`  >>./tet$i/tet$i.par.$i
echo `mul $slena` `mul $slenb`  >>./tet$i/tet$i.par.$i
npca=3

if [ $chpr -lt 4 ]
then
npca=4
fi

if [ $chpr = 1 ]
then
npca=5
fi

echo $npca $einsm  >>./tet$i/tet$i.par.$i
echo $freqhi  >>./tet$i/tet$i.par.$i
}


chno=`awgetxy $1.par 1 1` # no of channels in the file
bit=`awgetxy $1.par 1 2`
smpl=`awgetxy $1.par 2 1` # sampling rate of the file
nel=`awgetxy $1.par 3 1` # no of electrodes in the file

for i in `count 1 $nel`
do
let rown=$i+3
chpr=`awgetxy $1.par $rown 1` # no of electrodes in the file
let coln=$chpr+1

list $1
done

