#!/bin/bash

set -e

folders="\
DateFormatLocalizable \
HMLabLocalizable \
HMThirdAuthLocalizable \
HomeLocalizable \
HuamiLocalizable \
MIDongWatchLocalizable \
MiDongLocalizable \
MineLocalizable \
PublicLocalizable \
RunLocalizable \
SimplifiedChineseLocalizable \
SmartPlayLocalizable \
StarrySkyLocalizable \
WeatherLocalizable \
WalletLocalization \
WatchNFCLocalizable \
EidLocalization \
HMNFCCardemu \
BankCardLocalization \
"

for i in $(echo $folders);do

    cp -r ~/midong/MiFit/Localizable/$i/zh-Hans.lproj ~/AmazfitWatchLocalizedString/HMTranslate/Assets/Localizable/$i/
    cp -r ~/midong/MiFit/Localizable/$i/en.lproj ~/AmazfitWatchLocalizedString/HMTranslate/Assets/Localizable/$i/

done